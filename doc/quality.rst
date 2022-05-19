Video Quality
=============

.. contents::

Video Quality Assessment Methodology
------------------------------------

In this document we describe the methodology which is used to measure video quality of Intel® Media SDK 
`Sample Multi-Transcode <https://github.com/Intel-Media-SDK/MediaSDK/blob/master/doc/samples/readme-multi-transcode_linux.md>`_ and
`ffmpeg-qsv <https://trac.ffmpeg.org/wiki/Hardware/QuickSync>`_ (Intel® Media SDK integration into FFmpeg) codecs.
A `video quality measuring tool <man/measure-quality.asciidoc>`_ which implements this methodology is provided as 
a part of Media Delivery Software Stack. In addition, a `performance measuring tool <man/measure-perf.asciidoc>`_ is 
provided for allowing users to evaluate performance (see `performance methodology <performance.rst>`_ documentation).

Peak signal-to-noise ratio (PSNR) is the most widely used objective image quality metric. We use arithmetic average PSNR of the luminance 
frames (PSNR-Y) as the basic quality assessment metric. Since PSNR fails to capture certain perceptual quality traits, we also make use of 
the following additional quality metrics: SSIM, MS-SSIM, and VMAF.

We evaluate quality on the following streams:

* 1080p 8-bit YUV 4:2:0

+-----------------+------------+-----+------------------------------------+
| Sequence        | Resolution | FPS | Source                             |
+=================+============+=====+====================================+
| BasketBallDrive | 1920x1080  | 50  | MPEG Test Suite                    |
+-----------------+------------+-----+------------------------------------+
| BQTerrace       | 1920x1080  | 60  | MPEG Test Suite                    |
+-----------------+------------+-----+------------------------------------+
| Cactus          | 1920x1080  | 50  | MPEG Test Suite                    |
+-----------------+------------+-----+------------------------------------+
| CrowdRun        | 1920x1080  | 50  | https://media.xiph.org/video/derf/ |
+-----------------+------------+-----+------------------------------------+
| DinnerScene     | 1920x1080  | 60  | https://media.xiph.org/video/derf/ |
+-----------------+------------+-----+------------------------------------+
| Kimono          | 1920x1080  | 24  | MPEG Test Suite                    |
+-----------------+------------+-----+------------------------------------+
| ParkJoy         | 1920x1080  | 50  | https://media.xiph.org/video/derf/ |
+-----------------+------------+-----+------------------------------------+
| RedKayak        | 1920x1080  | 30  | https://media.xiph.org/video/derf/ |
+-----------------+------------+-----+------------------------------------+
| RushFieldCuts   | 1920x1080  | 30  | https://media.xiph.org/video/derf/ |
+-----------------+------------+-----+------------------------------------+

* 720p 8-bit YUV 4:2:0

+---------------+------------+-----+------------------------------------+
| Sequence      | Resolution | FPS | Source                             |
+===============+============+=====+====================================+
| Boat          | 1280x720   | 60  | https://media.xiph.org/video/derf/ |
+---------------+------------+-----+------------------------------------+
| CrowdRun      | 1280x720   | 50  | https://media.xiph.org/video/derf/ |
+---------------+------------+-----+------------------------------------+
| FoodMarket    | 1280x720   | 60  | https://media.xiph.org/video/derf/ |
+---------------+------------+-----+------------------------------------+
| Kimono        | 1280x720   | 24  | MPEG Test Suite                    |
+---------------+------------+-----+------------------------------------+
| ParkJoy       | 1280x720   | 50  | https://media.xiph.org/video/derf/ |
+---------------+------------+-----+------------------------------------+
| ParkScene     | 1280x720   | 24  | MPEG Test Suite                    |
+---------------+------------+-----+------------------------------------+
| PierSeaSide   | 1280x720   | 60  | https://media.xiph.org/video/derf/ |
+---------------+------------+-----+------------------------------------+
| Tango         | 1280x720   | 60  | https://media.xiph.org/video/derf/ |
+---------------+------------+-----+------------------------------------+
| TouchDownPass | 1280x720   | 30  | MPEG Test Suite                    |
+---------------+------------+-----+------------------------------------+

* Synthetic/Animation Test Content 1080p 8-bit YUV 4:2:0

