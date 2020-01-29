Intel Media Deliver Solutions HowTo
===================================

.. contents::

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
as one of the assets to the image (at ``$PREFIX/bin`` location, see PREFIX_).

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
  Possible values: ``<path>``. Default value: ``edge``

  Selects solution to build and install inside the container.

FFMPEG_VERSION
  Possible values: ``<version tag>``. Default value: ``master``

  FFMPEG version to build. Use one of the FFMPEG release tags from https://github.com/FFmpeg/FFmpeg/releases
  or branch name or commit id.

VMAF_VERSION
  Possible values: ``<version tag>``. Default value: ``v1.3.15``

  VMAF version to build. Use one of the VMAF release tags from https://github.com/Netflix/vmaf/releases
  or branch name or commit id.
