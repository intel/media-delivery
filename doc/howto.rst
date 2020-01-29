Intel Media Deliver Solutions HowTo
===================================

.. contents::

Container build time customizations
-----------------------------------

Solutions Dockerfiles support a number of arguments to customize the final image.
Pass these arguments as ``docker --build-arg ARGUMENT=VALUE``.

ENABLE_INTEL_REPO
  Possible values: ``yes|no``. Default value: ``yes``

  Enables Intel Graphics Repository packages.

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

