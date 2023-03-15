Video Quality
=============

.. contents::

Video Quality Benchmark Data
----------------------------

* `Benchmark data for Intel® Data Center GPU Flex Series <benchmarks/intel-data-center-gpu-flex-series/intel-data-center-gpu-flex-series.rst>`_
* `Benchmark data for Intel® Iris® Xe MAX graphics <benchmarks/intel-iris-xe-max-graphics/intel-iris-xe-max-graphics.md>`_

Video Quality Assessment Methodology
------------------------------------

In this document we describe the methodology which is used to measure video quality of Intel® Media SDK 
`Sample Multi-Transcode <https://github.com/Intel-Media-SDK/MediaSDK/blob/master/doc/samples/readme-multi-transcode_linux.md>`_
and `ffmpeg-qsv <https://trac.ffmpeg.org/wiki/Hardware/QuickSync>`_ (Intel® Media SDK integration into FFmpeg) codecs.
A `video quality measuring tool <man/measure-quality.asciidoc>`_ which implements this methodology is provided as 
a part of Media Delivery Software Stack. In addition, a `performance measuring tool <man/measure-perf.asciidoc>`_ is
provided for allowing users to evaluate performance (see `performance methodology <performance.rst>`_ documentation).

Peak signal-to-noise ratio (PSNR) is the most widely used objective image quality metric. We use arithmetic average PSNR
of the luminance frames (PSNR-Y) as the basic quality assessment metric. Since PSNR fails to capture certain perceptual
quality traits, we also make use of the following additional quality metrics: VMAF, SSIM, and MS-SSIM.

To compare quality with different codecs and/or coding options, we compute the Bjøntegaard-Delta bitrate (BD-rate)
measure, in which negative values indicate how much the bitrate is reduced, and positive values indicate how much the
bitrate is increased for the same PSNR-Y. A minimum of 4 distinct points are needed for a successful BD-rate measure, so
a minimum of 4 distinct bitrates need to be used for each sequence being tested. We resort to measuring quality using 5
target bitrates in order to capture a variety of encoding scenarios. However, instead of using a single 5-point BD-rate
measure, we use an average of two 4-point BD-rate measures instead, where the lowest 4 of 5 points are used as the low
bitrates BD-rate measure and the highest 4 of 5 points are used as the high bitrates BD-rate measure.

We evaluate encoding quality on the following 27 video sequences:

* 1080p 8-bit YUV 4:2:0

+-----------------+------------+-----+--------+----------------------------------+------------------------------------+
| Sequence        | Resolution | FPS | Frames | MD5 Checksum                     | Source                             |
+=================+============+=====+========+==================================+====================================+
| BasketBallDrive | 1920x1080  | 50  | 500    | e18034a26708a3c534a3b03d3bf82d61 | MPEG Test Suite                    |
+-----------------+------------+-----+--------+----------------------------------+------------------------------------+
| BQTerrace       | 1920x1080  | 60  | 600    | cc17d5957b732ec5eab9234d6f5318e3 | MPEG Test Suite                    |
+-----------------+------------+-----+--------+----------------------------------+------------------------------------+
| Cactus          | 1920x1080  | 50  | 500    | 3fddb71486f209f1eb8020a0880ddf82 | MPEG Test Suite                    |
+-----------------+------------+-----+--------+----------------------------------+------------------------------------+
| CrowdRun        | 1920x1080  | 50  | 500    | da34812b5b2c316d40481c7b6c841e41 | https://media.xiph.org/video/derf/ |
+-----------------+------------+-----+--------+----------------------------------+------------------------------------+
| DinnerScene     | 1920x1080  | 60  | 600    | d1260db74160c61b72d7e1cee00e1ec2 | https://media.xiph.org/video/derf/ |
+-----------------+------------+-----+--------+----------------------------------+------------------------------------+
| Kimono          | 1920x1080  | 24  | 240    | 4a83005bc719012ac148dd3898e5e4ed | MPEG Test Suite                    |
+-----------------+------------+-----+--------+----------------------------------+------------------------------------+
| ParkJoy         | 1920x1080  | 50  | 300    | 37dc2f9b6a2d1f4e50ac6cc432112733 | https://media.xiph.org/video/derf/ |
+-----------------+------------+-----+--------+----------------------------------+------------------------------------+
| RedKayak        | 1920x1080  | 30  | 570    | 2901bec44d6f43af3e8316b94d8af02b | https://media.xiph.org/video/derf/ |
+-----------------+------------+-----+--------+----------------------------------+------------------------------------+
| RushFieldCuts   | 1920x1080  | 30  | 570    | 055207f6a5819f3a1dc216a64f8634f9 | https://media.xiph.org/video/derf/ |
+-----------------+------------+-----+--------+----------------------------------+------------------------------------+

* 720p 8-bit YUV 4:2:0

+---------------+------------+-----+--------+----------------------------------+------------------------------------+
| Sequence      | Resolution | FPS | Frames | MD5 Checksum                     | Source                             |
+===============+============+=====+========+==================================+====================================+
| Boat          | 1280x720   | 60  | 300    | 45207fbd760394f011cff2af34d59ddc | https://media.xiph.org/video/derf/ |
+---------------+------------+-----+--------+----------------------------------+------------------------------------+
| CrowdRun      | 1280x720   | 50  | 500    | 371e4d129556b27e17b1bc92c16a69d4 | https://media.xiph.org/video/derf/ |
+---------------+------------+-----+--------+----------------------------------+------------------------------------+
| FoodMarket    | 1280x720   | 60  | 300    | f41cb6ddaaaae9fec392da4e2e47b07e | https://media.xiph.org/video/derf/ |
+---------------+------------+-----+--------+----------------------------------+------------------------------------+
| Kimono        | 1280x720   | 24  | 240    | e6bbaf876f00fe1709f5e8e1ec8da967 | MPEG Test Suite                    |
+---------------+------------+-----+--------+----------------------------------+------------------------------------+
| ParkJoy       | 1280x720   | 50  | 500    | ef5868b66118c7fcbfdca069efdac684 | https://media.xiph.org/video/derf/ |
+---------------+------------+-----+--------+----------------------------------+------------------------------------+
| ParkScene     | 1280x720   | 24  | 240    | d56b03ba9bf0afeac2800af9ab18c9eb | MPEG Test Suite                    |
+---------------+------------+-----+--------+----------------------------------+------------------------------------+
| PierSeaside   | 1280x720   | 60  | 600    | ffd18a73e6d694097613cfd5228ec6c1 | https://media.xiph.org/video/derf/ |
+---------------+------------+-----+--------+----------------------------------+------------------------------------+
| Tango         | 1280x720   | 60  | 294    | 8ba856e08c3eefbe495a68f4df7ee0f5 | https://media.xiph.org/video/derf/ |
+---------------+------------+-----+--------+----------------------------------+------------------------------------+
| TouchDownPass | 1280x720   | 30  | 570    | db92db55a027922f7ea7276ae680f819 | MPEG Test Suite                    |
+---------------+------------+-----+--------+----------------------------------+------------------------------------+

* Synthetic/Animation Test Content 1080p 8-bit YUV 4:2:0

+----------------------+------------+-----+--------+----------------------------------+------------------------------------+
| Sequence             | Resolution | FPS | Frames | MD5 Checksum                     | Source                             |
+======================+============+=====+========+==================================+====================================+
| Bunny                | 1920x1080  | 24  | 600    | 987f1923ccf93d26271324b21c39ec45 | https://media.xiph.org/video/derf/ |
+----------------------+------------+-----+--------+----------------------------------+------------------------------------+
| CSGO                 | 1920x1080  | 60  | 600    | 5a7575d1c403a08347cffe88bcbc1805 | https://media.xiph.org/video/derf/ |
+----------------------+------------+-----+--------+----------------------------------+------------------------------------+
| DOTA2                | 1920x1080  | 60  | 600    | a3a7d5e1c9964e5aa6f5e3e520320c32 | https://media.xiph.org/video/derf/ |
+----------------------+------------+-----+--------+----------------------------------+------------------------------------+
| GTAV                 | 1920x1080  | 60  | 600    | 22ad590c3f624ac0884062a68674ef4a | https://media.xiph.org/video/derf/ |
+----------------------+------------+-----+--------+----------------------------------+------------------------------------+
| Hearthstone          | 1920x1080  | 60  | 600    | d5eb7157f37386d5a2df0e789aed8909 | https://media.xiph.org/video/derf/ |
+----------------------+------------+-----+--------+----------------------------------+------------------------------------+
| Minecraft            | 1920x1080  | 60  | 600    | 3bc4b5a002b5b4140e45bb0ded4a3620 | https://media.xiph.org/video/derf/ |
+----------------------+------------+-----+--------+----------------------------------+------------------------------------+
| MrFox_BlueBird       | 1920x1080  | 30  | 300    | 30801242685c4ed75c9eb748d5a4d0e7 | VQEG Test Suite                    |
+----------------------+------------+-----+--------+----------------------------------+------------------------------------+
| Sintel_offset537n480 | 1920x1080  | 24  | 480    | 1229ca7e98831ca85e6411e1bce12757 | https://media.xiph.org/video/derf/ |
+----------------------+------------+-----+--------+----------------------------------+------------------------------------+
| Witcher              | 1920x1080  | 60  | 600    | cc082ec495a47085ba1c08b99e4de2e4 | https://media.xiph.org/video/derf/ |
+----------------------+------------+-----+--------+----------------------------------+------------------------------------+

* 1080p 10-bit YUV 4:2:0

+-----------------+------------+-----+--------+----------------------------------+-----------------+
| Sequence        | Resolution | FPS | Frames | MD5 Checksum                     | Source          |
+=================+============+=====+========+==================================+=================+
| BalloonFestival | 1920x1080  | 24  | 240    | ad3174f083a5138a9572a3c8d9a58440 | JVET Test Suite |
+-----------------+------------+-----+--------+----------------------------------+-----------------+
| CrowdRun        | 1920x1080  | 50  | 500    | b9da42e538b4fb34724da13084b9e399 | JVET Test Suite |
+-----------------+------------+-----+--------+----------------------------------+-----------------+
| Hurdles         | 1920x1080  | 50  | 500    | 28f166b2cf09005eecbf33db03b426d1 | JVET Test Suite |
+-----------------+------------+-----+--------+----------------------------------+-----------------+
| Market3         | 1920x1080  | 50  | 400    | b74a2813a6b19485b01bf113b978e077 | JVET Test Suite |
+-----------------+------------+-----+--------+----------------------------------+-----------------+
| MarketPlace     | 1920x1080  | 60  | 600    | ca55c798f502cc860d5ee66772f5ce01 | JVET Test Suite |
+-----------------+------------+-----+--------+----------------------------------+-----------------+
| Starting        | 1920x1080  | 50  | 500    | 7d04491468b82db2ccbb7a4f822a0ef7 | JVET Test Suite |
+-----------------+------------+-----+--------+----------------------------------+-----------------+

Quality assessment with Intel® Media Delivery solution is provided for 2 different encoding/transcoding use cases:

#. **High Quality (HQ)**
   - targets applications such as video archiving and storage (e.g. Blu-ray), and video streaming with a tolerable
   delay (e.g. video-on-demand). These applications have very few restrictions on the use of encoding tools such as
   look-ahead and B-frames, and can tolerate a larger delay (typically > 0.5 seconds).

#. **Low Delay (LD)**
   - is used in live streaming applications such as game streaming, user generated content streaming or events broadcasting.
   In these types of application the maxium tolerable delay is only a few frames (i.e. less than 0.5 seconds), and the use
   of advanced encoding prediction tools is limited (no B-frames, no look-ahead, etc).

HQ use case is set as a default in Media Delivery Software Stack quality measure. Details of the quality assessment
methodology for HQ use case are described next. On the other hand, to learn more about quality assessment methodology
for LD use case, please refer to `quality-lowdelay <quality-lowdelay.rst>`_.

The following table shows specific target bitrates used in quality evaluation of our H.264/AVC, H.265/HEVC and AV1 GPU
based video encoders (for HQ use case). Note that 5 bitrates are given: the lowest 4 are used for the low BD-rate
measure while the largest 4 are used for the high BD-rate measure.

+-------------------------------+------------+-----------------------------------------------------------------+
| Sequence                      | Resolution | Bitrates (Mb/s)                                                 |
|                               |            +---------------------+---------------------+---------------------+
|                               |            | H.264/AVC           | H.265/HEVC          | AV1                 |
+===============================+============+=====================+=====================+=====================+
| BasketBallDrive               | 1920x1080  | 2, 3, 6, 12, 24     | 2, 3, 6, 9, 15      | 2, 3, 6, 9, 15      |
+-------------------------------+------------+---------------------+---------------------+---------------------+
| BQTerrace                     | 1920x1080  | 2, 3, 6, 12, 24     | 2, 3, 6, 9, 15      | 2, 3, 6, 9, 15      |
+-------------------------------+------------+---------------------+---------------------+---------------------+
| Cactus                        | 1920x1080  | 2, 3, 6, 12, 24     | 2, 3, 6, 9, 15      | 2, 3, 6, 9, 15      |
+-------------------------------+------------+---------------------+---------------------+---------------------+
| CrowdRun :sup:`*`             | 1920x1080  | 15, 20, 25, 30, 35  | 15, 20, 25, 30, 35  | 15, 20, 25, 30, 35  |
+-------------------------------+------------+---------------------+---------------------+---------------------+
| DinnerScene :sup:`*`          | 1920x1080  | 1, 1.5, 2, 3, 4     | 3, 7, 11, 15, 20    | 0.5, 1, 2, 7, 11    |
+-------------------------------+------------+---------------------+---------------------+---------------------+
| Kimono                        | 1920x1080  | 2, 3, 6, 12, 24     | 2, 3, 6, 9, 15      | 2, 3, 6, 9, 15      |
+-------------------------------+------------+---------------------+---------------------+---------------------+
| ParkJoy :sup:`*`              | 1920x1080  | 15, 20, 25, 30, 35  | 15, 20, 25, 30, 35  | 15, 20, 25, 30, 35  |
+-------------------------------+------------+---------------------+---------------------+---------------------+
| RedKayak                      | 1920x1080  | 2, 3, 6, 12, 24     | 2, 3, 6, 9, 15      | 2, 3, 6, 9, 15      |
+-------------------------------+------------+---------------------+---------------------+---------------------+
| RushFieldCuts                 | 1920x1080  | 2, 3, 6, 12, 24     | 2, 3, 6, 9, 15      | 2, 3, 6, 9, 15      |
+-------------------------------+------------+---------------------+---------------------+---------------------+
| Boat                          | 1280x720   | 1, 1.5, 3, 6, 12    | 1, 1.5, 3, 4.5, 7.5 | 1, 1.5, 3, 4.5, 7.5 |
+-------------------------------+------------+---------------------+---------------------+---------------------+
| CrowdRun :sup:`*`             | 1280x720   | 6, 8, 10, 12, 15    | 6, 8, 10, 12, 15    | 6, 8, 10, 12, 15    |
+-------------------------------+------------+---------------------+---------------------+---------------------+
| FoodMarket                    | 1280x720   | 1, 1.5, 3, 6, 12    | 1, 1.5, 3, 4.5, 7.5 | 1, 1.5, 3, 4.5, 7.5 |
+-------------------------------+------------+---------------------+---------------------+---------------------+
| Kimono                        | 1280x720   | 1, 1.5, 3, 6, 12    | 1, 1.5, 3, 4.5, 7.5 | 1, 1.5, 3, 4.5, 7.5 |
+-------------------------------+------------+---------------------+---------------------+---------------------+
| ParkJoy :sup:`*`              | 1280x720   | 6, 8, 10, 12, 15    | 6, 8, 10, 12, 15    | 6, 8, 10, 12, 15    |
+-------------------------------+------------+---------------------+---------------------+---------------------+
| ParkScene                     | 1280x720   | 1, 1.5, 3, 6, 12    | 1, 1.5, 3, 4.5, 7.5 | 1, 1.5, 3, 4.5, 7.5 |
+-------------------------------+------------+---------------------+---------------------+---------------------+
| PierSeaSide                   | 1280x720   | 1, 1.5, 3, 6, 12    | 1, 1.5, 3, 4.5, 7.5 | 1, 1.5, 3, 4.5, 7.5 |
+-------------------------------+------------+---------------------+---------------------+---------------------+
| Tango                         | 1280x720   | 1, 1.5, 3, 6, 12    | 1, 1.5, 3, 4.5, 7.5 | 1, 1.5, 3, 4.5, 7.5 |
+-------------------------------+------------+---------------------+---------------------+---------------------+
| TouchDownPass                 | 1280x720   | 1, 1.5, 3, 6, 12    | 1, 1.5, 3, 4.5, 7.5 | 1, 1.5, 3, 4.5, 7.5 |
+-------------------------------+------------+---------------------+---------------------+---------------------+
| Bunny                         | 1920x1080  | 2, 3, 6, 12, 24     | 2, 3, 6, 9, 15      | 2, 3, 6, 9, 15      |
+-------------------------------+------------+---------------------+---------------------+---------------------+
| CSGO                          | 1920x1080  | 2, 3, 6, 12, 24     | 2, 3, 6, 9, 15      | 2, 3, 6, 9, 15      |
+-------------------------------+------------+---------------------+---------------------+---------------------+
| DOTA2                         | 1920x1080  | 2, 3, 6, 12, 24     | 2, 3, 6, 9, 15      | 2, 3, 6, 9, 15      |
+-------------------------------+------------+---------------------+---------------------+---------------------+
| GTAV                          | 1920x1080  | 2, 3, 6, 12, 24     | 2, 3, 6, 9, 15      | 2, 3, 6, 9, 15      |
+-------------------------------+------------+---------------------+---------------------+---------------------+
| Hearthstone                   | 1920x1080  | 2, 3, 6, 12, 24     | 2, 3, 6, 9, 15      | 2, 3, 6, 9, 15      |
+-------------------------------+------------+---------------------+---------------------+---------------------+
| Minecraft                     | 1920x1080  | 2, 3, 6, 12, 24     | 2, 3, 6, 9, 15      | 2, 3, 6, 9, 15      |
+-------------------------------+------------+---------------------+---------------------+---------------------+
| MrFox_BlueBird                | 1920x1080  | 2, 3, 6, 12, 24     | 2, 3, 6, 9, 15      | 2, 3, 6, 9, 15      |
+-------------------------------+------------+---------------------+---------------------+---------------------+
| Sintel_offset537n480 :sup:`*` | 1920x1080  | 0.5, 1, 2, 6, 9     | 0.5, 1, 2, 6, 9     | 0.5, 1, 2, 6, 9     |
+-------------------------------+------------+---------------------+---------------------+---------------------+
| Witcher                       | 1920x1080  | 2, 3, 6, 12, 24     | 2, 3, 6, 9, 15      | 2, 3, 6, 9, 15      |
+-------------------------------+------------+---------------------+---------------------+---------------------+
:sup:`*` Sequences requiring exceptional target bitrates

Our measure quality tool currently also supports 10-bit HEVC (support for 10-bit AV1 is coming soon).
The following table shows specific target bitrates used for the predefined 10-bit streams:

+-------------------------------+------------+---------------------+
| Sequence                      | Resolution | Bitrates (Mb/s)     |
|                               |            +---------------------+
|                               |            | H.265/HEVC          |
+===============================+============+=====================+
| BalloonFestival_10b           | 1920x1080  | 2, 3, 6, 9, 15      |
+-------------------------------+------------+---------------------+
| CrowdRun_10b  :sup:`*`        | 1920x1080  | 15, 20, 25, 30, 35  |
+-------------------------------+------------+---------------------+
| Hurdles_10b                   | 1920x1080  | 2, 3, 6, 9, 15      |
+-------------------------------+------------+---------------------+
| Market3_10b                   | 1920x1080  | 2, 3, 6, 9, 15      |
+-------------------------------+------------+---------------------+
| MarketPlace_10b               | 1920x1080  | 2, 3, 6, 9, 15      |
+-------------------------------+------------+---------------------+
| Starting_10b                  | 1920x1080  | 2, 3, 6, 9, 15      |
+-------------------------------+------------+---------------------+

If a user does not explicitly specify the target bitrates for a user-defined sequence or stream, the following
bitrates are used by default:

+-------------------------+-----------------------------------------------------------------+
| Resolution              | Bitrates (Mb/s)                                                 |
|                         +---------------------+---------------------+---------------------+
|                         | H.264/AVC           | H.265/HEVC          | AV1                 |
+=========================+=====================+=====================+=====================+
| 4K and over             | 6, 9, 15, 24, 40    | 6, 9, 15, 24, 40    | 6, 9, 15, 24, 40    |
+-------------------------+---------------------+---------------------+---------------------+
| 1080p and under 4K      | 2, 3, 6, 12, 24     | 2, 3, 6, 9, 15      | 2, 3, 6, 9, 15      |
+-------------------------+---------------------+---------------------+---------------------+
| under 1080p (e.g. 720p) | 1, 1.5, 3, 6, 12    | 1, 1.5, 3, 4.5, 7.5 | 1, 1.5, 3, 4.5, 7.5 |
+-------------------------+---------------------+---------------------+---------------------+


For HQ use case, we measure 2 encoding modes: variable bitrate (VBR) mode and constant bitrate (CBR) mode. The final
average BD-rate for a video sequence encoded with a given encoder is computed by averaging the following 4 individual
BD-rates:

#. CBR low bitrates BD-rate
#. CBR high bitrates BD-rate
#. VBR low bitrates BD-rate
#. VBR high bitrates BD-rate.

In the following sections you can find command lines used for high quality H.264/AVC, H.265/HEVC and AV1 video
coding with Intel® Media SDK `Sample Multi-Transcode <https://github.com/Intel-Media-SDK/MediaSDK/blob/master/doc/samples/readme-multi-transcode_linux.md>`_
and `ffmpeg-qsv <https://trac.ffmpeg.org/wiki/Hardware/QuickSync>`_ (Intel® Media SDK integration into FFmpeg).