+----------------------+------------+-----+------------------------------------+
| Sequence             | Resolution | FPS | Source                             |
+======================+============+=====+====================================+
| Bunny                | 1920x1080  | 24  | https://media.xiph.org/video/derf/ |
+----------------------+------------+-----+------------------------------------+
| CSGO                 | 1920x1080  | 60  | https://media.xiph.org/video/derf/ |
+----------------------+------------+-----+------------------------------------+
| DOTA2                | 1920x1080  | 60  | https://media.xiph.org/video/derf/ |
+----------------------+------------+-----+------------------------------------+
| GTAV                 | 1920x1080  | 60  | https://media.xiph.org/video/derf/ |
+----------------------+------------+-----+------------------------------------+
| Hearthstone          | 1920x1080  | 60  | https://media.xiph.org/video/derf/ |
+----------------------+------------+-----+------------------------------------+
| Minecraft            | 1920x1080  | 60  | https://media.xiph.org/video/derf/ |
+----------------------+------------+-----+------------------------------------+
| MrFox_BlueBird       | 1920x1080  | 30  | VQEG Test Suite                    |
+----------------------+------------+-----+------------------------------------+
| Sintel_offset537n480 | 1920x1080  | 24  | https://media.xiph.org/video/derf/ |
+----------------------+------------+-----+------------------------------------+
| Witcher              | 1920x1080  | 60  | https://media.xiph.org/video/derf/ |
+----------------------+------------+-----+------------------------------------+

To compare quality with different codecs and/or coding options, we compute the Bjøntegaard-Delta bitrate (BD-rate) measure, in which 
negative values indicate how much the bitrate is reduced, and positive values indicate how much the bitrate is increased for the same PSNR-Y. 
Minimum of 4 distinct points are needed for a successful BD-rate measure, so minimum of 4 distinct bitrates need to be used for each sequence 
being tested. We resort to measuring quality using 5 target bitrates in order to capture a variety of modern encoding scenarios. However, 
instead of using a single 5-point BD-rate measure, we use an average of two 4-point BD-rate measures instead, where the lowest 4 of 5 points 
are used as the low bitrates BD-rate measure and the highest 4 of 5 points are used as the high bitrates BD-rate measure. The following tables 
show specific target bitrates which we are using with H.264/AVC and H.265/HEVC video coding standards. 

Target bitrates for H.264/AVC video quality assessment:

+------------+---------------+-----------------+
| Resolution | Setting       | Bitrates (Mb/s) |
+============+===============+=================+
| 4K         | Low           | 6, 9, 15, 24    |
|            +---------------+-----------------+
|            | High          | 9, 15, 24, 40   |
+------------+---------------+-----------------+
| 1080p      | Low           | 2, 3, 6, 12     |
|            +---------------+-----------------+
|            | High          | 3, 6, 12, 24    |
+------------+---------------+-----------------+
| 720p       | Low           | 1, 1.5, 3, 6    |
|            +---------------+-----------------+
|            | High          | 1.5, 3, 6, 12   |
+------------+---------------+-----------------+

Bitrates in the able above are used for all content except some streams with exceptional complexity:

+------------------------+---------+-----------------+
| Stream                 | Setting | Bitrates (MB/s) |
+========================+=========+=================+
| CrowdRun, 1920x1080    | Low     | 15, 20, 25, 30  |
|                        +---------+-----------------+
| ParkJoy, 1920x1080     | High    | 20, 25, 30, 35  |
+------------------------+---------+-----------------+
| DinnerScene, 1920x1080 | Low     | 1, 1.5, 2, 3    |
|                        +---------+-----------------+
|                        | High    | 1.5, 2, 3, 4    |
+------------------------+---------+-----------------+
| Sintel_offset537n480   | Low     | 0.5, 1, 2, 6    |
|                        +---------+-----------------+
|                        | High    | 1, 2, 6, 9      |
+------------------------+---------+-----------------+
| CrowdRun, 1280x720     | Low     | 6, 8, 10, 12    |
|                        +---------+-----------------+
| ParkJoy, 1280x720      | High    | 8, 10, 12, 15   |
+------------------------+---------+-----------------+


Target bitrates for H.265/HEVC video quality assessment:

+------------+---------------+-----------------+
| Resolution | Setting       | Bitrates (Mb/s) |
+============+===============+=================+
| 4K         | Low           | 6, 9, 15, 24    |
|            +---------------+-----------------+
|            | High          | 9, 15, 24, 40   |
+------------+---------------+-----------------+
| 1080p      | Low           | 2, 3, 6, 9      |
|            +---------------+-----------------+
|            | High          | 3, 6, 9, 15     |
+------------+---------------+-----------------+
| 720p       | Low           | 1, 1.5, 3, 4.5  |
|            +---------------+-----------------+
|            | High          | 1.5, 3, 4.5, 7.5|
+------------+---------------+-----------------+

