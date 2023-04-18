GPU Virtualization Guide
========================

.. contents::

.. |ATS-M| replace:: Intel® Data Center GPU Flex Series
.. _ATS-M: https://ark.intel.com/content/www/us/en/ark/products/series/230021/intel-data-center-gpu-flex-series.html

Overview
--------

This guide describes 2 types of GPU Virtualization setup:

* GPU Passthrough Virtualization

* GPU SR-IOV Virtualization

The first one, GPU Passthrough Virtualization, is a legacy Virtualization
Technology which allows exclusive access to GPU under Virtual Machine (VM).
GPU SR-IOV Virtualization is a new technology available in modern
Intel GPUs such as |ATS-M|_.

+-----------------------------------------------+----------------+------------+
| Intel GPU                                     | GPU Passtrough | GPU SR-IOV |
+===============================================+================+============+
| gen8-gen11 (such as BDW, SKL, KBL, CFL, etc.) | |check|        | |cross|    |
+-----------------------------------------------+----------------+------------+
| TGL                                           | |check|        | |cross|    |
+-----------------------------------------------+----------------+------------+
| DG1                                           | |check|        | |cross|    |
+-----------------------------------------------+----------------+------------+
| Alder Lake                                    | |check|        | |check|    |
+-----------------------------------------------+----------------+------------+
| Alchemist                                     | |check|        | |cross|    |
+-----------------------------------------------+----------------+------------+
| ATS-M                                         | |check|        | |check|    |
+-----------------------------------------------+----------------+------------+

.. |check| raw:: html

   &#x2713;

.. |cross| raw:: html

   &#x2717;

In this article we will provide VM setup instructions assuming the following:

* Ubuntu 20.04 is the Operating System being installed both for the host and VM
* Setup is done on |ATS-M|_


Host BIOS Setup
---------------

Virtualization support might need to be enabled in host BIOS. Below we provide
key settings to enable and tune virtualization. Mind that available options and
their placement depends on the BIOS manufacturer.

For `Intel® Server M50CYP Family <https://ark.intel.com/content/www/us/en/ark/products/series/200321/intel-server-m50cyp-family.html>`_::

    Advanced -> Processor Configuration -> Intel(R) Virtualization Technology: Enabled
    Advanced -> Integrated IO Configuration -> Intel(R) VT for Directed I/O : Enabled
    Advanced -> PCI Configuration -> SR-IOV Support : Enabled
    Advanced -> PCI Configuration -> Memory Mapped I/O above 4GB : Enabled
    Advanced -> PCI Configuration -> MMIO High Base : 56T
    Advanced -> PCI Configuration -> Memory Mapped I/O Size : 1024G
    Advanced -> System Acoustic and Performance Configuration -> Set Fan Profile: Performance

GPU Passthough Virtualization
-----------------------------

Virtual Machine (VM) setup with GPU passthrough is a type of setup which
allows exclusive access to GPU under VM. Mind that with this setup
only one VM to which GPU was explicitly assigned will be able to use GPU.
Other VMs and even a host will not have full access to the GPU.

One of the advantages of this setup is that there are much less requirements
to the host kernel which don't need to be capable to support all the GPU
features (i.e. respective GPU kernel mode driver, like i915, don't need to
support the GPU). Basically, host kernel must be capable to recognize the
GPU device and support virtualization for it. Actual GPU support is pushed
to VM kernel which of course needs to have kernel mode driver and user space
stack capable to work with the device.

Host Setup
~~~~~~~~~~

* Install Ubuntu 20.04 on Host

* As noted above, there are limited requirements for the host kernel to support
  legacy GPU Passthrough Virtualization. For ATS-M this instruction was validated
  with the following kernels:

  * 5.15.0-53-generic

* Check that desired GPU is detected and find it's device ID and PCI slot (in
  the example below``56C0`` and ``4d:00.0`` respectively)::

    $ lspci -nnk | grep -A 3 -E "VGA|Display"
    02:00.0 VGA compatible controller [0300]: ASPEED Technology, Inc. ASPEED Graphics Family [1a03:2000] (rev 41)
            DeviceName: ASPEED AST2500
            Subsystem: ASPEED Technology, Inc. ASPEED Graphics Family [1a03:2000]
            Kernel driver in use: ast
    --
    4d:00.0 Display controller [0380]: Intel Corporation Device [8086:56c0] (rev 08)
            Subsystem: Intel Corporation Device [8086:4905]

    $ DEVID=56C0
    $ PCISLOT=4d:00.0