Video Quality Measuring Tool
----------------------------
A `video quality measuring tool <man/measure-quality.asciidoc>`_ is provided as a part of Media Delivery Software
Stack. The tool allows users to measure video quality for themselves in a manner described in this document for either
a predefined set of video sequences, or a video sequences of their choosing.  The input can be a raw YUV 4:2:0 8-bit
file, or any video encoded bitstream (raw or within a container) supported by ffmpeg.

YUV Quality Measure Example
***************************

::

  measure quality -w 1920 -h 1080 -f 24 InputVideo.yuv

H.264 Bitstream Quality Measure Example
***************************************

::

  measure quality InputVideo.h264

Both ffmpeg and sample-multi-transcode quality results will be computed for pre-encoded input content.

MP4 Container Quality Measure Example
*************************************

::

  measure quality InputVideo.mp4

Only ffmpeg-based quality results will be computed for pre-encoded input content encapsulated in a container.

Next we present quality command lines for H.264/AVC and H.265/HEVC. To maximize quality over performance, please use
"veryslow" preset. For maximum performance set preset to "veryfast". For a balanced quality/performance tradeoff use
"medium" preset.

EncTools and ExtBRC
-------------------
**EncTools** is Intel’s new software based (SW) BRC which includes a suite of adaptive encoding tools
designed to improve video quality (thus a name EncTools).

**ExtBRC** is Intel’s legacy SW BRC.

EncTools are engaged automatically with enabling external BRC (extbrc 1) and setting lookahead depth >= 1.
Positive lookahead depth will automatically enable EncTools BRC and all adaptive encoding tools. For low
power lookahead to engage with EncTools BRC, lookahead depth should be > mini-GoP size. Several adaptive
encoding tools can be disabled by engaging SMT or FFmpeg-QSV flags, such as, for example, AdaptiveI off
(disable scene cut detection) and AdaptiveB off (disable adaptive mini-GoP).

::

  # triggers EncTools without low power lookahead (performance boost):
  ffmpeg <...> -g 256 -bf 7 -extbrc 1 -look_ahead_depth 8 <...>

  # triggers EncTools with low power lookahead (quality boost):
  ffmpeg <...> -g 256 -bf 7 -extbrc 1 -look_ahead_depth 40 <...>

  # triggers ExtBRC:
  ffmpeg <...> -g 256 -bf 7 -extbrc 1 -look_ahead_depth 0 <...>

Below table summarizes which tools are available in EncTools and ExtBRC SW BRCs.

+-------------------------------------------------------+---------+----------+
| Feature                                               | ExtBRC  | EncTools |
+=======================================================+=========+==========+
| Adaptive Long Term Reference (ALTR)*                  | |check| | |check|  |
+-------------------------------------------------------+---------+----------+
| Scene Change Detection (SCD/Adaptive I)*              | |check| | |check|  |
+-------------------------------------------------------+---------+----------+
| Adaptive Motion Compensation Temporal Filter (AMCTF)* | |check| | |cross|  |
+-------------------------------------------------------+---------+----------+
| Adaptive Pyramid Quantization (APQ)                   | |cross| | |check|  |
+-------------------------------------------------------+---------+----------+
| Adaptive GOP (AGOP/Adaptive B)                        | |cross| | |check|  |
+-------------------------------------------------------+---------+----------+
| Adaptive Reference Frames (AREF)                      | |cross| | |check|  |
+-------------------------------------------------------+---------+----------+
| Adaptive Custom Quantizer Matrix (ACQM)               | |cross| | |check|  |
+-------------------------------------------------------+---------+----------+
| Low Power Look Ahead (LPLA)                           | |cross| | |check|  |
+-------------------------------------------------------+---------+----------+
| Persistance Adaptive Quantization (PAQ)               | |cross| | |check|  |
+-------------------------------------------------------+---------+----------+

\* - VME based and is available up to (and including) DG1.

EncTools and ExtBRC are not supported for all the codecs and platforms - see support matrix below.
Please note that HW BRC for VDENC encoders requires HuC which is not enabled by default in Linux kernel
on some platforms. First platform which enables HuC by default is DG1 (TGL does not has HuC
enabled by default).

+------------+----------+-----------+---------+-----------+-------------+------------+------------+
| Encoder    | BRC Type | DG2/ATS-M | DG1     | TGL       | Gen11 (ICL) | Gen9 (SKL) | Gen8 (BDW) |
+============+==========+===========+=========+===========+=============+============+============+
| AVC VME    | ExtBRC   | |na|      | |check| | |check|   | |check|     | |check|    | |check|    |
+            +----------+           +---------+-----------+-------------+------------+------------+
|            | EncTools |           | |check| | |cross|   | |cross|     | |cross|    | |cross|    |
+            +----------+           +---------+-----------+-------------+------------+------------+
|            | HW BRC   |           | |check| | |check|   | |check|     | |check|    | |check|    |
+------------+----------+-----------+---------+-----------+-------------+------------+------------+
| HEVC VME   | ExtBRC   | |na|      | |check| | |check|   | |check|     | |check|    | |na|       |
+            +----------+           +---------+-----------+-------------+------------+            +
|            | EncTools |           | |check| | |cross|   | |cross|     | |cross|    |            |
+            +----------+           +---------+-----------+-------------+------------+            +
|            | HW BRC   |           | |check| | |check|   | |check|     | |check|    |            |
+------------+----------+-----------+---------+-----------+-------------+------------+------------+
| AVC VDENC  | ExtBRC   | |check|   | |check| | |cross|   | |cross|     | |cross|    | |na|       |
+            +----------+-----------+---------+-----------+-------------+------------+            +
|            | EncTools | |check|   | |check| | |cross|   | |cross|     | |cross|    |            |
+            +----------+-----------+---------+-----------+-------------+------------+            +
|            | HW BRC   | |check|   | |check| | |cross| * | |cross| *   | |cross| *  |            |
+------------+----------+-----------+---------+-----------+-------------+------------+------------+
| HEVC VDENC | ExtBRC   | |check|   | |check| | |cross|   | |cross|     | |na|                    |
+            +----------+-----------+---------+-----------+-------------+                         +
|            | EncTools | |check|   | |check| | |cross|   | |cross|     |                         |
+            +----------+-----------+---------+-----------+-------------+                         +
|            | HW BRC   | |check|   | |check| | |cross| * | |cross| *   |                         |
+------------+----------+-----------+---------+-----------+-------------+------------+------------+
| AV1        | ExtBRC   | |cross|   | |na|                                                        |
+            +----------+-----------+                                                             +
|            | EncTools | |check|   |                                                             |
+            +----------+-----------+                                                             +
|            | HW BRC   | |check|   |                                                             |
+------------+----------+-----------+---------+-----------+-------------+------------+------------+

DG2 stands for Intel® Arc™ A-Series Graphics (products formerly Alchemist)

\* - requires enabled HuC (which is not a default in vanilla Linux kernel)

H.264/AVC
---------

EncTools
********

To achieve better quality with Intel GPU H.264/AVC encoder running EncTools BRC we recommend the following settings:

+-------------------------------------------------------+----------------+--------------------------------------------------------------------------+
| ffmpeg-qsv options                                    | ffmpeg version | Comments                                                                 |
+=======================================================+================+==========================================================================+
| VBR                                                                                                                                               |
+-------------------------------------------------------+----------------+--------------------------------------------------------------------------+
| ``-b:v $bitrate -maxrate $((2 * bitrate))``           | n2.8           | maxrate > bitrate triggers VBR. You can vary maxrate per your needs.     |
+-------------------------------------------------------+----------------+--------------------------------------------------------------------------+
| ``-bufsize $((4 * bitrate))``                         | n4.0           | You can vary bufsize per your needs. We recommend to avoid going below 1 |
|                                                       |                | second to avoid quality loss. Buffer size of 4 seconds is recommended    |
|                                                       |                | for VBR.                                                                 |
+-------------------------------------------------------+----------------+--------------------------------------------------------------------------+
| ``-rc_init_occupancy $((2 * bitrate))``               | n2.8           | This is the initial buffer delay. You can vary this per your needs.      |
|                                                       |                | Recommendation is to use 1/2 of bufsize.                                 |
+-------------------------------------------------------+----------------+--------------------------------------------------------------------------+
| CBR                                                                                                                                               |
+-------------------------------------------------------+----------------+--------------------------------------------------------------------------+
| ``-b:v $bitrate -minrate $bitrate -maxrate $bitrate`` | n2.8           | This triggers CBR.                                                       |
+-------------------------------------------------------+----------------+--------------------------------------------------------------------------+
| ``-bufsize $((2 * bitrate))``                         | n4.0           | You can vary bufsize per your needs. We recommend to avoid going below 1 |
|                                                       |                | second to avoid quality loss. Buffer size of 2 seconds is recommended    |
|                                                       |                | for CBR.                                                                 |
+-------------------------------------------------------+----------------+--------------------------------------------------------------------------+
| ``-rc_init_occupancy $bitrate``                       | n2.8           | This is the initial buffer delay. You can vary this per your needs.      |
|                                                       |                | Recommendation is to use 1/2 of bufsize.                                 |
+-------------------------------------------------------+----------------+--------------------------------------------------------------------------+
| CBR & VBR common settings                                                                                                                         |
+-------------------------------------------------------+----------------+--------------------------------------------------------------------------+
| ``-bitrate_limit 0``                                  | n3.0           | This disables target bitrate limitations that exist in MediaSDK/VPL for  |
|                                                       |                | AVC encoding                                                             |
+-------------------------------------------------------+----------------+--------------------------------------------------------------------------+
| ``-extbrc 1 -look_ahead_depth $lad``                  | n3.0           | This enables EncTools Software BRC when look ahead depth > than 0. Need  |
|                                                       |                | to have look ahead depth > than miniGOP size to enable low power look    |
|                                                       |                | ahead too (miniGOP size is equal to bf+1). The recommended values for    |
|                                                       |                | `$lad` are: 8 (for performance boost) and 40 (for quality boost)         |
+-------------------------------------------------------+----------------+--------------------------------------------------------------------------+
| ``-b_strategy 1 -bf 7``                               | n3.0           | These 2 settings activate full 3 level B-Pyramid.                        |
+-------------------------------------------------------+----------------+--------------------------------------------------------------------------+
| ``-refs 5``                                           | n2.7           | 5 references are important to trigger Long Term Reference (LTR) coding   |
|                                                       |                | feature.                                                                 |
+-------------------------------------------------------+----------------+--------------------------------------------------------------------------+
| ``-g 256``                                            | n2.7           | Select long enough GOP size for random access encoding. You can vary     |
|                                                       |                | this setting. Typically 2 to 4 seconds GOP is used.                      |
+-------------------------------------------------------+----------------+--------------------------------------------------------------------------+
| ``-adaptive_i 1 -adaptive_b 1``                       | n3.0           | Ensures to enable scene change detection and adaptive miniGOP.           |
+-------------------------------------------------------+----------------+--------------------------------------------------------------------------+
| ``-strict -1``                                        | n3.0           | Disables HRD compliance.                                                 |
+-------------------------------------------------------+----------------+--------------------------------------------------------------------------+
| ``-extra_hw_frames $lad``                             | n4.0           | Add extra GPU decoder frame surfaces.  This is currently needed for      |
|                                                       |                | transcoding with look ahead (set this option to look ahead depth value)  |
+-------------------------------------------------------+----------------+--------------------------------------------------------------------------+

