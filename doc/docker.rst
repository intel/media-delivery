Generating Dockerfiles
======================

.. contents::

Overview
--------

Dockerfiles in this project are generated from the `templates <../templates>`_
written in `m4 <https://www.gnu.org/software/m4/>`_ macro language. Do not
update dockerfiles directly, but modify templates and generate
dockerfiles as follows::

  cmake .
  make

Above will regenerate and overwrite dockerfiles located at `docker <../docker>`_
folder. Please, make sure to commit both template and dockerfile changes
when providing pull requests for reviews.

Dockerfiles Templates Structure
-------------------------------

Top level ``Dockerfile.m4`` templates and dockerfiles generated from them are
located in the subfolders of `docker <../docker>`_ folder::

  $ tree docker
  docker
  ├── CMakeLists.txt
  ├── ubuntu20.04
  │   ├── CMakeLists.txt
  │   ├── dkms
  │   │   ├── Dockerfile
  │   │   └── Dockerfile.m4
  │   ├── intel-gfx
  │   │   ├── Dockerfile
  │   │   └── Dockerfile.m4
  │   ├── native
  │   │   ├── Dockerfile
  │   │   └── Dockerfile.m4
  │   ├── selfbuild
  │   │   ├── Dockerfile
  │   │   └── Dockerfile.m4
  │   └── selfbuild-prodkmd
  │       ├── Dockerfile
  │       └── Dockerfile.m4
  └── ubuntu22.04
      ├── CMakeLists.txt
      └── dkms
          ├── Dockerfile
          └── Dockerfile.m4

  8 directories, 12 files

These templates include component ingredients defined in the .m4 files
stored in `templates <../templates>`_ folder.

Templates Parameters
--------------------

It is possible to customize dockerfiles by passing parameters during
Dockerfile generation from templates.

DEVEL
  Possible values: yes|no. Default value: ``yes``

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

