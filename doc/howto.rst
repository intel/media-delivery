HowTo
=====

.. contents::

Access GPU under container
--------------------------

Under Linux Intel GPU is represented by 2 devices:

* ``/dev/dri/cardN`` (where ``N=0,1,2,...``) is a card node
* ``/dev/dri/renderDN`` (where ``N=0,1,2,...``) is a render node

Card nodes allow work with the display (modesetting), but come with more
strict access control. Render nodes do not allow interactions with the
display, are limited to headless operations and come with relaxed access control.
In Media Delivery samples we use render nodes.

Ran by default docker does not allow access to any devices. To access
all host devices you can run containter with ``--privileged``::

  docker run --privileged <...rest-of-arguments...>

However, this is not recommended way especially for final product
deployments. Instead, it is advised to explicitly list only those device(s)
you need to access under the container::

  docker run --device=/dev/dri <...rest-of-arguments...>

Unfortunately that's only part of the story. Following the above ``root``
will be able to access GPU, but general users might experience problems. To
assure that user can access GPU he should be granted corresponding permissions
to access the device, i.e. he should be added to the group owning the device.

To achieve that use ``--group-add`` docker run comamnd line option::

  DEVICE=${DEVICE:-/dev/dri/renderD128}
  DEVICE_GRP=$(ls -g $DEVICE | awk '{print $3}' | \
    xargs getent group | awk -F: '{print $3}')
  docker run --rm -it \
    --device $DEVICE --group-add $DEVICE_GRP <...rest-of-arguments...>

With that you explicitly grant permissions to access the specified device to
the container user. This is advised way. If you have multiple users under
container and experience issues granting access to all of them, then
consider refactoring container having a single user or break single continer
into few with single user in each. General guidance is: docker container should
be designed to solve specific problem, be as simple as possible, permissions
should be managed explicitly. From this perspective, alternative way to
adjust permissions at runtime with ``usermod`` is not advisable.

Once GPU devices become visible under container you can use them with GPU
capable applications like ffmpeg or Media SDK samples. Typically these
applications have support command line options (``-hwaccel`` and
``-hwaccel_device`` for ffmpeg and ``-device`` for Media SDK samples) to select
specific GPU device if there are few available. Media Delivery containers
support ``DEVICE`` environment variable to adjust the device for the entire
demo::

  DEVICE=${DEVICE:-/dev/dri/renderD128}
  DEVICE_GRP=$(ls -g $DEVICE | awk '{print $3}' | \
    xargs getent group | awk -F: '{print $3}')
  docker run --rm -it \
    -e DEVICE=$DEVICE --device $DEVICE --group-add $DEVICE_GRP \
    <...rest-of-arguments...>

Run Intel GPU Top under container (or how to access GPU Linux perf data)
------------------------------------------------------------------------

Intel GPUs are managed by i915 kernel mode driver which exposes some performance
monitoring data via Linux `perf <https://perf.wiki.kernel.org/index.php/Main_Page>`_
kernel subsystem. There are few levels of statistics data being managed by access
rights. For this demo purposes we collect i915 global metrics, i.e. those
which describe the whole GPU rather than particular running process. Such
metrics require CAP_SYS_ADMIN or ``/proc/sys/kernel/perf_event_paranoid<=0``to be
collected. So, run container as follows to allow GPU metrics collection::

  docker run --cap-add SYS_ADMIN <...rest-of-arguments...>

This docker run command line works along with the following adjustment of
the access rights for those applications which will collect perf metrics::

  setcap cap_sys_admin+ep $(readlink -f $(which perf))
  setcap cap_sys_admin+ep $(readlink -f $(which intel_gpu_top))

This approach won't work however if you start container with
``--security-opt="no-new-privileges:true"`` since it will be considered that
you try to get additional permissions from the executable file. In this
case, please, adjust paranoid setting on the host system::

  echo 0 | sudo tee /proc/sys/kernel/perf_event_paranoid

To make Media Delivery demo functional you need to specify value ``<=0``.