::

  # VBR (encoding from YUV with ffmpeg-qsv)
  ffmpeg -init_hw_device vaapi=va:${DEVICE:-/dev/dri/renderD128} -init_hw_device qsv=hw@va -an \
    -f rawvideo -pix_fmt yuv420p -s:v ${width}x${height} -r $framerate -i $inputyuv \
    -frames:v $numframes -c:v h264_qsv -preset $preset -profile:v high -async_depth 1 \
    -b:v $bitrate -maxrate $((2 * bitrate)) -bitrate_limit 0 -bufsize $((4 * bitrate)) \
    -rc_init_occupancy $((2 * bitrate)) -low_power ${LOW_POWER:-true} -look_ahead_depth $lad -extbrc 1 \
    -b_strategy 1 -adaptive_i 1 -adaptive_b 1 -bf 7 -refs 5 -g 256 -strict -1 \
    -fps_mode auto -y $output

  # CBR (encoding from YUV with ffmpeg-qsv)
  ffmpeg -init_hw_device vaapi=va:${DEVICE:-/dev/dri/renderD128} -init_hw_device qsv=hw@va -an \
    -f rawvideo -pix_fmt yuv420p -s:v ${width}x${height} -r $framerate -i $inputyuv \
    -frames:v $numframes -c:v h264_qsv -preset $preset -profile:v high -async_depth 1 \
    -b:v $bitrate -maxrate $bitrate -minrate $bitrate -bitrate_limit 0 -bufsize $((2 * bitrate)) \
    -rc_init_occupancy $bitrate -low_power ${LOW_POWER:-true} -look_ahead_depth $lad -extbrc 1 \
    -b_strategy 1 -adaptive_i 1 -adaptive_b 1 -bf 7 -refs 5 -g 256 -strict -1 \
    -fps_mode auto -y $output

  # VBR (transcoding with ffmpeg-qsv)
  ffmpeg -hwaccel qsv -qsv_device ${DEVICE:-/dev/dri/renderD128} -c:v $inputcodec -extra_hw_frames $lad -an -i $input \
    -frames:v $numframes -c:v h264_qsv -preset $preset -profile:v high -async_depth 1 \
    -b:v $bitrate -maxrate $((2 * bitrate)) -bitrate_limit 0 -bufsize $((4 * bitrate)) \
    -rc_init_occupancy $((2 * bitrate)) -low_power ${LOW_POWER:-true} -look_ahead_depth $lad -extbrc 1 \
    -b_strategy 1 -adaptive_i 1 -adaptive_b 1 -bf 7 -refs 5 -g 256 -strict -1 \
    -fps_mode auto -y $output

  # CBR (transcoding with ffmpeg-qsv)
  ffmpeg -hwaccel qsv -qsv_device ${DEVICE:-/dev/dri/renderD128} -c:v $inputcodec -extra_hw_frames $lad -an -i $input \
    -frames:v $numframes -c:v h264_qsv -preset $preset -profile:v high -async_depth 1 \
    -b:v $bitrate -maxrate $bitrate -minrate $bitrate -bitrate_limit 0 -bufsize $((2 * bitrate)) \
    -rc_init_occupancy $bitrate -low_power ${LOW_POWER:-true} -look_ahead_depth $lad -extbrc 1 \
    -b_strategy 1 -adaptive_i 1 -adaptive_b 1 -bf 7 -refs 5 -g 256 -strict -1 \
    -fps_mode auto -y $output

  # VBR (encoding from YUV with Sample Multi-Transcode)
  sample_multi_transcode -i::i420 $inputyuv -hw -async 1 \
    -device ${DEVICE:-/dev/dri/renderD128} -u $preset -b $bitrateKb -vbr -n $numframes \
    -w $width -h $height -override_encoder_framerate $framerate -lowpower:${LOWPOWER:-on} -lad $lad \
    -extbrc::implicit -AdaptiveI:on -AdaptiveB:on -dist 8 -num_ref 5 -gop_size 256 \
    -NalHrdConformance:off -VuiNalHrdParameters:off -hrd $((bitrateKb / 2)) \
    -InitialDelayInKB $((bitrateKb / 4)) -MaxKbps $((bitrateKb * 2)) -o::h264 $output

  # CBR (encoding from YUV with Sample Multi-Transcode)
  sample_multi_transcode -i::i420 $inputyuv -hw -async 1 \
    -device ${DEVICE:-/dev/dri/renderD128} -u $preset -b $bitrateKb -cbr -n $numframes \
    -w $width -h $height  -override_encoder_framerate $framerate -lowpower:${LOWPOWER:-on} -lad $lad \
    -extbrc::implicit -AdaptiveI:on -AdaptiveB:on -dist 8 -num_ref 5 -gop_size 256 \
    -NalHrdConformance:off -VuiNalHrdParameters:off -hrd $((bitrateKb / 4)) \
    -InitialDelayInKB $((bitrateKb / 8)) -o::h264 $output

  # VBR (transcoding from raw bitstream with Sample Multi-Transcode)
  sample_multi_transcode -i::${inputcodec} $input -hw -async 1 \
    -device ${DEVICE:-/dev/dri/renderD128} -u $preset -b $bitrateKb -vbr -n $numframes \
    -lowpower:${LOWPOWER:-on} -lad $lad -extbrc::implicit -AdaptiveI:on -AdaptiveB:on -dist 8 -num_ref 5 -gop_size 256 \
    -NalHrdConformance:off -VuiNalHrdParameters:off -hrd $((bitrateKb / 2)) \
    -InitialDelayInKB $((bitrateKb / 4)) -MaxKbps $((bitrateKb * 2)) -o::h264 $output

  # CBR (transcoding from raw bitstream with Sample Multi-Transcode)
  sample_multi_transcode -i::${inputcodec} $input -hw -async 1 \
    -device ${DEVICE:-/dev/dri/renderD128} -u $preset -b $bitrateKb -cbr -n $numframes \
    -lowpower:${LOWPOWER:-on} -lad $lad -extbrc::implicit -AdaptiveI:on -AdaptiveB:on -dist 8 -num_ref 5 -gop_size 256 \
    -NalHrdConformance:off -VuiNalHrdParameters:off -hrd $((bitrateKb / 4)) \
    -InitialDelayInKB $((bitrateKb / 8)) -o::h264 $output

ExtBRC
******

To achieve better quality with Intel GPU H.264/AVC encoder running ExtBRC we recommend the following settings:

+-------------------------------------------------------+----------------+--------------------------------------------------------------------------+
| ffmpeg-qsv options                                    | ffmpeg version | Comments                                                                 |
+=======================================================+================+==========================================================================+
| VBR                                                                                                                                               |
+-------------------------------------------------------+----------------+--------------------------------------------------------------------------+
| ``-b:v $bitrate -maxrate $((2 * bitrate))``           | n2.8           | maxrate > bitrate triggers VBR. You can vary maxrate per your needs.     |
+-------------------------------------------------------+----------------+--------------------------------------------------------------------------+
| ``-bufsize $((4 * bitrate))``                         | n4.0           | You can vary bufsize per your needs. We recommend to avoid going below 1 |
|                                                       |                | second to avoid quality loss. Buffer size of 4 seconds is recommended    |
|                                                       |                | for VBR.                                                                 |
+-------------------------------------------------------+----------------+--------------------------------------------------------------------------+
| ``-rc_init_occupancy $((2 * bitrate))``               | n2.8           | This is the initial buffer delay. You can vary this per your needs.      |
|                                                       |                | Recommendation is to use 1/2 of bufsize.                                 |
+-------------------------------------------------------+----------------+--------------------------------------------------------------------------+
| CBR                                                                                                                                               |
+-------------------------------------------------------+----------------+--------------------------------------------------------------------------+
| ``-b:v $bitrate -minrate $bitrate -maxrate $bitrate`` | n2.8           | This triggers CBR.                                                       |
+-------------------------------------------------------+----------------+--------------------------------------------------------------------------+
| ``-bufsize $((2 * bitrate))``                         | n4.0           | You can vary bufsize per your needs. We recommend to avoid going below 1 |
|                                                       |                | second to avoid quality loss. Buffer size of 2 seconds is recommended    |
|                                                       |                | for CBR.                                                                 |
+-------------------------------------------------------+----------------+--------------------------------------------------------------------------+
| ``-rc_init_occupancy $bitrate``                       | n2.8           | This is ithe initial buffer delay. You can vary this per your needs.     |
|                                                       |                | Recommendation is to use 1/2 of bufsize.                                 |
+-------------------------------------------------------+----------------+--------------------------------------------------------------------------+
| CBR & VBR common settings                                                                                                                         |
+-------------------------------------------------------+----------------+--------------------------------------------------------------------------+
| ``-bitrate_limit 0``                                  | n3.0           | This disables target bitrate limitations that exist in MediaSDK/VPL for  |
|                                                       |                | AVC encoding                                                             |
+-------------------------------------------------------+----------------+--------------------------------------------------------------------------+
| ``-extbrc 1``                                         |                | This enabled ExtBRC Software BRC                                         |
+-------------------------------------------------------+----------------+--------------------------------------------------------------------------+
| ``-b_strategy 1 -bf 7``                               | n3.0           | These 2 settings activate full 3 level B-Pyramid.                        |
+-------------------------------------------------------+----------------+--------------------------------------------------------------------------+
| ``-refs 5``                                           | n2.7           | 5 references are important to trigger Long Term Reference (LTR) coding   |
|                                                       |                | feature.                                                                 |
+-------------------------------------------------------+----------------+--------------------------------------------------------------------------+
| ``-g 256``                                            | n2.7           | Select long enough GOP size for random access encoding. You can vary     |
|                                                       |                | this setting. Typically 2 to 4 seconds GOP is used.                      |
+-------------------------------------------------------+----------------+--------------------------------------------------------------------------+

Example command lines:

::

  # VBR (encoding from YUV with ffmpeg-qsv)
  ffmpeg -init_hw_device vaapi=va:${DEVICE:-/dev/dri/renderD128} -init_hw_device qsv=hw@va -an \
    -f rawvideo -pix_fmt yuv420p -s:v ${width}x${height} -r $framerate \
    -i $inputyuv -frames:v $numframes -c:v h264_qsv -preset $preset -profile:v high -async_depth 1 \
    -b:v $bitrate -maxrate $((2 * bitrate)) -bitrate_limit 0 -bufsize $((4 * bitrate)) \
    -rc_init_occupancy $((2 * bitrate)) -low_power ${LOW_POWER:-false} -extbrc 1 -b_strategy 1 -bf 7 -refs 5 -g 256 \
    -fps_mode auto -y $output

  # CBR (encoding from YUV with ffmpeg-qsv)
  ffmpeg -init_hw_device vaapi=va:${DEVICE:-/dev/dri/renderD128} -init_hw_device qsv=hw@va -an \
    -f rawvideo -pix_fmt yuv420p -s:v ${width}x${height} -r $framerate \
    -i $inputyuv -vframes $numframes -c:v h264_qsv -preset $preset -profile:v high \
    -b:v $bitrate -maxrate $bitrate -minrate $bitrate -bitrate_limit 0 -bufsize $((2 * bitrate)) \
    -rc_init_occupancy $bitrate -low_power ${LOW_POWER:-false} -extbrc 1 -b_strategy 1 -bf 7 -refs 5 -g 256 \
    -fps_mode auto -y $output

  # VBR (transcoding with ffmpeg-qsv)
  ffmpeg -hwaccel qsv -qsv_device ${DEVICE:-/dev/dri/renderD128} -c:v $inputcodec -an -i $input \
    -frames:v $numframes -c:v h264_qsv -preset h264_qsv -profile:v high -async_depth 1 \
    -b:v $bitrate -maxrate $((2 * bitrate)) -bitrate_limit 0 -bufsize $((4 * bitrate)) \
    -rc_init_occupancy $((2 * bitrate)) -low_power ${LOW_POWER:-false} -extbrc 1 -b_strategy 1 -bf 7 -refs 5 -g 256 \
    -fps_mode auto -y $output

  # CBR (transcoding with ffmpeg-qsv)
  ffmpeg -hwaccel qsv -qsv_device ${DEVICE:-/dev/dri/renderD128} -c:v $inputcodec -an -i $input \
    -frames:v $numframes -c:v h264_qsv -preset h264_qsv -profile:v high -async_depth 1 \
    -b:v $bitrate -maxrate $bitrate -minrate $bitrate -bitrate_limit 0 -bufsize $((2 * bitrate)) \
    -rc_init_occupancy $bitrate -low_power ${LOW_POWER:-false} -extbrc 1 -b_strategy 1 -bf 7 -refs 5 -g 256 \
    -fps_mode auto -y $output

  # VBR (encoding from YUV with Sample Multi-Transcode)
  sample_multi_transcode -i::i420 $inputyuv -hw -async 1 -device ${DEVICE:-/dev/dri/renderD128} \
    -u $preset -b $bitrateKb -vbr -n $numframes -w $width -h $height -override_encoder_framerate $framerate \
    -lowpower:${LOWPOWER:-off} -extbrc::implicit -ExtBrcAdaptiveLTR:on -dist 8 -num_ref 5 -gop_size 256 \
    -NalHrdConformance:off -VuiNalHrdParameters:off -hrd $((bitrateKb / 2)) \
    -InitialDelayInKB $((bitrateKb / 4)) -MaxKbps $((bitrateKb * 2)) -o::h264 $output

  # CBR (encoding from YUV with Sample Multi-Transcode)
  sample_multi_transcode -i::i420 $inputyuv -hw -async 1 -device ${DEVICE:-/dev/dri/renderD128} \
    -u $preset -b $bitrateKb -cbr -n $numframes -w $width -h $height -override_encoder_framerate $framerate \
    -lowpower:${LOWPOWER:-off} -extbrc::implicit -ExtBrcAdaptiveLTR:on -dist 8 -num_ref 5 -gop_size 256 \
    -NalHrdConformance:off -VuiNalHrdParameters:off -hrd $((bitrateKb / 4)) \
    -InitialDelayInKB $((bitrateKb / 8)) -o::h264 $output

  # VBR (transcoding from raw bitstream with Sample Multi-Transcode)
  sample_multi_transcode -i::${inputcodec} $input -hw -async 1 -device ${DEVICE:-/dev/dri/renderD128} \
    -u $preset -b $bitrateKb -vbr -n $numframes -lowpower:${LOWPOWER:-off} \
    -extbrc::implicit -ExtBrcAdaptiveLTR:on -dist 8 -num_ref 5 -gop_size 256 \
    -NalHrdConformance:off -VuiNalHrdParameters:off -MemType::system -hrd $((bitrateKb / 2)) \
    -InitialDelayInKB $((bitrateKb / 4)) -MaxKbps $((bitrateKb * 2)) -o::h264 $output

  # CBR (transcoding from raw bitstream with Sample Multi-Transcode)
  sample_multi_transcode -i::${inputcodec} $input -hw -async 1 -device ${DEVICE:-/dev/dri/renderD128} \
    -u $preset -b $bitrateKb -cbr -n $numframes -lowpower:${LOWPOWER:-off} \
    -extbrc::implicit -ExtBrcAdaptiveLTR:on -dist 8 -num_ref 5 -gop_size 256 \
    -NalHrdConformance:off -VuiNalHrdParameters:off -MemType::system -hrd $((bitrateKb / 4)) \
    -InitialDelayInKB $((bitrateKb / 8)) -o::h264 $output

H.265/HEVC
----------

EncTools
********

To achieve better quality with Intel GPU H.265/HEVC encoder running EncTools BRC we recommend the following settings:

+-------------------------------------------------------+----------------+--------------------------------------------------------------------------+
| ffmpeg-qsv options                                    | ffmpeg version | Comments                                                                 |
+=======================================================+================+==========================================================================+
| VBR                                                                                                                                               |
+-------------------------------------------------------+----------------+--------------------------------------------------------------------------+
| ``-b:v $bitrate -maxrate $((2 * bitrate))``           | n2.8           | maxrate > bitrate triggers VBR. You can vary maxrate per your needs.     |
+-------------------------------------------------------+----------------+--------------------------------------------------------------------------+
| ``-bufsize $((4 * bitrate))``                         | n4.0           | You can vary bufsize per your needs. We recommend to avoid going below 1 |
|                                                       |                | second to avoid quality loss. Buffer size of 4 seconds is recommended    |
|                                                       |                | for VBR.                                                                 |
+-------------------------------------------------------+----------------+--------------------------------------------------------------------------+
| ``-rc_init_occupancy $((2 * bitrate))``               | n2.8           | This is the initial buffer delay. You can vary this per your needs.      |
|                                                       |                | Recommendation is to use 1/2 of bufsize.                                 |
+-------------------------------------------------------+----------------+--------------------------------------------------------------------------+
| CBR                                                                                                                                               |
+-------------------------------------------------------+----------------+--------------------------------------------------------------------------+
| ``-b:v $bitrate -minrate $bitrate -maxrate $bitrate`` | n2.8           | This triggers CBR.                                                       |
+-------------------------------------------------------+----------------+--------------------------------------------------------------------------+
| ``-bufsize $((2 * bitrate))``                         | n4.0           | You can vary bufsize per your needs. We recommend to avoid going below 1 |
|                                                       |                | second to avoid quality loss. Buffer size of 2 seconds is recommended    |
|                                                       |                | for CBR.                                                                 |
+-------------------------------------------------------+----------------+--------------------------------------------------------------------------+
| ``-rc_init_occupancy $bitrate``                       | n2.8           | This is the initial buffer delay. You can vary this per your needs.      |
|                                                       |                | Recommendation is to use 1/2 of bufsize.                                 |
+-------------------------------------------------------+----------------+--------------------------------------------------------------------------+
| CBR & VBR common settings                                                                                                                         |
+-------------------------------------------------------+----------------+--------------------------------------------------------------------------+
| ``-extbrc 1 -look_ahead_depth $lad``                  | n5.0           | This enables EncTools Software BRC when look ahead depth > than 0. Need  |
|                                                       |                | to have look ahead depth > than miniGOP size to enable low power look    |
|                                                       |                | ahead too (miniGOP size is equal to bf+1). The recommended values for    |
|                                                       |                | `$lad` are: 8 (for performance boost) and 40 (for quality boost)         |
+-------------------------------------------------------+----------------+--------------------------------------------------------------------------+
| ``-b_strategy 1 -bf 7``                               | n6.0           | These 2 settings activate full 3 level B-Pyramid.                        |
+-------------------------------------------------------+----------------+--------------------------------------------------------------------------+
| ``-refs 4``                                           | n2.8           | 4 reference are recommended for high quality HEVC encoding.              |
+-------------------------------------------------------+----------------+--------------------------------------------------------------------------+
| ``-g 256``                                            | n2.8           | Select long enough GOP size for random access encoding. You can vary     |
|                                                       |                | this setting. Typically 2 to 4 seconds GOP is used.                      |
+-------------------------------------------------------+----------------+--------------------------------------------------------------------------+
| ``-strict -1``                                        | n5.0           | Disables HRD compliance.                                                 |
+-------------------------------------------------------+----------------+--------------------------------------------------------------------------+
| ``-idr_interval begin_only``                          | n4.0           | Only first I-frame will be IDR, other I-frames will be CRA.              |
+-------------------------------------------------------+----------------+--------------------------------------------------------------------------+
| ``-extra_hw_frames $lad``                             | n4.0           | Add extra GPU decoder frame surfaces.  This is currently needed for      |
|                                                       |                | transcoding with look ahead (set this option to look ahead depth value)  |
+-------------------------------------------------------+----------------+--------------------------------------------------------------------------+

Example command lines:

::

  # VBR (encoding from YUV with ffmpeg-qsv)
  ffmpeg -init_hw_device vaapi=va:${DEVICE:-/dev/dri/renderD128} -init_hw_device qsv=hw@va -an \
    -f rawvideo -pix_fmt yuv420p -s:v ${width}x${height} -r $framerate -i $inputyuv \
    -frames:v $numframes -c:v hevc_qsv -preset $preset -profile:v main -async_depth 1
    -b:v $bitrate -maxrate $((2 * bitrate)) -bufsize $((4 * bitrate)) \
    -rc_init_occupancy $((2 * bitrate)) -low_power ${LOW_POWER:-true} -look_ahead_depth $lad -extbrc 1 -b_strategy 1 \
    -bf 7 -refs 4 -g 256 -idr_interval begin_only -strict -1 \
    -fps_mode auto -y $output

  # CBR (encoding from YUV with ffmpeg-qsv)
  ffmpeg -init_hw_device vaapi=va:${DEVICE:-/dev/dri/renderD128} -init_hw_device qsv=hw@va -an \
    -f rawvideo -pix_fmt yuv420p -s:v ${width}x${height} -r $framerate -i $inputyuv \
    -frames:v $numframes -c:v hevc_qsv -preset $preset -profile:v main -async_depth 1
    -b:v $bitrate -maxrate $bitrate -minrate $bitrate -bufsize $((2 * bitrate)) \
    -rc_init_occupancy $bitrate -low_power ${LOW_POWER:-true} -look_ahead_depth $lad -extbrc 1 -b_strategy 1 \
    -bf 7 -refs 4 -g 256 -idr_interval begin_only -strict -1 \
    -fps_mode auto -y $output

  # VBR (transcoding with ffmpeg-qsv)
  ffmpeg -hwaccel qsv -qsv_device ${DEVICE:-/dev/dri/renderD128} -c:v $inputcodec -extra_hw_frames $lad -an -i $input \
    -frames:v $numframes -c:v hevc_qsv -preset $preset -profile:v main -async_depth 1 \
    -b:v $bitrate -maxrate $((2 * bitrate)) -bufsize $((4 * bitrate)) \
    -rc_init_occupancy $((2 * bitrate)) -low_power ${LOW_POWER:-true} -look_ahead_depth $lad -extbrc 1 -b_strategy 1 \
    -bf 7 -refs 4 -g 256 -idr_interval begin_only -strict -1 \
    -fps_mode auto -y $output

  # CBR (transcoding with ffmpeg-qsv)
  ffmpeg -hwaccel qsv -qsv_device ${DEVICE:-/dev/dri/renderD128} -c:v $inputcodec -extra_hw_frames $lad -an -i $input \
    -frames:v $numframes -c:v hevc_qsv -preset $preset -profile:v main -async_depth 1 \
    -b:v $bitrate -maxrate $bitrate -minrate $bitrate -bufsize $((2 * bitrate)) \
    -rc_init_occupancy $bitrate -low_power ${LOW_POWER:-true} -look_ahead_depth $lad -extbrc 1 -b_strategy 1 \
    -bf 7 -refs 4 -g 256 -idr_interval begin_only -strict -1 \
    -fps_mode auto -y $output

  # VBR (encoding from YUV with Sample Multi-Transcode)
  sample_multi_transcode -i::i420 $inputyuv -hw -async 1 -device ${DEVICE:-/dev/dri/renderD128} \
    -u $preset -b $bitrateKb -vbr -n $numframes -w $width -h $height -override_encoder_framerate $framerate \
    -lowpower:${LOWPOWER:-on} -lad $lad -extbrc::implicit -AdaptiveI:on -AdaptiveB:on -dist 8 -num_ref 4 -gop_size 256 \
    -NalHrdConformance:off -VuiNalHrdParameters:off -hrd $((bitrateKb / 2)) \
    -InitialDelayInKB $((bitrateKb / 4)) -MaxKbps $((bitrateKb * 2)) -o::h265 $output

  # CBR (encoding from YUV with Sample Multi-Transcode)
  sample_multi_transcode -i::i420 $inputyuv -hw -async 1 -device ${DEVICE:-/dev/dri/renderD128} \
    -u $preset -b $bitrateKb -cbr -n $numframes -w $width -h $height -override_encoder_framerate $framerate \
    -lowpower:${LOWPOWER:-on} -lad $lad -extbrc::implicit -AdaptiveI:on -AdaptiveB:on -dist 8 -num_ref 4 -gop_size 256 \
    -NalHrdConformance:off -VuiNalHrdParameters:off -hrd $((bitrateKb / 4)) \
    -InitialDelayInKB $((bitrateKb / 8)) -o::h265 $output

  # VBR (transcoding from raw bitstream with Sample Multi-Transcode)
  sample_multi_transcode -i::${inputcodec} $input -hw -async 1 -device ${DEVICE:-/dev/dri/renderD128} \
    -u $preset -b $bitrateKb -vbr -n $numframes -lowpower:${LOWPOWER:-on} \
    -lad $lad -extbrc::implicit -AdaptiveI:on -AdaptiveB:on -dist 8 -num_ref 4 -gop_size 256 \
    -NalHrdConformance:off -VuiNalHrdParameters:off -hrd $((bitrateKb / 2)) \
    -InitialDelayInKB $((bitrateKb / 4)) -MaxKbps $((bitrateKb * 2)) -o::h265 $output

  # CBR (transcoding from raw bitstream with Sample Multi-Transcode)
  sample_multi_transcode -i::${inputcodec} $input -hw -async 1 -device ${DEVICE:-/dev/dri/renderD128} \
    -u $preset -b $bitrateKb -cbr -n $numframes -lowpower:${LOWPOWER:-on} \
    -lad $lad -extbrc::implicit -AdaptiveI:on -AdaptiveB:on -dist 8 -num_ref 4 -gop_size 256 \
    -NalHrdConformance:off -VuiNalHrdParameters:off -hrd $((bitrateKb / 4)) \
    -InitialDelayInKB $((bitrateKb / 8)) -o::h265 $output


ExtBRC
******

To achieve better quality with Intel GPU H.265/HEVC encoder running ExtBRC we recommend the following settings:

+-------------------------------------------------------+----------------+--------------------------------------------------------------------------+
| ffmpeg-qsv options                                    | ffmpeg version | Comments                                                                 |
+=======================================================+================+==========================================================================+
| VBR                                                                                                                                               |
+-------------------------------------------------------+----------------+--------------------------------------------------------------------------+
| ``-b:v $bitrate -maxrate $((2 * bitrate))``           | n2.8           | maxrate > bitrate triggers VBR. You can vary maxrate per your needs.     |
+-------------------------------------------------------+----------------+--------------------------------------------------------------------------+
| ``-bufsize $((4 * bitrate))``                         | n4.0           | You can vary bufsize per your needs. We recommend to avoid going below 1 |
|                                                       |                | second to avoid quality loss. Buffer size of 4 seconds is recommended    |
|                                                       |                | for VBR.                                                                 |
+-------------------------------------------------------+----------------+--------------------------------------------------------------------------+
| ``-rc_init_occupancy $((2 * bitrate))``               | n2.8           | This is the initial buffer delay. You can vary this per your needs.      |
|                                                       |                | Recommendation is to use 1/2 of bufsize.                                 |
+-------------------------------------------------------+----------------+--------------------------------------------------------------------------+
| CBR                                                                                                                                               |
+-------------------------------------------------------+----------------+--------------------------------------------------------------------------+
| ``-b:v $bitrate -minrate $bitrate -maxrate $bitrate`` | n2.8           | This triggers CBR.                                                       |
+-------------------------------------------------------+----------------+--------------------------------------------------------------------------+
| ``-bufsize $((2 * bitrate))``                         | n4.0           | You can vary bufsize per your needs. We recommend to avoid going below 1 |
|                                                       |                | second to avoid quality loss. Buffer size of 2 seconds is recommended    |
|                                                       |                | for CBR.                                                                 |
+-------------------------------------------------------+----------------+--------------------------------------------------------------------------+
| ``-rc_init_occupancy $bitrate``                       | n2.8           | This is the initial buffer delay. You can vary this per your needs.      |
|                                                       |                | Recommendation is to use 1/2 of bufsize.                                 |
+-------------------------------------------------------+----------------+--------------------------------------------------------------------------+
| CBR & VBR common settings                                                                                                                         |
+-------------------------------------------------------+----------------+--------------------------------------------------------------------------+
| ``-extbrc 1``                                         | n4.3           | This enabled ExtBRC Software BRC                                         |
+-------------------------------------------------------+----------------+--------------------------------------------------------------------------+
| ``-bf 7``                                             | n2.8           | B-Pyramid is ON by default (to be explicit, add ``-b_strategy 1``, but   |
|                                                       |                | this setting is supported in ffmpeg n6.0 and later for HEVC). ``-bf 7``  |
|                                                       |                | enables full 3 level B-Pyramid.                                          |
+-------------------------------------------------------+----------------+--------------------------------------------------------------------------+
| ``-refs 4``                                           | n2.8           | 4 reference are recommended for high quality HEVC encoding.              |
+-------------------------------------------------------+----------------+--------------------------------------------------------------------------+
| ``-g 256``                                            | n2.7           | Select long enough GOP size for random access encoding. You can vary     |
|                                                       |                | this setting. Typically 2 to 4 seconds GOP is used.                      |
+-------------------------------------------------------+----------------+--------------------------------------------------------------------------+

Example command lines:

::

  # VBR (encoding from YUV with ffmpeg-qsv)
  ffmpeg -init_hw_device vaapi=va:${DEVICE:-/dev/dri/renderD128} -init_hw_device qsv=hw@va -an \
    -f rawvideo -pix_fmt yuv420p -s:v ${width}x${height} -r $framerate -i $inputyuv \
    -frames:v $numframes -c:v hevc_qsv -preset $preset -profile:v main -async_depth 1 \
    -b:v $bitrate -maxrate $((2 * bitrate)) -bufsize $((4 * bitrate)) \
    -rc_init_occupancy $((2 * bitrate)) -low_power ${LOW_POWER:-false} -extbrc 1 -bf 7 -refs 4 -g 256 \
    -fps_mode auto -y $output

  # CBR (encoding from YUV with ffmpeg-qsv)
  ffmpeg -init_hw_device vaapi=va:${DEVICE:-/dev/dri/renderD128} -init_hw_device qsv=hw@va -an \
    -f rawvideo -pix_fmt yuv420p -s:v ${width}x${height} -r $framerate -i $inputyuv \
    -frames:v $numframes -c:v hevc_qsv -preset $preset -profile:v main -async_depth 1 \
    -b:v $bitrate -maxrate $bitrate -minrate $bitrate -bufsize $((2 * bitrate)) \
    -rc_init_occupancy $bitrate -low_power ${LOW_POWER:-false} -extbrc 1 -bf 7 -refs 4 -g 256 \
    -fps_mode auto -y $output

  # VBR (transcoding with ffmpeg-qsv)
  ffmpeg -hwaccel qsv -qsv_device ${DEVICE:-/dev/dri/renderD128} -c:v $inputcodec -an -i $input \
    -frames:v $numframes -c:v hevc_qsv -preset $preset -profile:v main -async_depth 1 \
    -b:v $bitrate -maxrate $((2 * bitrate)) -bufsize $((4 * bitrate)) \
    -rc_init_occupancy $((2 * bitrate)) -low_power ${LOW_POWER:-false} -extbrc 1 -bf 7 -refs 4 -g 256 \
    -fps_mode auto -y $output

  # CBR (transcoding with ffmpeg-qsv)
  ffmpeg -hwaccel qsv -qsv_device ${DEVICE:-/dev/dri/renderD128} -c:v $inputcodec -an -i $input \
    -frames:v $numframes -c:v hevc_qsv -preset $preset -profile:v main -async_depth 1 \
    -b:v $bitrate -maxrate $bitrate -minrate $bitrate -bufsize $((2 * bitrate)) \
    -rc_init_occupancy $bitrate -low_power ${LOW_POWER:-false} -extbrc 1 -bf 7 -refs 4 -g 256 \
    -fps_mode auto -y $output

  # VBR (encoding from YUV with Sample Multi-Transcode)
  sample_multi_transcode -i::i420 $inputyuv -hw -async 1 -device ${DEVICE:-/dev/dri/renderD128} \
    -u $preset -b $bitrateKb -vbr -n $numframes -w $width -h $height -override_encoder_framerate $framerate \
    -lowpower:${LOWPOWER:-off} -extbrc::implicit -dist 8 -num_ref 4 -gop_size 256 \
    -NalHrdConformance:off -VuiNalHrdParameters:off -hrd $((bitrateKb / 2)) \
    -InitialDelayInKB $((bitrateKb / 4)) -MaxKbps $((bitrateKb * 2)) -o::h265 $output

  # CBR (encoding from YUV with Sample Multi-Transcode)
  sample_multi_transcode -i::i420 $inputyuv -hw -async 1 -device ${DEVICE:-/dev/dri/renderD128} \
    -u $preset -b $bitrateKb -cbr -n $numframes -w $width -h $height -override_encoder_framerate $framerate \
    -lowpower:${LOWPOWER:-off} -extbrc::implicit -dist 8 -num_ref 4 -gop_size 256 \
    -NalHrdConformance:off -VuiNalHrdParameters:off -hrd $((bitrateKb / 4)) \
    -InitialDelayInKB $((bitrateKb / 8)) -o::h265 $output

  # VBR (transcoding from raw bitstream with Sample Multi-Transcode)
  sample_multi_transcode -i::${inputcodec} $input -hw -async 1 -device ${DEVICE:-/dev/dri/renderD128} \
    -u $preset -b $bitrateKb -vbr -n $numframes -lowpower:${LOWPOWER:-off} \
    -extbrc::implicit -dist 8 -num_ref 4 -gop_size 256 -NalHrdConformance:off -VuiNalHrdParameters:off \
    -hrd $((bitrateKb / 2)) -InitialDelayInKB $((bitrateKb / 4)) -MaxKbps $((bitrateKb * 2)) \
    -o::h265 $output

  # CBR (transcoding from raw bitstream with Sample Multi-Transcode)
  sample_multi_transcode -i::${inputcodec} $input -hw -async 1 -device ${DEVICE:-/dev/dri/renderD128} \
    -u $preset -b $bitrateKb -cbr -n $numframes -lowpower:${LOWPOWER:-off} \
    -extbrc::implicit -dist 8 -num_ref 4 -gop_size 256 -NalHrdConformance:off -VuiNalHrdParameters:off \
    -hrd $((bitrateKb / 4)) -InitialDelayInKB $((bitrateKb / 8)) \
    -o::h265 $output