Bitrates in the able above are used for all content except some streams with exceptional complexity:

+------------------------+---------+-----------------+
| Stream                 | Setting | Bitrates (MB/s) |
+========================+=========+=================+
| CrowdRun, 1920x1080    | Low     | 15, 20, 25, 30  |
|                        +---------+-----------------+
| ParkJoy, 1920x1080     | High    | 20, 25, 30, 35  |
+------------------------+---------+-----------------+
| DinnerScene, 1920x1080 | Low     | 3, 7, 11, 15    |
|                        +---------+-----------------+
|                        | High    | 7, 11, 15, 20   |
+------------------------+---------+-----------------+
| Sintel_offset537n480   | Low     | 0.5, 1, 2, 6    |
|                        +---------+-----------------+
|                        | High    | 1, 2, 6, 9      |
+------------------------+---------+-----------------+
| CrowdRun, 1280x720     | Low     | 6, 8, 10, 12    |
|                        +---------+-----------------+
| ParkJoy, 1280x720      | High    | 8, 10, 12, 15   |
+------------------------+---------+-----------------+

In addition, we measure 2 encoding modes: variable bitrate (VBR) and, constant bitrate (CBR) modes. 
The BD-rate for a video sequence encoded with a given encoder is computed by averaging the following 4 
individual BD-rates: 

1. CBR low bitrates BD-rate
2. CBR high bitrates BD-rate
3. VBR low bitrates BD-rate
4. VBR high bitrates BD-rate.

In the following sections you can find command lines used for high quality H.264/AVC and H.265/HEVC video 
coding with Intel® Media SDK `Sample Multi-Transcode <https://github.com/Intel-Media-SDK/MediaSDK/blob/master/doc/samples/readme-multi-transcode_linux.md>`_
and `ffmpeg-qsv <https://trac.ffmpeg.org/wiki/Hardware/QuickSync>`_ (Intel® Media SDK integration into FFmpeg).

Video Quality Measuring Tool
----------------------------
A `video quality measuring tool <man/measure-quality.asciidoc>`_ is provided as a part of Media Delivery Software Stack.
The tool allows users to measure video quality for themselves in a manner described in this document for either 
a predefined set of video sequences, or a video sequences of their choosing.  The input can be a raw YUV 4:2:0 8-bit file, 
or any video encoded bitstream (raw or within a container) supported by ffmpeg.

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

Next we present quality command lines for H.264/AVC and H.265/HEVC. To maximize quality over performance, use "veryslow" preset. For maximum
performance set preset to "veryfast". For a balanced quality/performance tradeoff use "medium" preset.

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

  # triggers EncTools:
  ffmpeg <...> -g 256 -bf 7 -extbrc 1 -look_ahead_depth 40 <...>

  # triggers ExtBRC:
  ffmpeg <...> -g 256 -bf 7 -extbrc 1 -look_ahead_depth 0 <...>

Below table summarizes which tools are available in EncTools and ExtBRC SW BRCs.

+-------------------------------------------------------+---------+----------+
| Feature                                               | ExtBRC  | EncTools |
+=======================================================+=========+==========+
| Adaptive Long Term Reference (ALTR)                   | |check| | |check|  |
+-------------------------------------------------------+---------+----------+
| Scene Change Detection (SCD/Adaptive I)               | |check| | |check|  |
+-------------------------------------------------------+---------+----------+
| Adaptive Motion Compensation Temporal Filter (AMCTF)* | |check| | |check|  |
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

\* - AMCTF is VME based and is available up to (and including) DG1.

EncTools and ExtBRC are not supported for all the codecs and platforms - see support matrix below.
Mind that HW BRC for VDENC encoders requires HuC which is not enabled by default in Linux kernel
on some platforms. First platform which enables HuC by default is DG1 (TGL does not has HuC
enabled by default).