Intel GPU Top (from Intel GPU Tools package) is one of the applications which get
use of i915 Linux perf data. Follow the above BKM to run it.

For further reading on the Linux perf security refer to Linux kernel
`perf-security <https://www.kernel.org/doc/html/latest/admin-guide/perf-security.html>`_
admin guide.

Working under proxy
--------------------

To properly build Media Delivery samples under network proxy, you need to
configure HTTP and HTTPS proxy servers. For example, if you have them specified
in the usual ``http_proxy``, ``https_proxy`` and ``no_proxy`` enviornment variables,
you can pass them to the docker build as ``--build-arg`` arguments. The following
command will slightly automate that::

  docker build \
    $(env | grep -E '(_proxy=|_PROXY)' | sed 's/^/--build-arg /') \
    <...rest-of-arguments...>

These proxy settings will be used to:

1. Access network to fetch OS packages (via ``apt-get`` or similar package manager)
2. Access network to clone some git repositories or download other content

Samples use the `setup-apt-proxy.sh <../assets/setup-apt-proxy>`_ to configure
``apt`` package manager.

Mind that **final image will NOT contain any pre-configured proxy configuration**. This
applies to package manager configuration as well. This is done for the reason that
generated image might run under different network settings comparing to where it
was generated.

Thus, if you will run the container under proxy you will need to pass proxy configuration
into it anew (well, if you will have a need to communicate with the outside network which
is not the case if you just run demo locally and don't play with the container). This
can be done by passing proxy host envronment variables as follows::

  docker run -it \
    $(env | grep -E '(_proxy=|_PROXY)' | sed 's/^/-e /') \
    <...rest-of-arguments...>

If you are going to play around with the container and install additional packages,
configure proxy for package manager. For that you can use the same
`setup-apt-proxy.sh <../assets/setup-apt-proxy>`_ script which actually is included
as one of the assets to the image (at ``$PREFIX/bin`` location, see PREFIX_)::

  sudo -E $(which setup-apt-proxy)

Container volumes (adding your content, access logs, etc.)
----------------------------------------------------------

Containers exposes few volumes which you can use to mount host folders and customize
samples behavior. See table below for the mount points inside a container and required
access rights.

=================== ============= ====================================
Volume              Rights needed Purpose
=================== ============= ====================================
/opt/data/content   Read          Add your media content to the demo
/opt/data/artifacts Read|Write    Access generated content and logs
/var/www/hls        Read|Write    Access server side generated content
=================== ============= ====================================

So, for example if you have some local content in a ``$HOME/media/`` folder which you
wish to play via demo, you can add this folder to the container as follows::

  docker run -it \
    -v $HOME/media:/opt/data/content \
    <...rest-of-arguments...>

In case you want to access container output artifacts (streams, logs, etc.) you need
to give write permissions to the container users. The most stright forward
way would be::

  mkdir $HOME/artifacts && chmod a+w $HOME/artifacts
  docker run -it \
    -v $HOME/artifacts:/opt/data/artifacts \
    <...rest-of-arguments...>

The downside of this approach would be that files will be created by the container
user which is different from the host user, hence host user might not have
access rights to delete them and you will need to use ``sudo`` for that
purpose. Read `managing access rights for container user`_ for better
approach.

Media content requirements
--------------------------

Mounting a host folder to ``/opt/data/content`` inside a container allows you to
access your own media content in demos::

  docker run -it \
    -v $HOME/media:/opt/data/content \
    <...rest-of-arguments...>

This section talks about requirements demos imply for the content.

Bascially demos look for the media files with ``*.mp4`` extension right in the
``/opt/data/content``. They don't look into subfolders.

Video and audio tracks could be encoded with any codecs supported by ffmpeg
decoders. If video codec matches the one supported by Media SDK, then
appropriate ffmpeg-qsv decoder plugin will be used. For audio AAC or MP3 are
recommended.

Managing access rights for container user
-----------------------------------------

Managing permissions between container and a host might be tricky. Remember that the
user you have under container (by default Media Delivery containers have
user account named 'user') generally speaking is not the same user you have
on your host system. Hence, you might have all bunch of access problems that
container user can't write to the host folder or it can write there, but
host user can't delete these files and you are forced to use ``sudo`` to modify
them). The way to handle all that correctly would be to start container
under host user with ``-u $(id -u):$(id -g)``. But here you step into vice versa
problem: host user does not have access to some folder which demo is using since
they are configured for the container default user. To handle this situation, you
need to mount all the folders which demo is using for write access in a way host
user will be able to use them. This can be achieved in the following way::

  DEVICE=${DEVICE:-/dev/dri/renderD128}
  DEVICE_GRP=$(ls -g $DEVICE | awk '{print $3}' | \
    xargs getent group | awk -F: '{print $3}')
  docker run --rm -it \
    -e DEVICE=$DEVICE --device $DEVICE --group-add $DEVICE_GRP \
    --cap-add SYS_ADMIN -p 8080:8080 \
    -u $(id -u):$(id -g) \
    --tmpfs=/opt/data/artifacts:uid=$(id -u) \
    --tmpfs=/opt/data/duplicates:uid=$(id -u) \
    --tmpfs=/var/www/hls:uid=$(id -u) \
    --tmpfs=/var/log/nginx:uid=$(id -u) \
    --tmpfs=/var/lib/nginx:uid=$(id -u) \
    --tmpfs=/tmp \
    intel-media-delivery