* Bind desired GPU device to ``vfio-pci`` driver by modifying kernel boot command line::

    # This will add the following options to Linux cmdline:
    #   intel_iommu=on iommu=pt vfio-pci.ids=8086:56C0 pcie_ports=native
    #
    if ! grep "intel_iommu=on" /etc/default/grub | grep -iq "8086:56C0"; then
    sudo sed -ine \
      's,^GRUB_CMDLINE_LINUX_DEFAULT="\([^"]*\)",GRUB_CMDLINE_LINUX_DEFAULT="\1 intel_iommu=on iommu=pt vfio-pci.ids=8086:56C0 pcie_ports=native",g' \
      /etc/default/grub
    fi
    grep GRUB_CMDLINE_LINUX_DEFAULT /etc/default/grub

* Update grub and reboot::

    sudo update-grub && sudo reboot

* After reboot verify that GPU device was binded to ``vfio-pci`` driver::

    $ lspci -nnk | grep -A 3 -i 56C0
    4d:00.0 Display controller [0380]: Intel Corporation Device [8086:56c0] (rev 08)
        Subsystem: Intel Corporation Device [8086:4905]
        Kernel driver in use: vfio-pci
        Kernel modules: intel_vsec, i915

* Install virtualization environment::

    sudo apt-get update
    sudo apt-get install qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils virtinst ovmf

Now you should be ready to create and use VM with GPU Passthrough Virtualization.

VM Setup
~~~~~~~~

* Download Ubuntu 20.04 ISO image to the host folder::

    sudo mkdir -p /opt/vmimage
    sudo chown -R $(id -u):$(id -g) /opt/vmimage
    wget -P /opt/vmimage https://releases.ubuntu.com/20.04.5/ubuntu-20.04.5-live-server-amd64.iso

* Create disk image file for your VM (set size according to your needs,
  we will use 50G as an example)::

    HDD_NAME="ubuntu-hdd"
    qemu-img create -f qcow2 /opt/vmimage/$HDD_NAME.qcow2 50G

* Run VM and install Ubuntu 20.04 in it::

    sudo su

    VM_IMAGE=/opt/vmimage/ubuntu-hdd.qcow2
    HOST_IP=$(hostname -I | cut -f1 -d ' ')
    VNC_PORT=40
    qemu-system-x86_64 -enable-kvm -drive file=$VM_IMAGE \
      -cpu host -smp cores=8 -m 64G -serial mon:stdio \
      -device vfio-pci,host=4d:00.0 \
      -net nic -net user,hostfwd=tcp::10022-:22,hostfwd=tcp::8080-:8080 \
      -vnc $HOST_IP:$VNC_PORT \
      -cdrom /opt/vmimage/ubuntu-20.04.5-live-server-amd64.iso 

  Upon execution you should be able to connect to VM via VNC using ``$HOST_IP:$VNC_PORT``.
  Under VNC, proceed with typical Ubuntu installation. To enable access to VM
  via SSH don't forget to install ``openssh-server``. SSH access should be possible
  from the host as follows::

    ssh -p 10022 localhost

  Mind that we also forward port ``8080`` which is required for Media Delivery demo to run.

* Once installation is complete, turn off the VM and restart without installation media::

    sudo su

    VM_IMAGE=/opt/vmimage/ubuntu-hdd.qcow2
    HOST_IP=$(hostname -I | cut -f1 -d ' ')
    VNC_PORT=40
    qemu-system-x86_64 -enable-kvm -drive file=$VM_IMAGE \
      -cpu host -smp cores=8 -m 64G -serial mon:stdio \
      -device vfio-pci,host=4d:00.0 \
      -net nic -net user,hostfwd=tcp::10022-:22,hostfwd=tcp::8080-:8080 \
      -vnc $HOST_IP:$VNC_PORT

At this point you should have a running VM with an attached GPU in passthrough mode.
You can check that GPU is actually available by looking into ``lspci`` output::

    $ lspci -nnk | grep -A 3 -i 56C0
    00:04.0 Display controller [0380]: Intel Corporation Device [8086:56c0] (rev 08)
            Subsystem: Intel Corporation Device [8086:4905]

To be able to use GPU device you might need to install additional software following
bare metal setup instructions. For example, to setup Intel® Data Center GPU Flex Series
(products formerly Arctic Sound) refer to `this guide <intel-gpu-dkms.rst>`__.

GPU SR-IOV Virtualization
-------------------------

