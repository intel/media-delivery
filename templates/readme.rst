Templates
=========

This folder contains `m4 <https://www.gnu.org/software/m4/>`_ templates for
software ingredients which project uses to compose final dockerfile(s).

Helper "system" templates used by component specific templates:

+--------------+----------------------------------------------+
| Template     | Purpose                                      |
+==============+==============================================+
| envs.m4      | Helper definitions used across all templates |
+--------------+----------------------------------------------+
| intel-gfx.m4 | Enable Intel Graphics Repositories           |
+--------------+----------------------------------------------+
| ubuntu.m4    | Helper ubuntu related definitions            |
+--------------+----------------------------------------------+

Component templates:

+------------+-------------------------------------------------------------+
| Template   | Purpose                                                     |
+============+=============================================================+
| content.m4 | Fetch media content and install it into final docker image  |
+------------+-------------------------------------------------------------+
| ffmpeg.m4  | Build and install `ffmpeg <https://ffmpeg.org/>`_           |
+------------+-------------------------------------------------------------+
| manuals.m4 | Build and install container embedded documentation          |
+------------+-------------------------------------------------------------+
| samples.m4 | Install project samples into the final docker image         |
+------------+-------------------------------------------------------------+
| vmaf.m4    | Build and install `vmaf <https://github.com/Netflix/vmaf>`_ |
+------------+-------------------------------------------------------------+