+------------+----------+----------+---------+-----------+-------------+------------+------------+
| Encoder    | BRC Type | DG2/ATSM | DG1     | TGL       | Gen11 (ICL) | Gen9 (SKL) | Gen8 (BDW) |
+============+==========+==========+=========+===========+=============+============+============+
| AVC VME    | ExtBRC   | |na|     | |check| | |check|   | |check|     | |check|    | |check|    |
+            +----------+          +---------+-----------+-------------+------------+------------+
|            | EncTools |          | |check| | |cross|   | |cross|     | |cross|    | |cross|    |
+            +----------+          +---------+-----------+-------------+------------+------------+
|            | HW BRC   |          | |check| | |check|   | |check|     | |check|    | |check|    |
+------------+----------+----------+---------+-----------+-------------+------------+------------+
| HEVC VME   | ExtBRC   | |na|     | |check| | |check|   | |check|     | |check|    | |na|       |
+            +----------+          +---------+-----------+-------------+------------+            +
|            | EncTools |          | |check| | |cross|   | |cross|     | |cross|    |            |
+            +----------+          +---------+-----------+-------------+------------+            +
|            | HW BRC   |          | |check| | |check|   | |check|     | |check|    |            |
+------------+----------+----------+---------+-----------+-------------+------------+------------+
| AVC VDENC  | ExtBRC   | |check|  | |check| | |check|   | |check|     | |check|    | |na|       |
+            +----------+----------+---------+-----------+-------------+------------+            +
|            | EncTools | |check|  | |check| | |cross|   | |cross|     | |cross|    |            |
+            +----------+----------+---------+-----------+-------------+------------+            +
|            | HW BRC   | |check|  | |check| | |cross| * | |cross| *   | |cross| *  |            |
+------------+----------+----------+---------+-----------+-------------+------------+------------+
| HEVC VDENC | ExtBRC   | |check|  | |check| | |check|   | |check|     | |na|                    |
+            +----------+----------+---------+-----------+-------------+                         +
|            | EncTools | |check|  | |check| | |cross|   | |cross|     |                         |
+            +----------+----------+---------+-----------+-------------+                         +
|            | HW BRC   | |check|  | |check| | |cross| * | |cross| *   |                         |
+------------+----------+----------+---------+-----------+-------------+------------+------------+
| AV1        | ExtBRC   | |cross|  | |na|                                                        |
+            +----------+----------+                                                             +
|            | EncTools | |cross|  |                                                             |
+            +----------+----------+                                                             +
|            | HW BRC   | |check|  |                                                             |
+------------+----------+----------+---------+-----------+-------------+------------+------------+

\* - requires enabled HuC (which is not a default in vanilla Linux kernel)

H.264/AVC
---------

EncTools
********

::

  # VBR (encoding from YUV)
  ffmpeg -init_hw_device ${DEVICE:-/dev/dri/renderD128} -init_hw_device qsv=hw@va -an\
    -f rawvideo -pix_fmt yuv420p -s:v ${width}x${height} -r $framerate -i $inputyuv \
    -frames:v $numframes -c:v h264_qsv -preset $preset -profile:v high -b:v $bitrate \
    -maxrate $((2 * $bitrate)) -bitrate_limit 0 -bufsize $((4 * $bitrate)) \
    -rc_init_occupancy $((2 * $bitrate)) -low_power true -look_ahead_depth 40 -extbrc 1 \
    -b_strategy 1 -adaptive_i 1 -adaptive_b 1 -bf 7 -refs 5 -g 256 -strict -1 \
    -async_depth 1 -vsync 0 -y $output

  # CBR (encoding from YUV)
  ffmpeg -init_hw_device ${DEVICE:-/dev/dri/renderD128} -init_hw_device qsv=hw@va -an \
    -f rawvideo -pix_fmt yuv420p -s:v ${width}x${height} -r $framerate -i $inputyuv \
    -frames:v $numframes -c:v h264_qsv -preset $preset -profile:v high -b:v $bitrate \
    -maxrate $bitrate -minrate $bitrate -bitrate_limit 0 -bufsize $((2 * $bitrate)) \
    -rc_init_occupancy $bitrate -low_power true -look_ahead_depth 40 -extbrc 1 \
    -b_strategy 1 -adaptive_i 1 -adaptive_b 1 -bf 7 -refs 5 -g 256 -strict -1 \
    -async_depth 1 -vsync 0 -y $output

  # VBR (encoding from YUV)
  sample_multi_transcode -i::i420 $inputyuv -hw -async 1
    -device ${DEVICE:-/dev/dri/renderD128} -u $preset -b $bitrateKb -vbr -n $numframes \
    -w $width -h $height -override_encoder_framerate $framerate -lowpower:on -lad 40 \
    -AdaptiveI:on -AdaptiveB:on -extbrc::implicit -num_ref 5 -gop_size 256 -dist 8 \
    -NalHrdConformance:off -VuiNalHrdParameters:off -hrd $(($bitrateKb / 2)) \
    -InitialDelayInKB $(($bitrateKb / 4)) -o::h264 $output

  # CBR (encoding from YUV)
  sample_multi_transcode -i::i420 $inputyuv -hw -async 1
    -device ${DEVICE:-/dev/dri/renderD128} -u $preset -b $bitrateKb -cbr -n $numframes \
    -w $width -h $height  -override_encoder_framerate $framerate -lowpower:on -lad 40 \
    -AdaptiveI:on -AdaptiveB:on -extbrc::implicit -num_ref 5 -gop_size 256 -dist 8 \
    -NalHrdConformance:off -VuiNalHrdParameters:off -hrd $(($bitrateKb / 4)) \
    -InitialDelayInKB $(($bitrateKb / 8)) -o::h264 $output