Virtual Machine (VM) setup with GPU SR-IOV Virtualization is a type of setup which
allows non-exclusive time-sliced access to GPU from under VM. GPU SR-IOV Virtualization
can be used to setup multiple VMs (and a host) with the access to the same GPU. It's
possible to assign GPU resource limitations to each VM.

This variant of GPU virtualization setup requires **host kernel to fully
support underlying GPU**.

Host Setup
~~~~~~~~~~

* Install Ubuntu 20.04 on Host

* Follow `this guide <intel-gpu-dkms.rst>`__ to enable Intel® Data Center
  GPU Flex Series (products formerly Arctic Sound) under the host.

* Check that desired GPU is detected and find it's device ID and PCI slot (in
  the example below ``56C0`` and ``4d:00.0`` respectively)::

    $ lspci -nnk | grep -A 3 -E "VGA|Display"
    02:00.0 VGA compatible controller [0300]: ASPEED Technology, Inc. ASPEED Graphics Family [1a03:2000] (rev 41)
            DeviceName: ASPEED AST2500
            Subsystem: ASPEED Technology, Inc. ASPEED Graphics Family [1a03:2000]
            Kernel driver in use: ast
    --
    4d:00.0 Display controller [0380]: Intel Corporation Device [8086:56c0] (rev 08)
            Subsystem: Intel Corporation Device [8086:4905]
            Kernel driver in use: i915
            Kernel modules: i915, intel_vsec

    $ DEVID=56C0
    $ PCISLOT=4d:00.0

* Enable SR-IOV support by specifying number of virtual GPU cards (VFs) you want to get (mind
  ``i915.mfx_vfs`` option)::

    # This will add the following options to Linux cmdline:
    #   intel_iommu=on iommu=pt i915.max_vfs=31
    #
    if ! grep "intel_iommu=on" /etc/default/grub | grep -iq "8086:56C0"; then
    sudo sed -ine \
      's,^GRUB_CMDLINE_LINUX_DEFAULT="\([^"]*\)",GRUB_CMDLINE_LINUX_DEFAULT="\1 intel_iommu=on iommu=pt i915.max_vfs=31",g' \
      /etc/default/grub
    fi
    grep GRUB_CMDLINE_LINUX_DEFAULT /etc/default/grub

  Note: older versions of i915 kernel driver did require ``i915.enable_guc=7`` option to enable
  SRIOV support. Some versions might support both and report ``enable_guc`` as deprecated. See

* Update grub and reboot::

    sudo update-grub && sudo reboot

* Verify that i915 driver was loaded with SR-IOV support::

    $ dmesg | grep i915 | grep PF
    [   21.116941] i915 0000:4d:00.0: Running in SR-IOV PF mode
    [   21.509331] i915 0000:4d:00.0: 31 VFs could be associated with this PF

  From this output you can also check how many VMs can be configured (31 in total).

Now you should be ready to create and use VM with GPU SR-IOV Virtualization.

VM Resource Allocation
~~~~~~~~~~~~~~~~~~~~~~

The essential part of SR-IOV setup is resource allocation for each VM. We will
describe the trivial case of creating 1 VM relying on kernel mode driver auto provisioning
which distributes resources equally for each VM.

* Check card number assigned to GPU device::

    $ ls -l /dev/dri/by-path/ | grep -o pci-0000:4d:00.0-.*
    pci-0000:4d:00.0-card -> ../card1
    pci-0000:4d:00.0-render -> ../renderD128

* Allocate doorbells, contexts, ggtt and local memory for VM::

    sudo su

    CARD=/sys/class/drm/card1

    echo 0 > $CARD/device/sriov_drivers_autoprobe
    echo 1 > $CARD/iov/pf/device/sriov_numvfs

* Create VFIO-PCI, run below commands (change underlined values as
  appropriate for the location of the GPU card in the system)::

    sudo su

    CARD=/sys/class/drm/card1
    DEVICE=$(basename $(readlink -f $CARD/device/virtfn0))

    modprobe vfio-pci
    echo vfio-pci > /sys/bus/pci/devices/$DEVICE/driver_override
    echo $DEVICE > /sys/bus/pci/drivers_probe

* Verify that "new" SR-IOV GPU device has appeared (``4d:00.1``) and was binded with ``vfio-pci`` driver::

    $ lspci -nnk | grep -A 3 -i 56C0
    4d:00.0 Display controller [0380]: Intel Corporation Device [8086:56c0] (rev 08)
            Subsystem: Intel Corporation Device [8086:4905]
            Kernel driver in use: i915
            Kernel modules: i915, intel_vsec
    4d:00.1 Display controller [0380]: Intel Corporation Device [8086:56c0] (rev 08)
            Subsystem: Intel Corporation Device [8086:4905]
            Kernel driver in use: vfio-pci
            Kernel modules: i915, intel_vsec

