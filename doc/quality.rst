Video Quality
=============

.. contents::

Video Quality Assessment Methodology
------------------------------------

In this document we describe the methodology which is used to measure video quality of Intel® Media SDK 
`Sample Encode <https://github.com/Intel-Media-SDK/MediaSDK/blob/master/doc/samples/readme-encode_linux.md>`_ and 
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
coding with Intel® Media SDK `Sample Encode <https://github.com/Intel-Media-SDK/MediaSDK/blob/master/doc/samples/readme-encode_linux.md>`_
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

H.264/AVC Command Lines
-----------------------

ffmpeg-qsv VBR
**************

::

  ffmpeg -hwaccel qsv \
    -f rawvideo -pix_fmt yuv420p -s:v ${width}x${height} -r $framerate \
    -i $inputyuv -vframes $numframes -y \
    -c:v h264_qsv -preset $preset -profile:v high \
    -b:v $bitrate -maxrate $((2 * $bitrate)) -bufsize $((4 * $bitrate)) \
    -g 256 -extbrc 1 -b_strategy 1 -bf 7 -refs 5 -vsync 0 $output

ffmpeg-qsv CBR
**************

::

  ffmpeg -hwaccel qsv \
    -f rawvideo -pix_fmt yuv420p -s:v ${width}x${height} -r $framerate \
    -i $inputyuv -vframes $numframes -y \
    -c:v h264_qsv -preset $preset -profile:v high \
    -b:v $bitrate -maxrate $bitrate -minrate $bitrate -bufsize $((2 * $bitrate)) \
    -g 256 -extbrc 1 -b_strategy 1 -bf 7 -refs 5 -vsync 0 $output

Intel Media SDK sample-encode VBR
*********************************
::

  sample_encode h264 -hw \
    -i $input -w $width -h $height -n $numframes -f $framerate \
    -o $output \
    -u $preset -vbr -b $bitrate \
    -BufferSizeInKB $(python3 -c 'print(int('$bitrate' / 2))') \
    -extbrc:implicit -ExtBrcAdaptiveLTR:on -r 8 -x 5 \
    -g 256 -NalHrdConformance:off -VuiNalHrdParameters:off

Intel Media SDK sample-encode CBR
*********************************
::

  sample_encode h264 -hw \
    -i $input -w $width -h $height -n $numframes -f $framerate \
    -o $output \
    -u $preset -cbr -b $bitrate \
    -BufferSizeInKB $(python3 -c 'print(int('$bitrate' / 4))') \
    -extbrc:implicit -ExtBrcAdaptiveLTR:on -r 8 -x 5 \
    -g 256 -NalHrdConformance:off -VuiNalHrdParameters:off

Intel Media SDK sample-multi-transcode VBR
******************************************
::

  sample_multi_transcode -i::$inputcodec $input -hw -async 1 \
    -u $preset -b $bitrate -vbr -n $nframes \
    -hrd $(python3 -c 'print(int('$bitrate' / 2))') \
    -extbrc::implicit -ExtBrcAdaptiveLTR:on -dist 8 -num_ref 5 \
    -gop_size 256 -NalHrdConformance:off -VuiNalHrdParameters:off \
    -o::h264 $output

Intel Media SDK sample-multi-transcode CBR
******************************************
::

  sample_multi_transcode -i::$inputcodec $input -hw -async 1 \
    -u $preset -b $bitrate -cbr -n $nframes \
    -hrd $(python3 -c 'print(int('$bitrate' / 4))') \
    -extbrc::implicit -ExtBrcAdaptiveLTR:on -dist 8 -num_ref 5 \
    -gop_size 256 -NalHrdConformance:off -VuiNalHrdParameters:off \
    -o::h264 $output

H.265/HEVC Command Lines
------------------------

ffmpeg-qsv VBR
**************

::

  ffmpeg -hwaccel qsv \
    -f rawvideo -pix_fmt yuv420p -s:v ${width}x${height} -r $framerate \
    -i $inputyuv -vframes $numframes -y \
    -c:v hevc_qsv -preset medium -profile:v main \
    -b:v $bitrate -maxrate $((2 * $bitrate)) -bufsize $((4 * $bitrate)) \
    -g 256 -extbrc 1 -refs 5 -bf 7 -vsync 0 $output

ffmpeg-qsv CBR
**************

::

  ffmpeg -hwaccel qsv \
    -f rawvideo -pix_fmt yuv420p -s:v ${width}x${height} -r $framerate \
    -i $inputyuv -vframes $numframes -y \
    -c:v hevc_qsv -preset medium -profile:v main \
    -b:v $bitrate -maxrate $bitrate -minrate $bitrate -bufsize $((2 * $bitrate)) \
    -g 256 -extbrc 1 -refs 5 -bf 7 -vsync 0 $output