ExtBRC
******

::

  # VBR (encoding from YUV)
  ffmpeg -hwaccel qsv \
    -f rawvideo -pix_fmt yuv420p -s:v ${width}x${height} -r $framerate \
    -i $inputyuv -vframes $numframes -y \
    -c:v h264_qsv -preset $preset -profile:v high \
    -b:v $bitrate -maxrate $((2 * $bitrate)) -bufsize $((4 * $bitrate)) \
    -g 256 -extbrc 1 -b_strategy 1 -bf 7 -refs 5 -vsync 0 $output

  # CBR (encoding from YUV)
  ffmpeg -hwaccel qsv \
    -f rawvideo -pix_fmt yuv420p -s:v ${width}x${height} -r $framerate \
    -i $inputyuv -vframes $numframes -y \
    -c:v h264_qsv -preset $preset -profile:v high \
    -b:v $bitrate -maxrate $bitrate -minrate $bitrate -bufsize $((2 * $bitrate)) \
    -g 256 -extbrc 1 -b_strategy 1 -bf 7 -refs 5 -vsync 0 $output

  # VBR (transcoding)
  ffmpeg -hwaccel qsv \
    -i $input -c:v $inputcodec -vframes $numframes -y \
    -c:v h264_qsv -preset $preset -profile:v high \
    -b:v $bitrate -maxrate $((2 * $bitrate)) -bufsize $((4 * $bitrate)) \
    -g 256 -extbrc 1 -b_strategy 1 -bf 7 -refs 5 -vsync 0 $output

  # CBR (transcoding)
  ffmpeg -hwaccel qsv \
    -i $input -c:v $inputcodec -vframes $numframes -y \
    -c:v h264_qsv -preset $preset -profile:v high \
    -b:v $bitrate -maxrate $bitrate -minrate $bitrate -bufsize $((2 * $bitrate)) \
    -g 256 -extbrc 1 -b_strategy 1 -bf 7 -refs 5 -vsync 0 $output

  # VBR (encoding from YUV)
  sample_multi_transcode -i::i420 $inputyuv -hw -async 1 -device ${DEVICE:-/dev/dri/renderD128} \
    -u $preset -b $bitrateKb -w $width -h $height -n $numframes -override_encoder_framerate $framerate \
    -vbr -extbrc::implicit -num_ref 5 -dist 8 -gop_size 256 \
    -NalHrdConformance:off -VuiNalHrdParameters:off -MemType::system -hrd $(($bitrateKb / 2)) -InitialDelayInKB $(($bitrateKb / 4))  \
    -o::h264 $output

  # CBR (encoding from YUV)
  sample_multi_transcode -i::i420 $inputyuv -hw -async 1 -device ${DEVICE:-/dev/dri/renderD128} \
    -u $preset -b $bitrateKb -w $width -h $height -n $numframes -override_encoder_framerate $framerate \
    -cbr -extbrc::implicit -num_ref 5 -dist 8 -gop_size 256 \
    -NalHrdConformance:off -VuiNalHrdParameters:off -MemType::system -hrd $(($bitrateKb / 4)) -InitialDelayInKB $(($bitrateKb / 8)) \
    -o::h264 $output

H.265/HEVC
----------

EncTools
********