We use ``--tmpfs`` above for the simplicity to just highlight which mounts
you need to make. Effectively, it is strongly recommended to mount output
locations for big files (like ``/opt/data/artifacts``, and ``/var/www/hls``
in the example above) as real volumes (with ``-v`` option) pointing to real
folders on a host system disk space.

There is another type of sitation when you need to know exact locations to where
container writes something. That's when you wish to strengthen container security
mounting root file system as read-only (via ``--read-only`` option). Here is
desired command line where we will additionally deny container to gain new
privileges::

  mkdir -p $HOME/output/artifacts
  mkdir -p $HOME/output/hls

  DEVICE=${DEVICE:-/dev/dri/renderD128}
  DEVICE_GRP=$(ls -g $DEVICE | awk '{print $3}' | \
    xargs getent group | awk -F: '{print $3}')
  docker run --rm -it \
    -e DEVICE=$DEVICE --device $DEVICE --group-add $DEVICE_GRP \
    --cap-add SYS_ADMIN -p 8080:8080 \
    -u $(id -u):$(id -g) \
    -v $HOME/output/artifacts:/opt/data/artifacts \
    -v $HOME/output/hls:/var/www/hls \
    --tmpfs=/opt/data/duplicates:uid=$(id -u) \
    --tmpfs=/var/log/nginx:uid=$(id -u) \
    --tmpfs=/var/lib/nginx:uid=$(id -u) \
    --tmpfs=/tmp \
    --security-opt=no-new-privileges:true --read-only \
    intel-media-delivery

Container build time customizations
-----------------------------------

Dockerfiles support a number of arguments to customize the final image. Pass these
arguments as ``docker --build-arg ARGUMENT=VALUE``.

.. _PREFIX:

PREFIX
  Possible values: ``<path>``. Default value: ``/opt/intel/samples``

  Path prefix inside the container to install custom build target and sample
  assets.

DEVEL
  Possible values: `yes|no`. Default value: ``yes``

  Switches on/off development build type with which container user is
  created with sudo privileges.

SAMPLE
  Possible values: ``<path>``. Default value: ``cdn``

  Selects sample to build and install inside the container.

FFMPEG_VERSION
  Possible values: ``<version tag>``. Default value: ``n4.3``

  FFMPEG version to build. Use one of the FFMPEG release tags from https://github.com/FFmpeg/FFmpeg/releases
  or branch name or commit id.

VMAF_VERSION
  Possible values: ``<version tag>``. Default value: ``v1.5.1``

  VMAF version to build. Use one of the VMAF release tags from https://github.com/Netflix/vmaf/releases
  or branch name or commit id.

