Video Performance
=================

.. contents::

Video Performance Assessment Methodology
----------------------------------------

In this document we describe the methodology which is used to measure
performance of Intel® Media SDK `Sample Multi Transcode  <https://github.com/Intel-Media-SDK/MediaSDK/blob/master/doc/samples/readme-multi-transcode_linux.md>`_
and `ffmpeg-qsv <https://trac.ffmpeg.org/wiki/Hardware/QuickSync>`_
(Intel® Media SDK integration into FFmpeg). A `video performance measuring tool <man/measure-perf.asciidoc>`_
which implements this methodology is provided as a part of Media
Delivery Software Stack. In addition, a `quality measuring tool <man/measure-quality.asciidoc>`_ is
provided for allowing users to evaluate video quality (see `quality methodology <quality.rst>`_ documentation).

Key performance metrics we collect are:

* Peak Concurrent Number of Sessions
* Peak Frames Per Second (FPS)

There are many other metrics (like CPU and GPU utilization) we
collect to assist in performance investigations and debug:

* Application run time
* CPU-utilization%
* GPU-Utilization%
* Memory footprint and utilization%
* GPU frequency timeline data

With the `measure-perf <doc/man/measure-perf.asciidoc>` tool it is possible to
to enable/disable some metrics collection during the measurement.

Multi-Stream Performance
************************

.. image:: pic/MSPerf_automation_flow.png

The above picture illustrates multi-stream Performance measurement flow. This is
iterative process where we run predefined command lines (point [1] on the
pic.) and increase number of concurent sessions (point [3] on the pic.) if
all the sessions can be run at realtime on the current iteration.

The goal of the measurement is to obtain data similar to the one showed on
the below picture:

.. image:: pic/MSPerf_MultiStreamPerformance_example.png

Here we can compare achieved number of cuncurent sessions (density) for
different resulutions and different setups where setups could be different
different machines, different encoding seetings, different encoders, etc.

Single-Stream Performance
*************************

Looking into single stream performance we evaluate performance if individual
workload. The key metric to collect here is workload FPS. Effectively, the
single stream performance data always accomponies multi-stream performance
measurements. The picture below illustrates what we are looking for
single stream.

.. image:: pic/MSPerf_SingleStreamPerformance_example.png

Performance Monitoring and Debug Data
*************************************

There are a number of metrics which are highly useful for performance
monitoring and debug. The below picture gives a good example summary:

.. image:: pic/MSPerf_CPU_GPU_Utilization_example.png

These metrics allow to check whether workload bottleneck is related to CPU
or particular GPU engine. If this data does not highlight the bottleneck,
but gives a hint of GPU under utilization, try to look into further details.
One of the pinpoints might be memory. We are evaluating memory footprint for
this reason - see below example.

.. image:: pic/MSPerf_MemoryFootprint_example.png

Eventually all the above data is useful in comparison for different
workloads settings and system setups.

Bitrates
--------

Coding bitrates for video performance assessment are selected as a
subset of bitrates used in `quality measuring methodology <quality.rst>`_.
For H.264/AVC we use:

+------------+---------------+-----------------+
| Resolution | Setting       | Bitrates (Mb/s) |
+============+===============+=================+
| 4K         | Low           | 9               |
|            +---------------+-----------------+
|            | High          | 40              |
+------------+---------------+-----------------+
| 1080p      | Low           | 3               |
|            +---------------+-----------------+
|            | High          | 24              |
+------------+---------------+-----------------+
| 720p       | Low           | 1.5             |
|            +---------------+-----------------+
|            | High          | 12              |
+------------+---------------+-----------------+

Coding bitrates for H.265/HEVC video performance assessment:

+------------+---------------+-----------------+
| Resolution | Setting       | Bitrates (Mb/s) |
+============+===============+=================+
| 4K         | Low           | 9               |
|            +---------------+-----------------+
|            | High          | 40              |
+------------+---------------+-----------------+
| 1080p      | Low           | 3               |
|            +---------------+-----------------+
|            | High          | 15              |
+------------+---------------+-----------------+
| 720p       | Low           | 1.5             |
|            +---------------+-----------------+
|            | High          | 7.5             |
+------------+---------------+-----------------+


Command Lines
-------------

In the following sections you can find command lines used for high quality H.264/AVC and H.265/HEVC video
transccoding with Intel® Media SDK `Sample Multi Transcode (SMT) <https://github.com/Intel-Media-SDK/MediaSDK/blob/master/doc/samples/readme-multi-transcode_linux.md>`_
and `ffmpeg-qsv <https://trac.ffmpeg.org/wiki/Hardware/QuickSync>`_ (Intel® Media SDK integration
into FFmpeg) which we use in performance assessments.

