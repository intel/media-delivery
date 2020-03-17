Intel Media Delivery Solutions - Video Quality
==============================================

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

The command lines for high quality H.264/AVC and h.265/HEVC video coding with Intel® Media SDK Sample Encode and Intel® Open source Quick Sync Video (QSV) are given below.

Intel QSV H.264/AVC VBR:
*****************************
::

  ffmpeg -f rawvideo -pix_fmt yuv420p -s:v ${width}x${height} -r $framerate -i $inputyuv -vframes $numframes -y -c:v h264_qsv -preset medium -profile:v high -b:v $bitrate -extbrc 1 -b_strategy 1 -bf 7 -refs 5 -vsync 0 $output


Intel QSV H.264/AVC CBR:
*****************************
::

  ffmpeg -f rawvideo -pix_fmt yuv420p -s:v ${width}x${height} -r $framerate -i $inputyuv -vframes $numframes -y -c:v h264_qsv -preset medium -profile:v high -b:v $bitrate -maxrate $bitrate -minrate $bitrate -extbrc 1 -b_strategy 1 -bf 7 -refs 5 -vsync 0 $output


Intel Media SDK Sample Encode H.264/AVC VBR:
************************************************
::

  sample_encode h264 -u medium -b $bitrate -vbr -extbrc:implicit -ExtBrcAdaptiveLTR:on -r 8 -x 5 -i $input -hw -o $output -w $width -h $height -n $numframes -f $framerate


Intel Media SDK Sample Encode H.264/AVC CBR:
************************************************
::

  sample_encode h264 -u medium -b $bitrate -cbr -extbrc:implicit -ExtBrcAdaptiveLTR:on -r 8 -x 5 -i $input -hw -o $output -w $width -h $height -n $numframes -f $framerate


Intel QSV H.265/HEVC VBR:
*****************************
::

  ffmpeg -f rawvideo -pix_fmt yuv420p -s:v ${width}x${height} -r $framerate -i $inputyuv -vframes $numframes -y -c:v hevc_qsv -preset medium -profile:v main -b:v $bitrate -extbrc 1 -qmin 1 -qmax 51 -refs 5 -vsync 0 $output


Intel QSV H.265/HEVC CBR:
*****************************
::

  ffmpeg -f rawvideo -pix_fmt yuv420p -s:v ${width}x${height} -r $framerate -i $inputyuv -vframes $numframes -y -c:v hevc_qsv -preset medium -profile:v main -b:v $bitrate -maxrate $bitrate -minrate $bitrate -extbrc 1 -qmin 1 -qmax 51 -refs 5 -vsync 0 $output


Intel Media SDK Sample Encode H.265/HEVC VBR:
************************************************
::

  sample_encode h265 -u medium -b $bitrate -vbr -extbrc:on -x 5 -i $input -hw -o $output -w $width -h $height -n $numframes -f $framerate


Intel Media SDK Sample Encode H.265/HEVC CBR:
************************************************
::

  sample_encode h265 -u medium -b $bitrate -cbr -extbrc:on -x 5 -i $input -hw -o $output -w $width -h $height -n $numframes -f $framerate