::

  # VBR (encoding from YUV)
  ffmpeg -init_hw_device ${DEVICE:-/dev/dri/renderD128} -init_hw_device qsv=hw@va -an \
    -f rawvideo -pix_fmt yuv420p -s:v ${width}x${height} -r $framerate -i $inputyuv \
    -frames:v $numframes -c:v hevc_qsv -preset $preset -profile:v main -b:v $bitrate \
    -maxrate $((2 * $bitrate)) -bitrate_limit 0 -bufsize $((4 * $bitrate)) \
    -rc_init_occupancy $((2 * $bitrate)) -low_power true -look_ahead_depth 40 -extbrc 1 -b_strategy 1 \
    -adaptive_i 1 -adaptive_b 1 -bf 7 -refs 4 -g 256 -idr_interval begin_only -strict -1 \
    -async_depth 1 -vsync 0 -y $output

  # CBR (encoding from YUV)
  ffmpeg -init_hw_device ${DEVICE:-/dev/dri/renderD128} -init_hw_device qsv=hw@va -an \
    -f rawvideo -pix_fmt yuv420p -s:v ${width}x${height} -r $framerate -i $inputyuv \
    -frames:v $numframes -c:v hevc_qsv -preset $preset -profile:v main -b:v $bitrate \
    -maxrate $bitrate -minrate $bitrate -bitrate_limit 0 -bufsize $((2 * $bitrate)) \
    -rc_init_occupancy $bitrate -low_power true -look_ahead_depth 40 -extbrc 1 -b_strategy 1 \
    -adaptive_i 1 -adaptive_b 1 -bf 7 -refs 4 -g 256 -idr_interval begin_only -strict -1 \
    -async_depth 1 -vsync 0 -y $output

  # VBR (encoding from YUV)
  sample_multi_transcode -i::i420 $inputyuv -hw -async 1 -device ${DEVICE:-/dev/dri/renderD128} \
    -u $preset -b $bitrateKb -vbr -n $numframes -w $width -h $height  -override_encoder_framerate $framerate \
    -lowpower:on -lad 40 -AdaptiveI:on -AdaptiveB:on -extbrc::implicit -num_ref 4 -gop_size 256 -dist 8 \
    -NalHrdConformance:off -VuiNalHrdParameters:off -hrd $(($bitrateKb / 2)) -InitialDelayInKB $(($bitrateKb / 4))  \
    -o::h265 $output

  # CBR (encoding from YUV)
  sample_multi_transcode -i::i420 $inputyuv -hw -async 1 -device ${DEVICE:-/dev/dri/renderD128} \
    -u $preset -b $bitrateKb -cbr -n $numframes -w $width -h $height  -override_encoder_framerate $framerate \
    -lowpower:on -lad 40 -AdaptiveI:on -AdaptiveB:on -extbrc::implicit -num_ref 4 -gop_size 256 -dist 8  \
    -NalHrdConformance:off -VuiNalHrdParameters:off -hrd $(($bitrateKb / 4)) -InitialDelayInKB $(($bitrateKb / 8))  \
    -o::h265 $output

ExtBRC
******

::

  # VBR (encoding from YUV)
  ffmpeg -hwaccel qsv \
    -f rawvideo -pix_fmt yuv420p -s:v ${width}x${height} -r $framerate \
    -i $inputyuv -vframes $numframes -y \
    -c:v hevc_qsv -preset medium -profile:v main \
    -b:v $bitrate -maxrate $((2 * $bitrate)) -bufsize $((4 * $bitrate)) \
    -g 256 -extbrc 1 -refs 5 -bf 7 -vsync 0 $output

  # CBR (encoding from YUV)
  ffmpeg -hwaccel qsv \
    -f rawvideo -pix_fmt yuv420p -s:v ${width}x${height} -r $framerate \
    -i $inputyuv -vframes $numframes -y \
    -c:v hevc_qsv -preset medium -profile:v main \
    -b:v $bitrate -maxrate $bitrate -minrate $bitrate -bufsize $((2 * $bitrate)) \
    -g 256 -extbrc 1 -refs 5 -bf 7 -vsync 0 $output

  # VBR (transcoding)
  ffmpeg -hwaccel qsv \
    -i $input -c:v $inputcodec -vframes $numframes -y \
    -c:v hevc_qsv -preset medium -profile:v main \
    -b:v $bitrate -maxrate $((2 * $bitrate)) -bufsize $((4 * $bitrate)) \
    -g 256 -extbrc 1 -refs 5 -bf 7 -vsync 0 $output

  # CBR (transcoding)
  ffmpeg -hwaccel qsv \
    -i $input -c:v $inputcodec -vframes $numframes -y \
    -c:v hevc_qsv -preset medium -profile:v main \
    -b:v $bitrate -maxrate $bitrate -minrate $bitrate -bufsize $((2 * $bitrate)) \
    -g 256 -extbrc 1 -refs 5 -bf 7 -vsync 0 $output

  # VBR (encoding from YUV)
  sample_multi_transcode -i::i420 $inputyuv -hw -async 1 -device ${DEVICE:-/dev/dri/renderD128} \
    -u $preset -b $bitrateKb -w $width -h $height -n $numframes -override_encoder_framerate $framerate \
    -vbr -extbrc::implicit -num_ref 4 -dist 8 -gop_size 256 -NalHrdConformance:off \
    -VuiNalHrdParameters:off -hrd $(($bitrateKb / 2)) -InitialDelayInKB $(($bitrateKb / 4)) \
    -o::h265 $output

  # CBR (encoding from YUV)
  sample_multi_transcode -i::i420 $inputyuv -hw -async 1 -device ${DEVICE:-/dev/dri/renderD128} \
    -u $preset -b $bitrateKb -w $width -h $height -n $numframes -override_encoder_framerate $framerate \
    -cbr -extbrc::implicit -num_ref 4 -dist 8 -gop_size 256 -NalHrdConformance:off \
    -VuiNalHrdParameters:off -hrd $(($bitrateKb / 4)) -InitialDelayInKB $(($bitrateKb / 8)) \
    -o::h265 $output

  # VBR (transcoding)
  sample_multi_transcode -i::$inputcodec $input -hw -async 1 \
    -device ${DEVICE:-/dev/dri/renderD128} -u $preset -b $bitrateKb \
    -vbr -lad 40 -AdaptiveI:on -AdaptiveB:off -extbrc::implicit -num_ref 4 -gop_size 256 -dist 8 \
    -NalHrdConformance:off -VuiNalHrdParameters:off -hrd $(($bitrateKb / 2)) -InitialDelayInKB $(($bitrateKb / 4)) \
    -o::h265 $output

  # CBR (transcoding)
  sample_multi_transcode -i::$inputcodec $input -hw -async 1 \
    -device ${DEVICE:-/dev/dri/renderD128} -u $preset -b $bitrateKb \
    -cbr -lad 40 -AdaptiveI:on -AdaptiveB:off -extbrc::implicit -num_ref 4 -gop_size 256 -dist 8 \
    -NalHrdConformance:off -VuiNalHrdParameters:off -hrd $(($bitrateKb / 4)) -InitialDelayInKB $(($bitrateKb / 8)) \
    -o::h265 $output