Intel Media SDK sample-multi-transcode
--------------------------------------

HEVC-AVC
********

::

  720p_hevc-avc: /usr/share/mfx/samples/sample_multi_transcode -i::h265 <> -hw -async 1 -u 4 -gop_size 256 -dist 8 -num_ref 5 -vbr -b 2000 -hrd 1000 -InitialDelayInKB 500 -extbrc::implicit -ExtBrcAdaptiveLTR:on -o::h264 <>.h264 -p <>
  1080p_hevc-avc: /usr/share/mfx/samples/sample_multi_transcode -i::h265 <> -hw -async 1 -u 4 -gop_size 256 -dist 8 -num_ref 5 -vbr -b 3000 -hrd 1500 -InitialDelayInKB 750 -extbrc::implicit -ExtBrcAdaptiveLTR:on -o::h264 <>.h264 -p <>
  2160p_hevc-avc: /usr/share/mfx/samples/sample_multi_transcode -i::h265 <> -hw -async 1 -u 4 -gop_size 256 -dist 8 -num_ref 5 -vbr -b 10000 -hrd 5000 -InitialDelayInKB 2500 -extbrc::implicit -ExtBrcAdaptiveLTR:on -o::h264 <>.h264 -p <>

AVC-AVC
*******

::

  720p_avc-avc: /usr/share/mfx/samples/sample_multi_transcode -i::h264 <> -hw -async 1 -u 4 -gop_size 256 -dist 8 -num_ref 5 -vbr -b 2000 -hrd 1000 -InitialDelayInKB 500 -extbrc::implicit -ExtBrcAdaptiveLTR:on -o::h264 <>.h264 -p <>
  1080p_avc-avc: /usr/share/mfx/samples/sample_multi_transcode -i::h264 <> -hw -async 1 -u 4 -gop_size 256 -dist 8 -num_ref 5 -vbr -b 3000 -hrd 1500 -InitialDelayInKB 750 -extbrc::implicit -ExtBrcAdaptiveLTR:on -o::h264 <>.h264 -p <>
  2160p_avc-avc: /usr/share/mfx/samples/sample_multi_transcode -i::h264 <> -hw -async 1 -u 4 -gop_size 256 -dist 8 -num_ref 5 -vbr -b 10000 -hrd 5000 -InitialDelayInKB 2500 -extbrc::implicit -ExtBrcAdaptiveLTR:on -o::h264 <>.h264 -p <>

HEVC-HEVC
*********

::

  720p_hevc-hevc: /usr/share/mfx/samples/sample_multi_transcode -i::h265 <> -hw -async 1 -u 4 -gop_size 256 -num_ref 5 -vbr -b 1500 -hrd 750 -InitialDelayInKB 325 -extbrc::on -o::h265 <>.h265 -p <>
  1080p_hevc-hevc: /usr/share/mfx/samples/sample_multi_transcode -i::h265 <> -hw -async 1 -u 4 -gop_size 256 -num_ref 5 -vbr -b 3000 -hrd 1500 -InitialDelayInKB 750 -extbrc::on -o::h265 <>.h265 -p <>
  2160p_hevc-hevc: /usr/share/mfx/samples/sample_multi_transcode -i::h265 <> -hw -async 1 -u 4 -gop_size 256 -num_ref 5 -vbr -b 9000 -hrd 4500 -InitialDelayInKB 2250 -extbrc::on -o::h265 <>.h265 -p <>

AVC-HEVC
********

::

  720p_avc-hevc: /usr/share/mfx/samples/sample_multi_transcode -i::h264 <> -hw -async 1 -u 4 -gop_size 256 -num_ref 5 -vbr -b 1500 -hrd 750 -InitialDelayInKB 325 -extbrc::on -o::h265 <>.h265 -p <>
  1080p_avc-hevc: /usr/share/mfx/samples/sample_multi_transcode -i::h264 <> -hw -async 1 -u 4 -gop_size 256 -num_ref 5 -vbr -b 3000 -hrd 1500 -InitialDelayInKB 750 -extbrc::on -o::h265 <>.h265 -p <>
  2160p_avc-hevc: /usr/share/mfx/samples/sample_multi_transcode -i::h264 <> -hw -async 1 -u 7 -gop_size 256 -num_ref 5 -vbr -b 9000 -hrd 4500 -InitialDelayInKB 2250 -extbrc::on -o::h265 <>.h265 -p <>

