Intel GPU DKMS
==============

It is required to install special Kernel Mode Drivers (KMD) to enable support of some new Intel GPUs.
This article describes setup of these KMDs targeting the following GPUs:

* Intel® Data Center GPU Flex Series (products formerly Arctic Sound)

Overall, the following should be taken care of:

* `Intel GPU Firmware <https://github.com/intel-gpu/intel-gpu-firmware>`_
* `Backport of i915 Graphics Driver <https://github.com/intel-gpu/intel-gpu-i915-backports>`_
* `Backport of Converged Security Engine Driver <https://github.com/intel-gpu/intel-gpu-cse-backports>`_
* `Backport of Intel Platform Telemetry Driver <https://github.com/intel-gpu/intel-gpu-pmt-backports>`_

DKMS packages are being built against specific kernel version. Please, refer to documentation
in above projects for the full list of supported Operating Systems and kernels. In this
article we will demonstrate installation for specific kernel version(s) of Ubuntu 20.04 and 22.04.

How to Generate DKMS Packages
-----------------------------

To generate DKMS packages you can use helper dockers available in media-delivery repository:

+--------------+-------------------------------------------------------------------------------+
| OS           | Dockerfile                                                                    |
+==============+===============================================================================+
| Ubuntu 20.04 | `docker/ubuntu20.04/dkms/Dockerfile <../docker/ubuntu20.04/dkms/Dockerfile>`_ |
+--------------+-------------------------------------------------------------------------------+
| Ubuntu 22.04 | `docker/ubuntu22.04/dkms/Dockerfile <../docker/ubuntu22.04/dkms/Dockerfile>`_ |
+--------------+-------------------------------------------------------------------------------+

Run the following from the top level of media-delivery cloned copy::

  # To build DKMS for Ubuntu 20.04
  docker build \
    $(env | grep -E '(_proxy=|_PROXY)' | sed 's/^/--build-arg /') \
    --file docker/ubuntu20.04/dkms/Dockerfile \
    --tag dkms \
    .

  # To build DKMS for Ubuntu 22.04
  docker build \
    $(env | grep -E '(_proxy=|_PROXY)' | sed 's/^/--build-arg /') \
    --file docker/ubuntu22.04/dkms/Dockerfile \
    --tag dkms \
    .


Copy Intel GPU DKMS packages to the host system::

  sudo mkdir -p /opt/packages/
  sudo chown -R $(id -u):$(id -g) /opt/packages
  docker run -it --rm -u $(id -u):$(id -g) -v /opt/packages/:/opt/packages/ dkms \
    /bin/bash -c "cp -rd /opt/dist/* /opt/packages/"

How to Install
--------------

First, install the following Ubuntu kernel (this kernel version corresponds to the
version used below to build DKMS packages) and its headers::

  # For Ubuntu 20.04 or Ubuntu 22.04
  sudo apt-get update
  sudo apt-get install linux-headers-5.15.0-53-generic linux-image-unsigned-5.15.0-53-generic

Once done, check kernel boot order in grub to make sure to boot into the installed kernel,
adjust if needed, then reboot::

  sudo reboot