Consider that not all resources can be given to VMs. Some resources are used by PF (for example, for FW).
Also, kernel mode driver keeps some resources reserved for PF.

You can further configure resource allocation for VMs in 2 ways:

* Increase resources reserved for PF which will eventually reduce what you will be able to use for VMs::

    sudo su
    CARD=/sys/class/drm/card1

    echo BYTES > $CARD/prelim_iov/pf/gt/lmem_spare
    # consider other "*_spare" resources...

* Explicitly allocate resources for each VM::

    sudo su
    CARD=/sys/class/drm/card1

    echo BYTES > $CARD/prelim_iov/vf1/gt/lmem_quota

Kernel mode driver will reject resource values that are too high or too low.

Another aspect you might wish to tune for your VMs is scheduling settings. Pay attention to execution
quantum and preemption timeout. By default auto provisioning leaves them 0 (unlimited), try out 20ms
and 4000us for exec quantum and preemption timeout respectively::

    sudo su
    CARD=/sys/class/drm/card1

    echo 20 > $CARD/prelim_iov/pf/gt/exec_quantum_ms
    echo 40000 > $CARD/prelim_iov/pf/gt/preempt_timeout_us

    echo 20 > $CARD/prelim_iov/vf1/gt/exec_quantum_ms
    echo 40000 > $CARD/prelim_iov/vf1/gt/preempt_timeout_us

VM Setup
~~~~~~~~

* Download Ubuntu 20.04 ISO image to the host folder::

    sudo mkdir -p /opt/vmimage
    sudo chown -R $(id -u):$(id -g) /opt/vmimage
    wget -P /opt/vmimage https://releases.ubuntu.com/20.04.5/ubuntu-20.04.5-live-server-amd64.iso

* Create disk image file for your VM (set size according to your needs,
  we will use 50G as an example)::

    HDD_NAME="ubuntu-hdd"
    qemu-img create -f qcow2 /opt/vmimage/$HDD_NAME.qcow2 50G

* Run VM and install Ubuntu 20.04 in it (mind SR-IOV device ``4d:00.1`` we've setup in
  previous paragraph)::

    sudo su

    VM_IMAGE=/opt/vmimage/ubuntu-hdd.qcow2
    HOST_IP=$(hostname -I | cut -f1 -d ' ')
    VNC_PORT=40
    qemu-system-x86_64 -enable-kvm -drive file=$VM_IMAGE \
      -cpu host -smp cores=8 -m 64G -serial mon:stdio \
      -device vfio-pci,host=4d:00.1 \
      -net nic -net user,hostfwd=tcp::10022-:22,hostfwd=tcp::8080-:8080 \
      -vnc $HOST_IP:$VNC_PORT \
      -cdrom /opt/vmimage/ubuntu-20.04.5-live-server-amd64.iso

  Upon execution you should be able to connect to VM via VNC using ``$HOST_IP:$VNC_PORT``.
  Under VNC, proceed with typical Ubuntu installation. To enable access to VM
  via SSH don't forget to install ``openssh-server``. SSH access should be possible
  from the host as follows::

    ssh -p 10022 localhost

  Mind that we also forward port ``8080`` which is required for Media Delivery demo to run.

* Once installation is complete, turn off the VM and restart without installation media::

    sudo su

    VM_IMAGE=/opt/vmimage/ubuntu-hdd.qcow2
    HOST_IP=$(hostname -I | cut -f1 -d ' ')
    VNC_PORT=40
    qemu-system-x86_64 -enable-kvm -drive file=$VM_IMAGE \
      -cpu host -smp cores=8 -m 64G -serial mon:stdio \
      -device vfio-pci,host=4d:00.1 \
      -net nic -net user,hostfwd=tcp::10022-:22,hostfwd=tcp::8080-:8080 \
      -vnc $HOST_IP:$VNC_PORT

At this point you should have a running VM with an attached GPU in SR-IOV mode.
You can check that GPU is actually available by looking into ``lspci`` output::

    $ lspci -nnk | grep -A 3 -i 56C0
    00:03.0 Display controller [0380]: Intel Corporation Device [8086:56c0] (rev 08)
            Subsystem: Intel Corporation Device [8086:4905]