AV1
---

EncTools
********

To achieve better quality with Intel GPU AV1 encoder running EncTools BRC we recommend the following settings:

+-------------------------------------------------------+----------------+--------------------------------------------------------------------------+
| ffmpeg-qsv options                                    | ffmpeg version | Comments                                                                 |
+=======================================================+================+==========================================================================+
| VBR                                                                                                                                               |
+-------------------------------------------------------+----------------+--------------------------------------------------------------------------+
| ``-b:v $bitrate -maxrate $((2 * bitrate))``           | n6.0           | maxrate > bitrate triggers VBR. You can vary maxrate per your needs.     |
+-------------------------------------------------------+----------------+--------------------------------------------------------------------------+
| ``-bufsize $((4 * bitrate))``                         | n6.0           | You can vary bufsize per your needs. We recommend to avoid going below 1 |
|                                                       |                | second to avoid quality loss. Buffer size of 4 seconds is recommended    |
|                                                       |                | for VBR.                                                                 |
+-------------------------------------------------------+----------------+--------------------------------------------------------------------------+
| ``-rc_init_occupancy $((2 * bitrate))``               | n6.0           | This is the initial buffer delay. You can vary this per your needs.      |
|                                                       |                | Recommendation is to use 1/2 of bufsize.                                 |
+-------------------------------------------------------+----------------+--------------------------------------------------------------------------+
| CBR                                                                                                                                               |
+-------------------------------------------------------+----------------+--------------------------------------------------------------------------+
| ``-b:v $bitrate -minrate $bitrate -maxrate $bitrate`` | n6.0           | This triggers CBR.                                                       |
+-------------------------------------------------------+----------------+--------------------------------------------------------------------------+
| ``-bufsize $((2 * bitrate))``                         | n6.0           | You can vary bufsize per your needs. We recommend to avoid going below 1 |
|                                                       |                | second to avoid quality loss. Buffer size of 2 seconds is recommended    |
|                                                       |                | for CBR.                                                                 |
+-------------------------------------------------------+----------------+--------------------------------------------------------------------------+
| ``-rc_init_occupancy $bitrate``                       | n6.0           | This is the initial buffer delay. You can vary this per your needs.      |
|                                                       |                | Recommendation is to use 1/2 of bufsize.                                 |
+-------------------------------------------------------+----------------+--------------------------------------------------------------------------+
| CBR & VBR common settings                                                                                                                         |
+-------------------------------------------------------+----------------+--------------------------------------------------------------------------+
| ``-extbrc 1 -look_ahead_depth $lad``                  | n6.0           | This enables EncTools Software BRC when look ahead depth > than 0. Need  |
|                                                       |                | to have look ahead depth > than miniGOP size to enable low power look    |
|                                                       |                | ahead too (miniGOP size is equal to bf+1). The recommended values for    |
|                                                       |                | `$lad` are: 8 (for performance boost) and 40 (for quality boost)         |
+-------------------------------------------------------+----------------+--------------------------------------------------------------------------+
| ``-b_strategy 1 -bf 7``                               | n6.0           | These 2 settings activate full 3 level B-Pyramid.                        |
+-------------------------------------------------------+----------------+--------------------------------------------------------------------------+
| ``-g 256``                                            | n6.0           | Select long enough GOP size for random access encoding. You can vary     |
|                                                       |                | this setting. Typically 2 to 4 seconds GOP is used.                      |
+-------------------------------------------------------+----------------+--------------------------------------------------------------------------+
| ``-adaptive_i 1 -adaptive_b 1``                       | n6.0           | Ensures to enable scene change detection and adaptive miniGOP.           |
+-------------------------------------------------------+----------------+--------------------------------------------------------------------------+
| ``-strict -1``                                        | n6.0           | Disables HRD compliance.                                                 |
+-------------------------------------------------------+----------------+--------------------------------------------------------------------------+
| ``-extra_hw_frames $lad``                             | n6.0           | Add extra GPU decoder frame surfaces.  This is currently needed for      |
|                                                       |                | transcoding with look ahead (set this option to look ahead depth value)  |
+-------------------------------------------------------+----------------+--------------------------------------------------------------------------+

::

  # VBR (encoding from YUV with ffmpeg-qsv)
  ffmpeg -init_hw_device vaapi=va:${DEVICE:-/dev/dri/renderD128} -init_hw_device qsv=hw@va -an \
    -f rawvideo -pix_fmt yuv420p -s:v ${width}x${height} -r $framerate -i $inputyuv \
    -frames:v $numframes -c:v av1_qsv -preset $preset -profile:v main -async_depth 1 \
    -b:v $bitrate -maxrate $((2 * bitrate)) -bufsize $((4 * bitrate)) \
    -rc_init_occupancy $((2 * bitrate)) -low_power ${LOW_POWER:-true} -look_ahead_depth $lad -extbrc 1 \
    -b_strategy 1 -adaptive_i 1 -adaptive_b 1 -bf 7 -g 256 -strict -1 \
    -fps_mode auto -y $output

  # CBR (encoding from YUV with ffmpeg-qsv)
  ffmpeg -init_hw_device vaapi=va:${DEVICE:-/dev/dri/renderD128} -init_hw_device qsv=hw@va -an \
    -f rawvideo -pix_fmt yuv420p -s:v ${width}x${height} -r $framerate -i $inputyuv \
    -frames:v $numframes -c:v av1_qsv -preset $preset -profile:v main -async_depth 1 \
    -b:v $bitrate -maxrate $bitrate -minrate $bitrate -bufsize $((2 * bitrate)) \
    -rc_init_occupancy $bitrate -low_power ${LOW_POWER:-true} -look_ahead_depth $lad -extbrc 1 \
    -b_strategy 1 -adaptive_i 1 -adaptive_b 1 -bf 7 -g 256 -strict -1 \
    -fps_mode auto -y $output

  # VBR (transcoding with ffmpeg-qsv)
  ffmpeg -hwaccel qsv -qsv_device ${DEVICE:-/dev/dri/renderD128} -c:v $inputcodec -extra_hw_frames $lad -an -i $input \
    -frames:v $numframes -c:v av1_qsv -preset $preset -profile:v main -async_depth 1 \
    -b:v $bitrate -maxrate $((2 * bitrate)) -bufsize $((4 * bitrate)) \
    -rc_init_occupancy $((2 * bitrate)) -low_power ${LOW_POWER:-true} -look_ahead_depth $lad -extbrc 1 \
    -b_strategy 1 -adaptive_i 1 -adaptive_b 1 -bf 7 -g 256 -strict -1 \
    -fps_mode auto -y $output

  # CBR (transcoding with ffmpeg-qsv)
  ffmpeg -hwaccel qsv -qsv_device ${DEVICE:-/dev/dri/renderD128} -c:v $inputcodec -extra_hw_frames $lad -an -i $input \
    -frames:v $numframes -c:v av1_qsv -preset $preset -profile:v main -async_depth 1 \
    -b:v $bitrate -maxrate $bitrate -minrate $bitrate -bufsize $((2 * bitrate)) \
    -rc_init_occupancy $bitrate -low_power ${LOW_POWER:-true} -look_ahead_depth $lad -extbrc 1 \
    -b_strategy 1 -adaptive_i 1 -adaptive_b 1 -bf 7 -g 256 -strict -1 \
    -fps_mode auto -y $output

  # VBR (encoding from YUV with Sample Multi-Transcode)
  sample_multi_transcode -i::i420 $inputyuv -hw -async 1 \
    -device ${DEVICE:-/dev/dri/renderD128} -u $preset -b $bitrateKb -vbr -n $numframes \
    -w $width -h $height -override_encoder_framerate $framerate -lowpower:${LOWPOWER:-on} -lad $lad \
    -extbrc::implicit -AdaptiveI:on -AdaptiveB:on -bref -dist 8 -gop_size 256 \
    -NalHrdConformance:off -VuiNalHrdParameters:off -hrd $((bitrateKb / 2)) \
    -InitialDelayInKB $((bitrateKb / 4)) -MaxKbps $((bitrateKb * 2)) -o::av1 $output

  # CBR (encoding from YUV with Sample Multi-Transcode)
  sample_multi_transcode -i::i420 $inputyuv -hw -async 1 \
    -device ${DEVICE:-/dev/dri/renderD128} -u $preset -b $bitrateKb -cbr -n $numframes \
    -w $width -h $height  -override_encoder_framerate $framerate -lowpower:${LOWPOWER:-on} -lad $lad \
    -extbrc::implicit -AdaptiveI:on -AdaptiveB:on -bref -dist 8 -gop_size 256 \
    -NalHrdConformance:off -VuiNalHrdParameters:off -hrd $((bitrateKb / 4)) \
    -InitialDelayInKB $((bitrateKb / 8)) -o::av1 $output

  # VBR (transcoding from raw bitstream with Sample Multi-Transcode)
  sample_multi_transcode -i::${inputcodec} $input -hw -async 1 \
    -device ${DEVICE:-/dev/dri/renderD128} -u $preset -b $bitrateKb -vbr -n $numframes \
    -lowpower:${LOWPOWER:-on} -lad $lad -extbrc::implicit -AdaptiveI:on -AdaptiveB:on -bref -dist 8 -gop_size 256 \
    -NalHrdConformance:off -VuiNalHrdParameters:off -hrd $((bitrateKb / 2)) \
    -InitialDelayInKB $((bitrateKb / 4)) -MaxKbps $((bitrateKb * 2)) -o::av1 $output

  # CBR (transcoding from raw bitstream with Sample Multi-Transcode)
  sample_multi_transcode -i::${inputcodec} $input -hw -async 1 \
    -device ${DEVICE:-/dev/dri/renderD128} -u $preset -b $bitrateKb -cbr -n $numframes \
    -lowpower:${LOWPOWER:-on} -lad $lad -extbrc::implicit -AdaptiveI:on -AdaptiveB:on -bref -dist 8 -gop_size 256 \
    -NalHrdConformance:off -VuiNalHrdParameters:off -hrd $((bitrateKb / 4)) \
    -InitialDelayInKB $((bitrateKb / 8)) -o::av1 $output

