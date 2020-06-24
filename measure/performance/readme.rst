Performance Measurement Tool
============================

This folder contains video performance measurement tools. See details in the
following documents:

* `Video Performance Measuring Methodology <../../doc/performance.rst>`_
* `Video Performance Measuring Tool Manual Page <../../doc/man/measure-perf.asciidoc>`_

Configuration
=============

Tool allows performance evaluations for the following applications:

* Intel® Media SDK `Sample Multi Transcode  <https://github.com/Intel-Media-SDK/MediaSDK/blob/master/doc/samples/readme-multi-transcode_linux.md>`_
* FFmpeg sample application (aka ffmpeg) with the enabled `qsv plugins <https://trac.ffmpeg.org/wiki/Hardware/QuickSync>`_
  (Intel® Media SDK integration into FFmpeg)

Tool additionally requires:

* Python3 with the enabled matplotlib and numpy modules
* ffprobe
* Linux perf

Mind that Linux perf events might need to be enabled in system
configuration. The simplest way to do that is::

  sudo sh -c "echo -1 > /proc/sys/kernel/perf_event_paranoid"

For the details on the docker configuration see:

* `Media Delivery Howto <../../doc/howto.rst>`_
