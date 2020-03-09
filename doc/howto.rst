Intel Media Deliver Solutions HowTo
===================================

.. contents::

Access GPU under container
--------------------------

Under Linux Intel GPU is represented by 2 devices:

* ``/dev/dri/cardN`` (where ``N=0,1,2,...``) is a card node
* ``/dev/dri/renderDN`` (where ``N=0,1,2,...``) is a render node

Card nodes allow work with the display (modesetting), but come with more
strict access control. Render nodes do not allow interactions with the
display, limited to headless operations and come with relaxed access control.
In this solutions we use render nodes.

Ran by default docker does not allow access to any devices. To access
all host devices run containter with ``--privileged``::

  docker run --privileged <...rest-of-arguments...>

To access only GPU, run::

  docker run --device=/dev/dri <...rest-of-arguments...>

Unfortunately that's only part of the story. Following the above ``root``
will be able to access GPU, but general users might experience problems. To
assure that user can access GPU he should be granted corresponding permissions
to access the device, i.e. he should be added to the group owning the device.
This can be done from inside the container with the following commands (for the
user ``user``)::

  video_grps=$(ls -g /dev/dri/* | awk '{print $3}' | uniq)
  n=0
  for grp in $video_grps; do
    grpname=$grp
    if ! grep "^$grp:" /etc/group >/dev/null; then
      grpname=mds_render$n
      grpname -g $grp $grpname
      n=$((++n))
    fi
    sudo usermod -aG $grpname user  # adjust 'user' name here
  done

Basically, that's what Intel Media Delivery Solutions are doing when you run
demo or enter the container with ``bash``.

If you need to give permissions to the single user at the container launch
time, use ``--group-add`` argument as follows::

  docker run --device=/dev/dri \
    $(ls -g /dev/dri/* | awk '{print $3}' | uniq | \
      xargs getent group | awk -F: '{print $3}' | sed 's/^/--group-add /') \
    <...rest-of-arguments...>

At this point we need to comment complexity while you might be accustomed
to just add user to the ``video`` or ``render`` group (depending on the node type and
underlying OS)? Explanation is the following. In riality device is eventually owned
by host OS which assigned some group to it, let's say ``video``. The point is that
container OS inherits these permissions and group assignment, but ultimately group
is identified by ``GID`` (Group ID) and group name (``video`` in our example) is just
a name assigned by the OS for the user convenience. Let's say that our host OS has
``GID=39`` for the ``video`` group. Now, different distributions have different map
policies between ``GID`` and group names. As an outcome, container OS will see that
device is owned by ``GID=39``, but it might assign different group name. For example,
it might assign ``irc`` group name. You can check assignments in ``/etc/group`` files
in host and container. As a nota bene trust ``GID`` instead of group name when you
manage device access permissions between host and container OS.

The above in-line example is a real example when you run host as CentOS and container
OS as Ubuntu. Here is some log to illustrate what was just explained in
the text::

  #cat /etc/centos-release
  CentOS Linux release 7.7.1908 (Core)

  # ls -al /dev/dri/
  total 0
  drwxr-xr-x.  2 root root        80 Oct 17 02:33 .
  drwxr-xr-x. 19 root root      3580 Oct 17 02:33 ..
  crw-rw----+  1 root video 226,   0 Oct 17 02:33 card0
  crw-rw----+  1 root video 226, 128 Oct 17 02:33 renderD128

  # getent group video
  video:x:39:

  # docker run -it --privileged ubuntu:19.04 ls -al /dev/dri
  total 0
  drwxr-xr-x.  2 root root       80 Jan 30 18:11 .
  drwxr-xr-x. 15 root root     3440 Jan 30 18:11 ..
  crw-rw----.  1 root irc  226,   0 Jan 30 18:11 card0
  crw-rw----.  1 root irc  226, 128 Jan 30 18:11 renderD128

  # docker run -it --privileged ubuntu:19.04 getent group irc video
  irc:x:39:
  video:x:44:

Run Intel GPU Top under container (or how to access GPU Linux perf data)
------------------------------------------------------------------------

Intel GPUs are managed by i915 kernel mode driver which exposes some performance
monitoring data via Linux `perf <https://perf.wiki.kernel.org/index.php/Main_Page>`_
kernel subsystem. There are few detail levels you can access and they are protected
by access rights. i915 driver exposes so called global metrics which means that you
get data describing the whole GPU rather than particular running task. Such global
data is definitely protected by access rights management.

To access Intel GPUs data exposed via Linux perf either run the container with
``--privileged``::

  docker run --privileged <...rest-of-arguments...>

or if you need finer access rights control with ``--cap-add SYS_ADMIN``::

  docker run --cap-add SYS_ADMIN <...rest-of-arguments...>

Intel GPU Top (from Intel GPU Tools package) is one of the applications which get
use of i915 Linux perf data. Follow the above BKM to run it.

Working under proxy
--------------------

To properly build Intel Media Delivery Solutions under network proxy, you need to
configure HTTP and HTTPS proxy servers. For example, if you have them specified
in the usual ``http_proxy``, ``https_proxy`` and ``no_proxy`` enviornment variables,
you can pass them to the docker build as ``--build-arg`` arguments. The following
command will slightly automate that::

  docker build \
    $(env | grep -E '_proxy=' | sed 's/^/--build-arg /') \
    --network=host \
    <...rest-of-arguments...>

These proxy settings will be used to:

1. Access network to fetch OS packages (via ``apt-get`` or similar package manager)
2. Access network to clone some git repositories or download other content

Solutions use the `setup-apt-proxy.sh <../scripts/setup-apt-proxy.sh>`_ to configure
``apt`` package manager.

Mind that **final image will NOT contain any pre-configured proxy configuration**. This
applies to package manager configuration as well. This is done for the reason that
generated image might run under different network settings comparing to where it
was generated.

Thus, if you will run the container under proxy you will need to pass proxy configuration
into it anew. This can be done by passing proxy host envronment variables as follows::

  docker run -it \
    $(env | grep -E '_proxy=' | sed 's/^/-e /') \
    --network=host \
    <...rest-of-arguments...>

If you are going to play around with the container and install additional packages,
configure proxy for package manager. For that you can use the same
`setup-apt-proxy.sh <../scripts/setup-apt-proxy.sh>`_ script which actually is included
as one of the assets to the image (at ``$PREFIX/bin`` location, see PREFIX_)::

  sudo -E `which setup-apt-proxy.sh`

Container volumes (adding your content, access logs, etc.)
----------------------------------------------------------

Container exposes few volumes which you can use to mount host folders and customize
solution behavior. See table below for the mount points inside a container and required
access rights.

=================== ============= ===========================================
Volume              Rights needed Purpose
=================== ============= ===========================================
/opt/data/content   Read          Add your media content to the solution demo
/opt/data/artifacts Read|Write    Access solution generated content and logs
/var/www/hls        Read|Write    Access server side generated content
=================== ============= ===========================================

So, for example if you have some local content you wish to play via solution demo in
a ``$HOME/media/`` folder you can add this folder to the container as follows::

  docker run -it \
    -v $HOME/media:/opt/data/content \
    <...rest-of-arguments...>

In case you want to access container output artifacts (streams, logs, etc.) you need
to give write permissions to the container users. For example in this way::

  mkdir $HOME/artifacts && chmod a+w $HOME/artifacts
  docker run -it \
    -v $HOME/artifacts:/opt/data/artifacts \
    <...rest-of-arguments...>

Media content requirements
--------------------------

Mounting a host folder to ``/opt/data/content`` inside a container allows you to
access your own media content in solution demos::

  docker run -it \
    -v $HOME/media:/opt/data/content \
    <...rest-of-arguments...>

This section talks about requirements demos imply for the content.

Bascially demos look for the media files with ``*.mp4`` extension right in the
``/opt/data/content``. They don't look into subfolders.

Video track should be encoded as H.264 video. Audio track can be encoded as any format
which would recognize by ffmpeg version available in the container. AAC or MP3 are
recommended.

Container build time customizations
-----------------------------------

Solutions Dockerfiles support a number of arguments to customize the final image.
Pass these arguments as ``docker --build-arg ARGUMENT=VALUE``.

ENABLE_INTEL_REPO
  Possible values: ``yes|no``. Default value: ``yes``

  Enables Intel Graphics Repository packages.

.. _PREFIX:

PREFIX
  Possible values: ``<path>``. Default value: ``/opt/intel/solutions``

  Path prefix inside the container to install custom build target and solution
  assets.

SOLUTION
  Possible values: ``<path>``. Default value: ``cdn``

  Selects solution to build and install inside the container.

FFMPEG_VERSION
  Possible values: ``<version tag>``. Default value: ``master``

  FFMPEG version to build. Use one of the FFMPEG release tags from https://github.com/FFmpeg/FFmpeg/releases
  or branch name or commit id.

VMAF_VERSION
  Possible values: ``<version tag>``. Default value: ``v1.3.15``

  VMAF version to build. Use one of the VMAF release tags from https://github.com/Netflix/vmaf/releases
  or branch name or commit id.
