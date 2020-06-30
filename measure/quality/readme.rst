Quality Measurement Tool
========================

This folder contains video quality measurement tools. See details in the
following documents:

* `Video Quality Measuring Methodology <../../doc/quality.rst>`_
* `Video Quality Measuring Tool Manual Page <../../doc/man/measure-quality.asciidoc>`_

Configuration
=============

Tool allows performance evaluations for the following applications:

* Intel® Media SDK `Sample Encode <https://github.com/Intel-Media-SDK/MediaSDK/blob/master/doc/samples/readme-encode_linux.md>`_
* FFmpeg sample application (aka ffmpeg) with the enabled `qsv plugins <https://trac.ffmpeg.org/wiki/Hardware/QuickSync>`_
  (Intel® Media SDK integration into FFmpeg)

Tool additionally requires:

* Python3
* ffprobe