ffmpeg-qsv
----------

HEVC-AVC
********

::

  720p_hevc-avc: ffmpeg -y -hwaccel qsv -c:v hevc_qsv -i <> -c:v h264_qsv -b:v 2000k -preset medium -g 256 -extbrc 1 -b_strategy 1 -bf 7 -refs 5 -async_depth 1 -maxrate 4000k -bufsize 8000k -y <>.h264 -report
  1080p_hevc-avc: ffmpeg -y -hwaccel qsv -c:v hevc_qsv -i <> -c:v h264_qsv -b:v 3000k -preset medium -g 256 -extbrc 1 -b_strategy 1 -bf 7 -refs 5 -async_depth 1 -maxrate 6000k -bufsize 12000k -y <>.h264 -report
  2160p_hevc-avc: ffmpeg -y -hwaccel qsv -c:v hevc_qsv -i <> -c:v h264_qsv -b:v 10000k -preset medium -g 256 -extbrc 1 -b_strategy 1 -bf 7 -refs 5 -async_depth 1 -maxrate 20000k -bufsize 40000k -y <>.h264 -report

AVC-AVC
*******

::

  720p_avc-avc: ffmpeg -y -hwaccel qsv -c:v h264_qsv -i <> -c:v h264_qsv -b:v 2000k -preset medium -g 256 -extbrc 1 -b_strategy 1 -bf 7 -refs 5 -async_depth 1 -maxrate 4000k -bufsize 8000k -y <>.h264 -report
  1080p_avc-avc: ffmpeg -y -hwaccel qsv -c:v h264_qsv -i <> -c:v h264_qsv -b:v 3000k -preset medium -g 256 -extbrc 1 -b_strategy 1 -bf 7 -refs 5 -async_depth 1 -maxrate 6000k -bufsize 12000k -y <>.h264 -report
  2160p_avc-avc: ffmpeg -y -hwaccel qsv -c:v h264_qsv -i <> -c:v h264_qsv -b:v 10000k -preset medium -g 256 -extbrc 1 -b_strategy 1 -bf 7 -refs 5 -async_depth 1 -maxrate 20000k -bufsize 40000k -y <>.h264 -report

HEVC-HEVC
*********

::

  720p_hevc-hevc: ffmpeg -y -hwaccel qsv -c:v hevc_qsv -i <> -c:v hevc_qsv -b:v 1500k -preset medium -g 256 -extbrc 1 -b_strategy 1 -bf 7 -refs 5 -async_depth 1 -maxrate 3000k -bufsize 6000k -y <>.h265 -report
  1080p_hevc-hevc: ffmpeg -y -hwaccel qsv -c:v hevc_qsv -i <> -c:v hevc_qsv -b:v 3000k -preset medium -g 256 -extbrc 1 -b_strategy 1 -bf 7 -refs 5 -async_depth 1 -maxrate 6000k -bufsize 12000k -y <>.h265 -report
  2160p_hevc-hevc: ffmpeg -y -hwaccel qsv -c:v hevc_qsv -i <> -c:v hevc_qsv -b:v 9000k -preset medium -g 256 -extbrc 1 -b_strategy 1 -bf 7 -refs 5 -async_depth 1 -maxrate 18000k -bufsize 36000k -y <>.h265 -report

AVC-HEVC
********

::

  720p_avc-hevc: ffmpeg -y -hwaccel qsv -c:v h264_qsv -i <> -c:v hevc_qsv -b:v 1500k -preset medium -g 256 -extbrc 1 -b_strategy 1 -bf 7 -refs 5 -async_depth 1 -maxrate 3000k -bufsize 6000k -y <>.h265 -report
  1080p_avc-hevc: ffmpeg -y -hwaccel qsv -c:v h264_qsv -i <> -c:v hevc_qsv -b:v 3000k -preset medium -g 256 -extbrc 1 -b_strategy 1 -bf 7 -refs 5 -async_depth 1 -maxrate 6000k -bufsize 12000k -y <>.h265 -report
  2160p_avc-hevc: ffmpeg -y -hwaccel qsv -c:v h264_qsv -i <> -c:v hevc_qsv -b:v 9000k -preset veryfast -g 256 -extbrc 1 -b_strategy 1 -bf 7 -refs 5 -async_depth 1 -maxrate 18000k -bufsize 36000k -y <>.h265 -report