Install Intel GPU Firmware and DKMS packages::

  sudo apt-get install dkms bison flex gawk

  sudo mkdir -p /lib/firmware/updates/i915/
  sudo cp /opt/packages/firmware/*.bin /lib/firmware/updates/i915/
  sudo dpkg -i /opt/packages/intel-i915-dkms_*.deb \
    /opt/packages/intel-platform-cse-dkms-*.deb \
    /opt/packages/intel-platform-vsec-dkms-*.deb

Some systems running Intel® Data Center GPU Flex Series might require to be booted
with ``pci=realloc=off`` Linux kernel cmdline option to be able to detect this GPU card.
Add this option as follows::

  if ! grep "pci=realloc" /etc/default/grub; then
    sudo sed -ine \
      's,^GRUB_CMDLINE_LINUX_DEFAULT="\([^"]*\)",GRUB_CMDLINE_LINUX_DEFAULT="\1 pci=realloc=off",g' \
      /etc/default/grub
  fi
  grep GRUB_CMDLINE_LINUX_DEFAULT /etc/default/grub

Once done, update grub and reboot::

  sudo update-grub && sudo reboot

That's it. Now you should be able to use Intel GPU targeted by these DKMS packages.

How to Update
-------------

To install new version of DKMS packages, just follow the usual installation steps. Package
manager automatically uninstalls previous version, then installs a new one.

When updating the entire kernel, make sure to install the corresponding kernel headers. DKMS
installation builds kernel modules which require corresponding kernel headers. So, when
updating the kernel, make sure to always install both kernel and its headers. For example,
to update from Ubuntu 20.04 5.15.0-53-generic to 5.15.0-58-generic kernel do::

  sudo apt-get update
  sudo apt-get install linux-headers-5.15.0-58-generic linux-image-unsigned-5.15.0-58-generic

Verify
------

To verify that DKMS were installed correctly, check ``dmesg`` logs right after the boot. First,
verify that DKMS driver backports got recognized and loaded::

  $ sudo dmesg | grep -i backport
  [    7.873241] COMPAT BACKPORTED INIT
  [    7.873247] Loading modules backported from PROD_I915_6365.0.0
  [    7.873249] Backport generated by backports.git I915_6365.0.0_PRERELEASE_221124.0
  [    8.018045] [drm] I915 BACKPORTED INIT

Then, check that GPU stack got initialized for your platform::

  $ sudo dmesg | grep drm
  [    8.018045] [drm] I915 BACKPORTED INIT
  [    8.022708] i915 0000:4d:00.0: [drm] GT count: 1, enabled: 1
  [    8.023250] i915 0000:4d:00.0: [drm] Bumping pre-emption timeout from 640 to 7500 on rcs'0.0 to allow slow compute pre-emption
  [    8.023303] i915 0000:4d:00.0: [drm] Bumping pre-emption timeout from 640 to 7500 on ccs'0.0 to allow slow compute pre-emption
  [    8.023307] i915 0000:4d:00.0: [drm] Bumping pre-emption timeout from 640 to 7500 on ccs'1.0 to allow slow compute pre-emption
  [    8.023318] i915 0000:4d:00.0: [drm] Bumping pre-emption timeout from 640 to 7500 on ccs'2.0 to allow slow compute pre-emption
  [    8.023322] i915 0000:4d:00.0: [drm] Bumping pre-emption timeout from 640 to 7500 on ccs'3.0 to allow slow compute pre-emption
  [    8.023896] i915 0000:4d:00.0: [drm] Using Transparent Hugepages
  [    8.024034] i915 0000:4d:00.0: [drm] Local memory IO size: 0x000000037a800000
  [    8.024039] i915 0000:4d:00.0: [drm] Local memory available: 0x000000037a800000
  [    8.031770] i915 0000:4d:00.0: [drm] GuC error state capture buffer maybe too small: 2097152 < 3737592 (min = 1245864)
  [    8.038493] i915 0000:4d:00.0: [drm] GuC firmware i915/dg2_guc_70.5.2.bin version 70.5.2
  [    8.038501] i915 0000:4d:00.0: [drm] HuC firmware i915/dg2_huc_7.10.3_gsc.bin version 7.10.3
  [    8.051908] i915 0000:4d:00.0: [drm] GuC submission enabled
  [    8.051917] i915 0000:4d:00.0: [drm] GuC SLPC enabled
  [    8.052236] i915 0000:4d:00.0: [drm] GuC RC: enabled
  [    8.083832] [drm] Initialized i915 1.6.0 20201103 for 0000:4d:00.0 on minor 1
  [    9.020137] i915 0000:4d:00.0: [drm] HuC authenticated


In the above log make sure that:

* GuC, HuC and DMC Firmware was loaded (note: ATS-M reuses DG2 firmware)
* HuC got authenticated

Once host setup is done, you can try media-delivery sample included in this repository. Refer
to the top level `README <../README.rst>`_ for details. In short, to build docker compatible with the
host setup we just did, execute (from the top level of media-delivery cloned copy)::

  docker build \
    $(env | grep -E '(_proxy=|_PROXY)' | sed 's/^/--build-arg /') \
    --file docker/ubuntu20.04/selfbuild-prodkmd/Dockerfile \
    --tag intel-media-delivery \
    .

Change Log
----------

This log tracks key changes in Intel DKMS modules which impact user experience.

518.5
~~~~~

Referenced in the following Media Delivery Software Stack release series:

* https://github.com/intel/media-delivery/tree/master

Included versions:

* https://github.com/intel-gpu/intel-gpu-i915-backports/releases/tag/I915_22WW51.5_518.5_6365.0.0_221124.0
* https://github.com/intel-gpu/intel-gpu-cse-backports/releases/tag/22WW51.5_518.5_UBUNTU517
* https://github.com/intel-gpu/intel-gpu-pmt-backports/releases/tag/22WW51.5_518.5_fix_1_MAIN
* https://github.com/intel-gpu/intel-gpu-firmware/releases/tag/22WW51.5_518.5
* And other tags with "518" in the name

Changes:

* ``/sys/class/drm/card%/iov/pf/gt/available/*_quota`` PF attributes got deprecated and might be removed in
  the future. Instead, use the following 2 ways to allocate VF resources:

  * Use ``/sys/class/drm/card%/prelim_iov/pf/gt/*_spare`` to specify resources reserved for PF. This will reduce
    the amount of resources you can spend for VFs

  * Use ``/sys/call/drm/card%/prelim_iov/vf%/gt/*_quota`` to explicitly specify the amount of resources
    available for VFs

  You can also rely on kernel mode driver auto provisioning to distribute resources across VMs (which is fair
  distribution). However, consider to tune execution quantum and preemption timeout settings for the real life
  use cases. By default auto provisioning leaves them 0 (unlimited), try out 20ms and 4000us for exec quantum
  and preemption timeout respectively::

    echo 20 > /sys/class/drm/card%/prelim_iov/pf/gt/exec_quantum_ms
    echo 40000 > /sys/class/drm/card%/prelim_iov/pf/gt/preempt_timeout_us

    echo 20 > /sys/class/drm/card%/prelim_iov/vf%/gt/exec_quantum_ms
    echo 40000 > /sys/class/drm/card%/prelim_iov/vf%/gt/preempt_timeout_us

476.14
~~~~~~

Referenced in the following Media Delivery Software Stack release series:

* https://github.com/intel/media-delivery/tree/release/3.1

Included versions:

* https://github.com/intel-gpu/intel-gpu-i915-backports/releases/tag/I915_22WW45.5_476.14_6213_220914.4
* https://github.com/intel-gpu/intel-gpu-cse-backports/releases/tag/22WW45.5_476.14_UBUNTU517
* https://github.com/intel-gpu/intel-gpu-pmt-backports/releases/tag/22WW45.5_476.14_UBUNTU517
* And other tags with "476" in the name

Changes:

* ``i915.enable_guc=7`` option got deprecated, ``i915.max_vfs=N`` should be used instead

449.2
~~~~~

We did not pick up this DKMS modules release for Media Delivery Software Stack. Still, there
was the following change to pay attention to:

* ``intel-platform-pmt-dkms`` module renamed to ``intel-platform-vsec-dkms`` - make sure
  to explicitly uninstall "pmt" module before installing "vsec"

Included versions:

* https://github.com/intel-gpu/intel-gpu-i915-backports/releases/tag/UBUNTU2204_22WW37_449_6043_220805.0
* https://github.com/intel-gpu/intel-gpu-cse-backports/releases/tag/22WW40_449.2_UBUNTU517
* https://github.com/intel-gpu/intel-gpu-pmt-backports/releases/tag/22WW40_449.2_UBUNTU517
* And other tags with "449" in the name

419.38
~~~~~~

Referenced in the following Media Delivery Software Stack release series:

* https://github.com/intel/media-delivery/tree/release/3.0

Included versions:

* https://github.com/intel-gpu/intel-gpu-i915-backports/releases/tag/UBUNTU2204_22WW34_419_5949_220707.2
* https://github.com/intel-gpu/intel-gpu-cse-backports/releases/tag/22WW33_419.38_UBUNTU517
* https://github.com/intel-gpu/intel-gpu-pmt-backports/releases/tag/22WW33_419.38_UBUNTU517
* And other tags with "419" in the name