To be able to use GPU device you might need to install additional software following
bare metal setup instructions. For example, to setup Intel® Data Center GPU Flex Series
(products formerly Arctic Sound) refer to `this guide <intel-gpu-dkms.rst>`_.

Troubleshoot Tips
-----------------

* You can valide whether you properly enabled virtualization (in BIOS and in your
  Operating System) by running ``virt-host-validate``. You should see below output::

    $ sudo virt-host-validate | grep QEMU
      QEMU: Checking for hardware virtualization                                 : PASS
      QEMU: Checking if device /dev/kvm exists                                   : PASS
      QEMU: Checking if device /dev/kvm is accessible                            : PASS
      QEMU: Checking if device /dev/vhost-net exists                             : PASS
      QEMU: Checking if device /dev/net/tun exists                               : PASS
      QEMU: Checking for cgroup 'cpu' controller support                         : PASS
      QEMU: Checking for cgroup 'cpuacct' controller support                     : PASS
      QEMU: Checking for cgroup 'cpuset' controller support                      : PASS
      QEMU: Checking for cgroup 'memory' controller support                      : PASS
      QEMU: Checking for cgroup 'devices' controller support                     : PASS
      QEMU: Checking for cgroup 'blkio' controller support                       : PASS
      QEMU: Checking for device assignment IOMMU support                         : PASS
      QEMU: Checking if IOMMU is enabled by kernel                               : PASS
      QEMU: Checking for secure guest support                                    : WARN (Unknown if this platform has Secure Guest support)

* If you would like to monitor VM bootup process or you can't connect to VM with
  VNC or SSH, serial console might be very useful. To enable it:

  * Make sure  to start VM with ``-serial mon:stdio`` option (we have it in
    ``qemu-system-x86_64`` cmdlines above)

  * Enable serial console inside the VM modifying Linux kernel cmdline::

      # This will add the following options to Linux cmdline:
      #   console=ttyS0,115200n8
      #
      if ! grep "intel_iommu=on" /etc/default/grub | grep -iq "8086:56C0"; then
      sudo sed -ine \
          's,^GRUB_CMDLINE_LINUX_DEFAULT="\([^"]*\)",GRUB_CMDLINE_LINUX_DEFAULT="\1 console=ttyS0\,115200n8",g' \
          /etc/default/grub
      fi
      grep GRUB_CMDLINE_LINUX_DEFAULT /etc/default/grub

  * Update grub and reboot the VM. You should see bootup process followed by
    serial console terminal prompt::

      sudo update-grub && sudo reboot

* You might consider to run VM in a headless mode without VNC::

    qemu-system-x86_64 -enable-kvm -drive file=$VM_IMAGE \
      -cpu host -smp cores=8 -m 64G -serial mon:stdio \
      -vga none -nographic \
      -net nic -net user,hostfwd=tcp::10022-:22,hostfwd=tcp::8080-:8080 \
      -device vfio-pci,host=4d:00.0

  In this case you can find that network is not available. This is happening
  because network interface changes it's name from ``ens3`` (with ``-vnc``)
  to ``ens2`` (with headless). To diagnose this, verify which inerface is
  available::

    $ ip a
    1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
        link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
        inet 127.0.0.1/8 scope host lo
           valid_lft forever preferred_lft forever
        inet6 ::1/128 scope host
           valid_lft forever preferred_lft forever
    2: ens3: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
        link/ether 52:54:00:12:34:56 brd ff:ff:ff:ff:ff:ff
        altname enp0s3
    3: docker0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state DOWN group default
        link/ether 02:42:04:4c:f4:f1 brd ff:ff:ff:ff:ff:ff
        inet 172.17.0.1/16 brd 172.17.255.255 scope global docker0
           valid_lft forever preferred_lft forever

  And make sure that this interface is actually listed in the the following file.
  Adjust accordingly if needed. After reboot network should be functional. In the
  example below, configuration needs to be changed from ``ens2`` to ``ens3``::

    $ /etc/netplan/00-installer-config.yaml
    # This is the network config written by 'subiquity'
    network:
      ethernets:
        ens2:
          dhcp4: true
      version: 2

Known Limitations
-----------------

* `intel-gpu-i915-backports#57 <https://github.com/intel-gpu/intel-gpu-i915-backports/issues/57>`_:
  VNC connection to VM might get broken (will stuck not showing user prompt) both for Passthrough
  and SR-IOV after installing Intel DKMS modules of 476.14 or later series over 5.15.0-generic-50 or
  later Ubuntu kernel version.

