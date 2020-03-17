Media Delivery Solutions - Video Quality
========================================

.. contents::


Video Quality Metrics
---------------------

Peak signal-to-noise ratio (PSNR) is the most widely used objective image quality metric. 
We use arithmetic average PSNR of the luminance frames (PSNR-Y) as the basic quality assessment 
metric. Since PSNR fails to capture certain perceptual quality traits, we also make use of the 
following additional quality metrics: SSIM, MS-SSIM, and VMAF. To compare quality with 
different codecs and/or coding options, we compute the Bjøntegaard-Delta bitrate 
(BD-rate) measure, in which negative values indicate how much lower the bitrate 
is reduced, and positive values indicate how much the bitrate is increased for the same 
PSNR-Y. We use a 4-point BD-rate measure for both low and high bitrates settings. 
In addition, we measure 2 encoding modes: variable bitrate (VBR) and, constant bitrate 
(CBR) modes. The BD-rate for a sequence encoded with a given encoder is computed by 
averaging these 4 individual BD-rates. For assessing the quality of Intel's H.264 Advanced 
Video Coding (AVC) and H.265 High Efficiency Video Coding (HEVC) codecs we used ffmpeg-x264 and 
ffmpeg-x265 in very-slow presets, respectively, for the BD-rate reference.

Bitrates
--------

Coding bitrates for H.264/AVC video quality assessment:

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


Coding bitrates for H.265/HEVC video quality assessment:

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

Command Lines
-------------

In the following sections you can find command lines used for high quality H.264/AVC and H.265/HEVC video coding
with Intel® Media SDK `Sample Encode <https://github.com/Intel-Media-SDK/MediaSDK/blob/master/doc/samples/readme-encode_linux.md>`_
and `ffmpeg-qsv <https://trac.ffmpeg.org/wiki/Hardware/QuickSync>`_ (Intel® Media SDK integration
into FFmpeg).

H.264/AVC Command Lines
-----------------------

ffmpeg-qsv VBR
**************

::

  ffmpeg -f rawvideo -pix_fmt yuv420p -s:v ${width}x${height} -r $framerate -i $inputyuv -vframes $numframes -y \
    -c:v h264_qsv -preset medium -profile:v high -b:v $bitrate \
    -extbrc 1 -b_strategy 1 -bf 7 -refs 5 -vsync 0 $output

ffmpeg-qsv CBR
**************

::

  ffmpeg -f rawvideo -pix_fmt yuv420p -s:v ${width}x${height} -r $framerate -i $inputyuv -vframes $numframes -y \
    -c:v h264_qsv -preset medium -profile:v high -b:v $bitrate -maxrate $bitrate -minrate $bitrate \
    -extbrc 1 -b_strategy 1 -bf 7 -refs 5 -vsync 0 $output

Intel Media SDK sample-encode VBR
*********************************
::

  sample_encode h264 -hw -i $input -w $width -h $height -n $numframes -f $framerate -o $output -u medium -vbr -b $bitrate \
    -extbrc:implicit -ExtBrcAdaptiveLTR:on -r 8 -x 5

Intel Media SDK sample-encode CBR
*********************************
::

  sample_encode h264 -hw -i $input -w $width -h $height -n $numframes -f $framerate -o $output -u medium -cbr -b $bitrate \
    -extbrc:implicit -ExtBrcAdaptiveLTR:on -r 8 -x 5

H.265/HEVC Command Lines
------------------------

ffmpeg-qsv VBR
**************

::

  ffmpeg -f rawvideo -pix_fmt yuv420p -s:v ${width}x${height} -r $framerate -i $inputyuv -vframes $numframes -y \
    -c:v hevc_qsv -preset medium -profile:v main -b:v $bitrate -extbrc 1 -qmin 1 -qmax 51 -refs 5 -vsync 0 $output

ffmpeg-qsv CBR
**************

::

  ffmpeg -f rawvideo -pix_fmt yuv420p -s:v ${width}x${height} -r $framerate -i $inputyuv -vframes $numframes -y \
    -c:v hevc_qsv -preset medium -profile:v main -b:v $bitrate -maxrate $bitrate -minrate $bitrate \
    -extbrc 1 -qmin 1 -qmax 51 -refs 5 -vsync 0 $output

Intel Media SDK sample-encode VBR
*********************************

::

  sample_encode h265 -hw -i $input -w $width -h $height -n $numframes -f $framerate -o $output -u medium -vbr -b $bitrate -extbrc:on -x 5

Intel Media SDK sample-encode CBR
*********************************

::

  sample_encode h265 -hw -i $input -w $width -h $height -n $numframes -f $framerate -o $output -u medium -cbr -b $bitrate -extbrc:on -x 5

Links
-----

* `ffmpeg-qsv <https://trac.ffmpeg.org/wiki/Hardware/QuickSync>`_
* `Intel Media SDK sample-encode <https://github.com/Intel-Media-SDK/MediaSDK/blob/master/doc/samples/readme-encode_linux.md>`_