AV1
---

::

  # VBR (encoding from YUV)
  ffmpeg -init_hw_device ${DEVICE:-/dev/dri/renderD128} -init_hw_device qsv=hw@va \
   -an -f rawvideo -pix_fmt yuv420p -s:v ${width}x${height} -r $framerate \
   -i $inputyuv -frames:v $numframes -c:v av1_qsv -preset medium -profile:v main \
   -b:v $bitrate -maxrate $((2 * $bitrate)) -bitrate_limit 0 -bufsize $((4 * $bitrate)) \
   -rc_init_occupancy $(($bufsize / 2)) -low_power true -b_strategy 1 -bf 7 -refs 3 -g 256 -vsync 0 -y $output

  # CBR (encoding from YUV)
  ffmpeg -init_hw_device ${DEVICE:-/dev/dri/renderD128} -init_hw_device qsv=hw@va \
   -an -f rawvideo -pix_fmt yuv420p -s:v ${width}x${height} -r $framerate \
   -i $inputyuv -frames:v $numframes -c:v av1_qsv -preset medium -profile:v main \
   -b:v $bitrate -maxrate $bitrate -minrate $bitrate -bitrate_limit 0 -bufsize $((2 * $bitrate)) \
   -rc_init_occupancy $(($bufsize / 2)) -low_power true -b_strategy 1 -bf 7 -refs 3 -g 256 -vsync 0 -y $output

  # VBR (transcoding)
  ffmpeg -hwaccel qsv \
    -i $input -c:v $inputcodec -vframes $numframes -y \
    -c:v av1_qsv -preset medium -profile:v main \
    -b:v $bitrate -maxrate $((2 * $bitrate)) -bufsize $((4 * $bitrate)) \
    -g 256 -refs 5 -bf 7 -vsync 0 $output

  # CBR (transcoding)
  ffmpeg -hwaccel qsv \
    -i $input -c:v $inputcodec -vframes $numframes -y \
    -c:v av1_qsv -preset medium -profile:v main \
    -b:v $bitrate -maxrate $bitrate -minrate $bitrate -bufsize $((2 * $bitrate)) \
    -g 256 -refs 5 -bf 7 -vsync 0 $output

  # VBR (encoding from YUV)
  sample_multi_transcode -i::i420 $inputyuv -hw -async 1 -device ${DEVICE:-/dev/dri/renderD128} \
    -u $preset -b $bitrateKb -vbr -n $numframes -w $width -h $height -override_encoder_framerate $framerate \
    -lowpower:on -num_ref 3 -gop_size 256 -dist 8 -MemType::system -bref -hrd 250 -InitialDelayInKB $(($bitrateKb / 4)) \
    -o::av1 $output

  # CBR (encoding from YUV)
  sample_multi_transcode -i::i420 $inputyuv -hw -async 1 -device ${DEVICE:-/dev/dri/renderD128} \
   -u $preset -b $bitrateKb -cbr -n $numframes -w $width -h $height -override_encoder_framerate $framerate \
   -lowpower:on -num_ref 3 -gop_size 256 -dist 8 -MemType::system -bref -hrd 250 -InitialDelayInKB $(($bitrateKb / 8)) \
   -o::av1 $output

  # VBR (transcoding)
  sample_multi_transcode -i::$inputcodec $input -hw -async 1 \
    -device ${DEVICE:-/dev/dri/renderD128} -u $preset -b $bitrateKb \
    -vbr -lad 40 -AdaptiveI:on -AdaptiveB:off -extbrc::implicit -num_ref 4 -gop_size 256 -dist 8 \
    -NalHrdConformance:off -VuiNalHrdParameters:off -hrd $(($bitrateKb / 2)) -InitialDelayInKB $(($bitrateKb / 4)) \
    -o::av1 $output

  # CBR (transcoding)
  sample_multi_transcode -i::$inputcodec $input -hw -async 1 \
    -device ${DEVICE:-/dev/dri/renderD128} -u $preset -b $bitrateKb \
    -cbr -lad 40 -AdaptiveI:on -AdaptiveB:off -extbrc::implicit -num_ref 4 -gop_size 256 -dist 8 \
    -NalHrdConformance:off -VuiNalHrdParameters:off -hrd $(($bitrateKb / 4)) -InitialDelayInKB $(($bitrateKb / 8)) \
    -o::av1 $output
   
