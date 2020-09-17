Generating Dockerfiles
======================

.. contents::

Overview
--------

Project includes pre-generated dockerfiles in the `docker <../docker>`_
folder for the key possible setups. If you've done any customizations to the
dockefiles template sources, regenerate dockerfiles with the following
commands::

  cmake .
  make

Dockerfiles Templates Structure
-------------------------------

Top level Dockerfile templates are located in the subfolders of
`docker <../docker>`_ folder:

* `docker/ubuntu20.04/native/Dockerfile.m4 <../docker/ubuntu20.04/native/Dockerfile>`_
* `docker/ubuntu20.04/intel-gfx/Dockerfile.m4 <../docker/ubuntu20.04/intel-gfx/Dockerfile>`_

These templates include component ingredients defined in the .m4 files
stored in `templates <../templates>`_ folder.

Templates Parameters
--------------------

It is possible to customize dockerfile setup passing some parameters during
Dockerfile generation from templates.

DEVEL
  Possible values: `n/a` (just defined or not defined). Default value: not defined

  Switches on/off development build type with which container user is
  created with sudo privileges.

FFMPEG_VER
  Possible values: ``<version tag>``. Default value: ``n4.3``

  FFMPEG version to build. Use one of the FFMPEG release tags from https://github.com/FFmpeg/FFmpeg/releases
  or branch name or commit id.

VMAF_VER
  Possible values: ``<version tag>``. Default value: ``v1.5.2``

  VMAF version to build. Use one of the VMAF release tags from https://github.com/Netflix/vmaf/releases
  or branch name or commit id.