HW BRC
******

To achieve better quality with Intel GPU AV1 encoder running Hardware BRC we recommend the following settings:

+-------------------------------------------------------+----------------+--------------------------------------------------------------------------+
| ffmpeg-qsv options                                    | ffmpeg version | Comments                                                                 |
+=======================================================+================+==========================================================================+
| VBR                                                                                                                                               |
+-------------------------------------------------------+----------------+--------------------------------------------------------------------------+
| ``-b:v $bitrate -maxrate $((2 * bitrate))``           | n6.0           | maxrate > bitrate triggers VBR. You can vary maxrate per your needs.     |
+-------------------------------------------------------+----------------+--------------------------------------------------------------------------+
| ``-bufsize $((4 * bitrate))``                         | n6.0           | You can vary bufsize per your needs. We recommend to avoid going below 1 |
|                                                       |                | second to avoid quality loss. Buffer size of 4 seconds is recommended    |
|                                                       |                | for VBR.                                                                 |
+-------------------------------------------------------+----------------+--------------------------------------------------------------------------+
| ``-rc_init_occupancy $((2 * bitrate))``               | n6.0           | This is initial buffer delay. You can vary this per your needs.          |
|                                                       |                | Recommendation is to use 1/2 of bufsize.                                 |
+-------------------------------------------------------+----------------+--------------------------------------------------------------------------+
| CBR                                                                                                                                               |
+-------------------------------------------------------+----------------+--------------------------------------------------------------------------+
| ``-b:v $bitrate -minrate $bitrate -maxrate $bitrate`` | n6.0           | This triggers CBR.                                                       |
+-------------------------------------------------------+----------------+--------------------------------------------------------------------------+
| ``-bufsize $((2 * bitrate))``                         | n6.0           | You can vary bufsize per your needs. We recommend to avoid going below 1 |
|                                                       |                | second to avoid quality loss. Buffer size of 2 seconds is recommended    |
|                                                       |                | for VBR.                                                                 |
+-------------------------------------------------------+----------------+--------------------------------------------------------------------------+
| ``-rc_init_occupancy $bitrate``                       | n6.0           | This is initial buffer delay. You can vary this per your needs.          |
|                                                       |                | Recommendation is to use 1/2 of bufsize.                                 |
+-------------------------------------------------------+----------------+--------------------------------------------------------------------------+
| CBR & VBR common settings                                                                                                                         |
+-------------------------------------------------------+----------------+--------------------------------------------------------------------------+
| ``-b_strategy 1 -bf 7``                               | n6.0           | These 2 settings activate full 3 level B-Pyramid.                        |
+-------------------------------------------------------+----------------+--------------------------------------------------------------------------+
| ``-g 256``                                            | n6.0           | Select long enough GOP size for random access encoding. You can vary     |
|                                                       |                | this setting. Typically 2 to 4 seconds GOP is used.                      |
+-------------------------------------------------------+----------------+--------------------------------------------------------------------------+

Example command lines:

::

  # VBR (encoding from YUV with ffmpeg-qsv)
  ffmpeg -init_hw_device vaapi=va:${DEVICE:-/dev/dri/renderD128} -init_hw_device qsv=hw@va -an \
    -f rawvideo -pix_fmt yuv420p -s:v ${width}x${height} -r $framerate -i $inputyuv \
    -frames:v $numframes -c:v av1_qsv -preset $preset -profile:v main -async_depth 1 \
    -b:v $bitrate -maxrate $((2 * bitrate)) -bufsize $((4 * bitrate)) \
    -rc_init_occupancy $((2 * bitrate)) -b_strategy 1 -bf 7 -g 256 \
    -fps_mode -1 -y $output

  # CBR (encoding from YUV with ffmpeg-qsv)
  ffmpeg -init_hw_device vaapi=va:${DEVICE:-/dev/dri/renderD128} -init_hw_device qsv=hw@va -an \
    -f rawvideo -pix_fmt yuv420p -s:v ${width}x${height} -r $framerate -i $inputyuv \
    -frames:v $numframes -c:v av1_qsv -preset $preset -profile:v main -async_depth 1 \
    -b:v $bitrate -maxrate $bitrate -minrate $bitrate -bufsize $((2 * bitrate)) \
    -rc_init_occupancy $bitrate -b_strategy 1 -bf 7 -g 256 \
    -fps_mode -1 -y $output

  # VBR (transcoding with ffmpeg-qsv)
  ffmpeg -hwaccel qsv -qsv_device ${DEVICE:-/dev/dri/renderD128} -c:v $inputcodec -an -i $input \
    -frames:v $numframes -c:v av1_qsv -preset $preset -profile:v main -async_depth 1 \
    -b:v $bitrate -maxrate $((2 * bitrate)) -bufsize $((4 * bitrate)) \
    -rc_init_occupancy $((2 * bitrate)) -b_strategy 1 -bf 7 -g 256 \
    -fps_mode -1 -y $output

  # CBR (transcoding with ffmpeg-qsv)
  ffmpeg -hwaccel qsv -qsv_device ${DEVICE:-/dev/dri/renderD128} -c:v $inputcodec -an -i $input \
    -frames:v $numframes -c:v av1_qsv -preset $preset -profile:v main -async_depth 1 \
    -b:v $bitrate -maxrate $bitrate -minrate $bitrate -bufsize $((2 * bitrate)) \
    -rc_init_occupancy $bitrate -b_strategy 1 -bf 7 -g 256 \
    -fps_mode -1 -y $output

  # VBR (encoding from YUV with Sample Multi-Transcode)
  sample_multi_transcode -i::i420 $inputyuv -hw -async 1 -device ${DEVICE:-/dev/dri/renderD128} \
    -u $preset -b $bitrateKb -vbr -n $numframes -w $width -h $height -override_encoder_framerate $framerate \
    -bref -dist 8 -gop_size 256 -hrd $((bitrateKb / 2)) -InitialDelayInKB $((bitrateKb / 4)) \
    -MaxKbps $((bitrateKb * 2)) -o::av1 $output

  # CBR (encoding from YUV with Sample Multi-Transcode)
  sample_multi_transcode -i::i420 $inputyuv -hw -async 1 -device ${DEVICE:-/dev/dri/renderD128} \
    -u $preset -b $bitrateKb -cbr -n $numframes -w $width -h $height -override_encoder_framerate $framerate \
    -bref -dist 8 -gop_size 256 -hrd $((bitrateKb / 4)) -InitialDelayInKB $((bitrateKb / 8)) \
    -o::av1 $output

  # VBR (transcoding from raw bitstream with Sample Multi-Transcode)
  sample_multi_transcode -i::$inputcodec $input -hw -async 1 \
    -device ${DEVICE:-/dev/dri/renderD128} -u $preset -b $bitrateKb \
    -vbr -n $numframes -bref -dist 8 -gop_size 256 -dist 8 -hrd $((bitrateKb / 2)) \
    -InitialDelayInKB $((bitrateKb / 4)) -MaxKbps $((bitrateKb * 2)) -o::av1 $output

  # CBR (transcoding from raw bitstream with Sample Multi-Transcode)
  sample_multi_transcode -i::$inputcodec $input -hw -async 1 \
    -device ${DEVICE:-/dev/dri/renderD128} -u $preset -b $bitrateKb \
    -cbr -n $numframes -bref -dist 8 -gop_size 256 -hrd $((bitrateKb / 4)) \
    -InitialDelayInKB $((bitrateKb / 8)) -o::av1 $output

   
Reference Codecs
----------------

For assessing the quality of Intel's H.264 Advanced Video Coding (AVC) and H.265 High Efficiency Video Coding (HEVC)
codecs we are using ffmpeg-x264 and ffmpeg-x265 as reference codecs in ``medium`` preset for the BD-rate measure. For
assessing the quality of Intel's AV1 codec we are using ffmpeg-x264 as a reference codec in ``medium`` preset for its
BD-rate measure. The reference codecs use 12 threads and ``-tune psnr`` option.

ffmpeg-x264
***********
::

  # VBR (encoding from YUV)
  ffmpeg -f rawvideo -pix_fmt yuv420p -s:v ${width}x${height} -r $framerate \
    -i $inputyuv -vframes $numframes -y \
    -c:v libx264 -preset medium -profile:v high \
    -b:v $bitrate -bufsize $((2 * bitrate)) -maxrate $((2 * bitrate)) \
    -tune psnr -threads 12 -fps_mode -1 $output

  # CBR (encoding from YUV)
  ffmpeg -f rawvideo -pix_fmt yuv420p -s:v ${width}x${height} -r $framerate \
    -i $inputyuv -vframes $numframes -y \
    -c:v libx264 -preset medium -profile:v high \
    -b:v $bitrate -x264opts no-sliced-threads:nal-hrd=cbr \
    -tune psnr -threads 12 -fps_mode -1 $output

ffmpeg-x265
***********

::

  # VBR (encoding from YUV)
  ffmpeg -f rawvideo -pix_fmt yuv420p -s:v ${width}x${height} -r $framerate \
    -i $inputyuv -vframes $numframes -y \
    -c:v libx265 -preset medium \
    -b:v $bitrate -maxrate $((2 * bitrate)) -bufsize $((2 * bitrate)) \
    -tune psnr -threads 12 -fps_mode -1 $output

  # CBR (encoding from YUV)
  ffmpeg -f rawvideo -pix_fmt yuv420p -s:v ${width}x${height} -r $framerate \
    -i $inputyuv -vframes $numframes -y \
    -c:v libx265 -preset medium \
    -b:v $bitrate -maxrate $bitrate -minrate $bitrate -bufsize $((2 * bitrate)) \
    -tune psnr -threads 12 -fps_mode -1 $output

Links
-----

* `ffmpeg-qsv <https://trac.ffmpeg.org/wiki/Hardware/QuickSync>`_
* `Intel Media SDK Sample Multi-Transcode <https://github.com/Intel-Media-SDK/MediaSDK/blob/master/doc/samples/readme-multi-transcode_linux.md>`_


**Extra notes:**

We cannot use `-fps_mode passthrough` combined with a fixed frame rate via `-r`. That will fail as shown:

Error reported by ffmpeg will be: 
`sh
One of -r/-fpsmax was specified together a non-CFR -vsync/-fps_mode. This is contradictory.
```
To correct this, either:

1. Either set  `-fps_mode` to either `auto` or `cfr` or omit the option entirely when `-r` is set/configured;
2. Drop the `-r` option entirely and set the output framerate via ffmpeg's `fps` filter (not recommended for QSV and VAAPI) or via `vpp_qsv`'s `fps` argument (recommended) if `-fps_mode passthrough` has to be configured/set.

For now, I'll update the documentation with  `-fps_mode auto` toggled on so that the existing command-lines don't break.




.. |na| raw:: html

   &#x2205;

.. |check| raw:: html

   &#x2713;

.. |cross| raw:: html

   &#x2717;