Intel Media SDK sample-encode VBR
*********************************

::

  sample_encode h265 -hw \
    -i $input -w $width -h $height -n $numframes -f $framerate \
    -o $output \
    -u medium -vbr -b $bitrate \
    -BufferSizeInKB $(python3 -c 'print(int('$bitrate' / 2))') \
    -extbrc:implicit -x 5 \
    -g 256 -NalHrdConformance:off -VuiNalHrdParameters:off

Intel Media SDK sample-encode CBR
*********************************

::

  sample_encode h265 -hw \
    -i $input -w $width -h $height -n $numframes -f $framerate \
    -o $output \
    -u medium -cbr -b $bitrate \
    -BufferSizeInKB $(python3 -c 'print(int('$bitrate' / 4))') \
    -extbrc:implicit -x 5 \
    -g 256 -NalHrdConformance:off -VuiNalHrdParameters:off

Intel Media SDK sample-multi-transcode VBR
******************************************
::

  sample_multi_transcode -i::$inputcodec $input -hw -async 1 \
    -u $preset -b $bitrate -vbr -n $nframes \
    -hrd $(python3 -c 'print(int('$bitrate' / 2))') \
    -extbrc::implicit -ExtBrcAdaptiveLTR:on -dist 8 -num_ref 5 \
    -gop_size 256 -NalHrdConformance:off -VuiNalHrdParameters:off \
    -o::h265 $output

Intel Media SDK sample-multi-transcode CBR
******************************************
::

  sample_multi_transcode -i::$inputcodec $input -hw -async 1 \
    -u $preset -b $bitrate -cbr -n $nframes \
    -hrd $(python3 -c 'print(int('$bitrate' / 4))') \
    -extbrc::implicit -ExtBrcAdaptiveLTR:on -dist 8 -num_ref 5 \
    -gop_size 256 -NalHrdConformance:off -VuiNalHrdParameters:off \
    -o::h265 $output

Reference Codecs
----------------

For assessing the quality of Intel's H.264 Advanced Video Coding (AVC) and H.265 High Efficiency Video Coding (HEVC) codecs we are
using ffmpeg-x264 and ffmpeg-x265 as reference codecs in ``veryslow`` preset for the BD-rate measure. The reference codecs are ran
with 12 threads and ``-tune psnr`` option. 

ffmpeg-x264 VBR reference
*************************

::

  ffmpeg -f rawvideo -pix_fmt yuv420p -s:v ${width}x${height} -r $framerate \
    -i $inputyuv -vframes $numframes -y \
    -c:v libx264 -preset veryslow -profile:v high \
    -b:v $bitrate -bufsize $((2 * bitrate)) -maxrate $((2 * bitrate)) \
    -tune psnr -threads 12 -vsync 0 $output

ffmpeg-x264 CBR reference
*************************

::

  ffmpeg -f rawvideo -pix_fmt yuv420p -s:v ${width}x${height} -r $framerate \
    -i $inputyuv -vframes $numframes -y \
    -c:v libx264 -preset veryslow -profile:v high \
    -b:v $bitrate -x264opts no-sliced-threads:nal-hrd=cbr \
    -tune psnr -threads 12 -vsync 0 $output

ffmpeg-x265 VBR reference
*************************

::

  ffmpeg -f rawvideo -pix_fmt yuv420p -s:v ${width}x${height} -r $framerate \
    -i $inputyuv -vframes $numframes -y \
    -c:v libx265 -preset veryslow \
    -b:v $bitrate -maxrate $((2 * bitrate)) -bufsize $((2 * bitrate)) \
    -tune psnr -threads 12 -vsync 0 $output

ffmpeg-x265 CBR reference
*************************

::

  ffmpeg -f rawvideo -pix_fmt yuv420p -s:v ${width}x${height} -r $framerate \
    -i $inputyuv -vframes $numframes -y \
    -c:v libx265 -preset veryslow \
    -b:v $bitrate -maxrate $bitrate -minrate $bitrate -bufsize $((2 * bitrate)) \
    -tune psnr -threads 12 -vsync 0 $output


Links
-----

* `ffmpeg-qsv <https://trac.ffmpeg.org/wiki/Hardware/QuickSync>`_
* `Intel Media SDK sample-encode <https://github.com/Intel-Media-SDK/MediaSDK/blob/master/doc/samples/readme-encode_linux.md>`_