Reference Codecs
----------------

For assessing the quality of Intel's H.264 Advanced Video Coding (AVC) and H.265 High Efficiency Video Coding (HEVC) codecs we are
using ffmpeg-x264 and ffmpeg-x265 as reference codecs in ``veryslow`` preset for the BD-rate measure. For assessing the quality of
Intel's AV1 codec we are using ffmpeg-x265 as reference codec in ``veryslow`` preset for the BD-rate measure. The reference codecs
are ran with 12 threads and ``-tune psnr`` option.

ffmpeg-x264
***********
::

  # VBR (encoding from YUV)
  ffmpeg -f rawvideo -pix_fmt yuv420p -s:v ${width}x${height} -r $framerate \
    -i $inputyuv -vframes $numframes -y \
    -c:v libx264 -preset veryslow -profile:v high \
    -b:v $bitrate -bufsize $((2 * bitrate)) -maxrate $((2 * bitrate)) \
    -tune psnr -threads 12 -vsync 0 $output

  # CBR (encoding from YUV)
  ffmpeg -f rawvideo -pix_fmt yuv420p -s:v ${width}x${height} -r $framerate \
    -i $inputyuv -vframes $numframes -y \
    -c:v libx264 -preset veryslow -profile:v high \
    -b:v $bitrate -x264opts no-sliced-threads:nal-hrd=cbr \
    -tune psnr -threads 12 -vsync 0 $output

ffmpeg-x265
***********

::

  # VBR (encoding from YUV)
  ffmpeg -f rawvideo -pix_fmt yuv420p -s:v ${width}x${height} -r $framerate \
    -i $inputyuv -vframes $numframes -y \
    -c:v libx265 -preset veryslow \
    -b:v $bitrate -maxrate $((2 * bitrate)) -bufsize $((2 * bitrate)) \
    -tune psnr -threads 12 -vsync 0 $output

  # CBR (encoding from YUV)
  ffmpeg -f rawvideo -pix_fmt yuv420p -s:v ${width}x${height} -r $framerate \
    -i $inputyuv -vframes $numframes -y \
    -c:v libx265 -preset veryslow \
    -b:v $bitrate -maxrate $bitrate -minrate $bitrate -bufsize $((2 * bitrate)) \
    -tune psnr -threads 12 -vsync 0 $output

Links
-----

* `ffmpeg-qsv <https://trac.ffmpeg.org/wiki/Hardware/QuickSync>`_
* `Intel Media SDK sample-multi-transcode <https://github.com/Intel-Media-SDK/MediaSDK/blob/master/doc/samples/readme-multi-transcode_linux.md>`_

.. |na| raw:: html

   &#x2205;

.. |check| raw:: html

   &#x2713;

.. |cross| raw:: html

   &#x2717;

