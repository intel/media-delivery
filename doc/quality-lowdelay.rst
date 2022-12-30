Video Quality (Low Delay)
=========================

.. contents::

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

Quality assessment with Intel® Media Delivery solution is provided for 2 different encoding/transcoding use cases:

#. **High Quality (HQ)**
   - targets applications such as video archiving and storage (e.g. Blu-ray), and video streaming with a tolerable
   delay (e.g. video-on-demand). These applications have very few restrictions on the use of encoding tools such as
   look-ahead and B-frames, and can tolerate a larger delay (typically > 0.5 seconds).

#. **Low Delay (LD)**
   - is used in live streaming applications such as game streaming, user generated content streaming or events broadcasting.
   In these types of application the maxium tolerable delay is only a few frames (i.e. less than 0.5 seconds), and the use
   of advanced encoding prediction tools is limited (no B-frames, no look-ahead, etc).

Details of the quality assessment methodology for LD use case are described next. On the other hand, to learn more
about quality assessment methodology for HQ use case, please refer to `quality <quality.rst>`_.

The following table shows specific target bitrates used in quality evaluation of our H.264/AVC, H.265/HEVC and AV1 GPU
based video encoders (for LD use case). Note that 5 bitrates are given: the lowest 4 are used for the low BD-rate
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
| DinnerScene :sup:`*`          | 1920x1080  | 1, 1.5, 3, 4.5, 7.5 | 1, 1.5, 3, 4.5, 7.5 | 1, 1.5, 7, 11, 15   |
+-------------------------------+------------+---------------------+---------------------+---------------------+
| Kimono :sup:`*`               | 1920x1080  | 2, 3, 6, 12, 24     | 2, 3.5, 6, 9, 15    | 2, 3, 6, 9, 15      |
+-------------------------------+------------+---------------------+---------------------+---------------------+
| ParkJoy :sup:`*`              | 1920x1080  | 15, 20, 25, 30, 35  | 15, 20, 25, 30, 35  | 15, 20, 25, 30, 35  |
+-------------------------------+------------+---------------------+---------------------+---------------------+
| RedKayak :sup:`*`             | 1920x1080  | 2, 3, 6, 12, 24     | 9, 12, 15, 18, 22   | 2, 3, 6, 9, 15      |
+-------------------------------+------------+---------------------+---------------------+---------------------+
| RushFieldCuts                 | 1920x1080  | 2, 3, 6, 12, 24     | 2, 3, 6, 9, 15      | 2, 3, 6, 9, 15      |
+-------------------------------+------------+---------------------+---------------------+---------------------+
| Boat                          | 1280x720   | 1, 1.5, 3, 6, 12    | 1, 1.5, 3, 4.5, 7.5 | 1, 1.5, 3, 4.5, 7.5 |
+-------------------------------+------------+---------------------+---------------------+---------------------+
| CrowdRun :sup:`*`             | 1280x720   | 3, 4.5, 7.5, 10, 12 | 3, 4.5, 7.5, 10, 12 | 3, 4.5, 7.5, 10, 12 |
+-------------------------------+------------+---------------------+---------------------+---------------------+
| FoodMarket                    | 1280x720   | 1, 1.5, 3, 6, 12    | 1, 1.5, 3, 4.5, 7.5 | 1, 1.5, 3, 4.5, 7.5 |
+-------------------------------+------------+---------------------+---------------------+---------------------+
| Kimono                        | 1280x720   | 1, 1.5, 3, 6, 12    | 1, 1.5, 3, 4.5, 7.5 | 1, 1.5, 3, 4.5, 7.5 |
+-------------------------------+------------+---------------------+---------------------+---------------------+
| ParkJoy :sup:`*`              | 1280x720   | 3, 4.5, 7.5, 10, 12 | 3, 4.5, 7.5, 10, 12 | 3, 4.5, 7.5, 10, 12 |
+-------------------------------+------------+---------------------+---------------------+---------------------+
| ParkScene                     | 1280x720   | 1, 1.5, 3, 6, 12    | 1, 1.5, 3, 4.5, 7.5 | 1, 1.5, 3, 4.5, 7.5 |
+-------------------------------+------------+---------------------+---------------------+---------------------+
| PierSeaSide                   | 1280x720   | 1, 1.5, 3, 6, 12    | 1, 1.5, 3, 4.5, 7.5 | 1, 1.5, 3, 4.5, 7.5 |
+-------------------------------+------------+---------------------+---------------------+---------------------+
| Tango                         | 1280x720   | 1, 1.5, 3, 6, 12    | 1, 1.5, 3, 4.5, 7.5 | 1, 1.5, 3, 4.5, 7.5 |
+-------------------------------+------------+---------------------+---------------------+---------------------+
| TouchDownPass                 | 1280x720   | 1, 1.5, 3, 6, 12    | 1, 1.5, 3, 4.5, 7.5 | 1, 1.5, 3, 4.5, 7.5 |
+-------------------------------+------------+---------------------+---------------------+---------------------+
| Bunny :sup:`*`                | 1920x1080  | 2, 3, 6, 12, 24     | 2, 3, 6, 9, 15      | 8, 9, 10, 11, 12    |
+-------------------------------+------------+---------------------+---------------------+---------------------+
| CSGO :sup:`*`                 | 1920x1080  | 2, 3, 6, 12, 24     | 2, 3, 6, 9, 15      | 1.5, 2, 3, 9, 15    |
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

For LD use case, we measure 1 encoding mode: constant bitrate (CBR) mode with low buffer delay. The final average
BD-rate for a video sequence encoded with a given encoder is computed by averaging the following 2 individual BD-rates:

#. CBR low bitrates BD-rate
#. CBR high bitrates BD-rate

In the following sections you can find command lines used for low delay H.264/AVC, H.265/HEVC and AV1 video
coding with Intel® Media SDK `Sample Multi-Transcode <https://github.com/Intel-Media-SDK/MediaSDK/blob/master/doc/samples/readme-multi-transcode_linux.md>`_
and `ffmpeg-qsv <https://trac.ffmpeg.org/wiki/Hardware/QuickSync>`_ (Intel® Media SDK integration into FFmpeg).

Video Quality Measuring Tool
----------------------------
A `video quality measuring tool <man/measure-quality.asciidoc>`_ is provided as a part of Media Delivery Software Stack.
The tool allows users to measure video quality for themselves in a manner described in this document for either 
a predefined set of video sequences, or a video sequences of their choosing.  The input can be a raw YUV 4:2:0 8-bit file, 
or any video encoded bitstream (raw or within a container) supported by ffmpeg.

YUV Quality Measure Low Delay Example
*************************************

::

  measure quality -w 1920 -h 1080 -f 24 --use-lowdelay InputVideo.yuv

H.264 Bitstream Quality Measure Low Delay Example
*************************************************

::

  measure quality --use-lowdelay InputVideo.h264

Both ffmpeg and sample-multi-transcode quality results will be computed for pre-encoded input content.

MP4 Container Quality Measure Low Delay Example
***********************************************

::

  measure quality --use-lowdelay InputVideo.mp4

Only ffmpeg-based quality results will be computed for pre-encoded input content encapsulated in a container.

Next we present quality command lines for H.264/AVC and H.265/HEVC. To maximize quality over performance, use "veryslow" preset. For maximum
performance set preset to "veryfast". For a balanced quality/performance tradeoff use "medium" preset.


H.264/AVC Low Delay
-------------------

To achieve better quality for low delay use case with Intel GPU H.264/AVC encoder, we recommend the following settings:

+-------------------------------------------------------+----------------+--------------------------------------------------------------------------+
| ffmpeg-qsv options                                    | ffmpeg version | Comments                                                                 |
+=======================================================+================+==========================================================================+
| CBR                                                                                                                                               |
+-------------------------------------------------------+----------------+--------------------------------------------------------------------------+
| ``-b:v $bitrate -minrate $bitrate -maxrate $bitrate`` | n2.8           | This triggers CBR.                                                       |
+-------------------------------------------------------+----------------+--------------------------------------------------------------------------+
| ``-bufsize $((bitrate / 4))``                         | n4.0           | For low delay we recommend using 0.25s buffer for AVC.                   |
+-------------------------------------------------------+----------------+--------------------------------------------------------------------------+
| ``-rc_init_occupancy $bitrate``                       | n2.8           | This is the initial buffer delay. Recommended value is 1/2 of bufsize.   |
+-------------------------------------------------------+----------------+--------------------------------------------------------------------------+
| ``-bf 0``                                             | n3.0           | Theis setting disables B-Frames.                                         |
+-------------------------------------------------------+----------------+--------------------------------------------------------------------------+
| ``-refs 5``                                           | n2.7           | 5 references are important to trigger Long Term Reference (LTR) coding   |
|                                                       |                | feature.                                                                 |
+-------------------------------------------------------+----------------+--------------------------------------------------------------------------+
| ``-g 9999``                                           | n2.7           | Select very long GOP size to effectively mimic infinite GOP setting.     |
+-------------------------------------------------------+----------------+--------------------------------------------------------------------------+
| ``-strict 1``                                         | n3.0           | Enables HRD compliance.                                                  |
+-------------------------------------------------------+----------------+--------------------------------------------------------------------------+

::

  # LD CBR (encoding from YUV with ffmpeg-qsv)
  ffmpeg -init_hw_device vaapi=va:${DEVICE:-/dev/dri/renderD128} -init_hw_device qsv=hw@va -an \
    -f rawvideo -pix_fmt yuv420p -s:v ${width}x${height} -r $framerate -i $inputyuv \
    -frames:v $numframes -c:v h264_qsv -preset $preset -profile:v high -async_depth 1 \
    -b:v $bitrate -maxrate $bitrate -minrate $bitrate -bufsize $((bitrate / 4)) \
    -rc_init_occupancy $((bitrate / 8)) -bitrate_limit 0 -low_power ${LOW_POWER:-true} \
    -bf 0 -refs 5 -g 9999 -strict 1 -fps_mode passthrough -y $output

  # LD CBR (transcoding with ffmpeg-qsv)
  ffmpeg -hwaccel qsv -qsv_device ${DEVICE:-/dev/dri/renderD128} -c:v $inputcodec -an -i $input \
    -frames:v $numframes -c:v h264_qsv -preset $preset -profile:v high -async_depth 1 \
    -b:v $bitrate -maxrate $bitrate -minrate $bitrate -bufsize $((bitrate / 4)) \
    -rc_init_occupancy $((bitrate / 8)) -bitrate_limit 0 -low_power ${LOW_POWER:-true} \
    -bf 0 -refs 5 -g 9999 -strict 1 -fps_mode passthrough -y $output

  # LD CBR (encoding from YUV with Sample Multi-Transcode)
  sample_multi_transcode -i::i420 $inputyuv -hw -async 1 \
    -device ${DEVICE:-/dev/dri/renderD128} -u $preset -b $bitrateKb -cbr -n $numframes \
    -w $width -h $height -override_encoder_framerate $framerate -lowpower:${LOWPOWER:-on} \
    -hrd $((bitrateKb / 32)) -InitialDelayInKB $((bitrateKb / 64)) \
    -dist 1 -num_ref 5 -gop_size 9999 -NalHrdConformance:off -VuiNalHrdParameters:off -o::h264 $output

  # LD CBR (transcoding from raw bitstream with Sample Multi-Transcode)
  sample_multi_transcode -i::${inputcodec} $input -hw -async 1 \
    -device ${DEVICE:-/dev/dri/renderD128} -u $preset -b $bitrateKb -cbr -n $numframes \
    -lowpower:${LOWPOWER:-on} -hrd $((bitrateKb / 32)) -InitialDelayInKB $((bitrateKb / 64)) \
    -dist 1 -num_ref 5 -gop_size 9999 -NalHrdConformance:off -VuiNalHrdParameters:off -o::h264 $output

H.265/HEVC
----------

To achieve better quality for low delay use case with Intel GPU H.265/HEVC encoder, we recommend the following settings:

+-------------------------------------------------------+----------------+--------------------------------------------------------------------------+
| ffmpeg-qsv options                                    | ffmpeg version | Comments                                                                 |
+=======================================================+================+==========================================================================+
| CBR                                                                                                                                               |
+-------------------------------------------------------+----------------+--------------------------------------------------------------------------+
| ``-b:v $bitrate -minrate $bitrate -maxrate $bitrate`` | n2.8           | This triggers CBR.                                                       |
+-------------------------------------------------------+----------------+--------------------------------------------------------------------------+
| ``-bufsize $((bitrate / 4))``                         | n4.0           | For low delay we recommend using 0.25s buffer for HEVC.                  |
+-------------------------------------------------------+----------------+--------------------------------------------------------------------------+
| ``-rc_init_occupancy $bitrate``                       | n2.8           | This is the initial buffer delay. Recommended value is 1/2 of bufsize.   |
+-------------------------------------------------------+----------------+--------------------------------------------------------------------------+
| ``-bf 0``                                             | n3.0           | Theis setting disables B-Frames.                                         |
+-------------------------------------------------------+----------------+--------------------------------------------------------------------------+
| ``-refs 4``                                           | n2.7           | 4 references are recommended for HEVC to boost quality.                  |
+-------------------------------------------------------+----------------+--------------------------------------------------------------------------+
| ``-g 9999``                                           | n2.7           | Select very long GOP size to effectively mimic infinite GOP setting.     |
+-------------------------------------------------------+----------------+--------------------------------------------------------------------------+
| ``-strict 1``                                         | n3.0           | Enables HRD compliance.                                                  |
+-------------------------------------------------------+----------------+--------------------------------------------------------------------------+

Example command lines:

::

  # LD CBR (encoding from YUV with ffmpeg-qsv)
  ffmpeg -init_hw_device vaapi=va:${DEVICE:-/dev/dri/renderD128} -init_hw_device qsv=hw@va -an \
    -f rawvideo -pix_fmt yuv420p -s:v ${width}x${height} -r $framerate -i $inputyuv \
    -frames:v $numframes -c:v hevc_qsv -preset $preset -profile:v main -async_depth 1 \
    -b:v $bitrate -maxrate $bitrate -minrate $bitrate -bufsize $((bitrate / 4)) \
    -rc_init_occupancy $((bitrate / 8)) -low_power ${LOW_POWER:-true} \
    -bf 0 -refs 4 -g 9999 -strict 1 -fps_mode passthrough -y $output

  # LD CBR (transcoding with ffmpeg-qsv)
  ffmpeg -hwaccel qsv -qsv_device ${DEVICE:-/dev/dri/renderD128} -c:v $inputcodec -an -i $input \
    -frames:v $numframes -c:v hevc_qsv -preset $preset -profile:v main -async_depth 1 \
    -b:v $bitrate -maxrate $bitrate -minrate $bitrate -bufsize $((bitrate / 4)) \
    -rc_init_occupancy $((bitrate / 8)) -low_power ${LOW_POWER:-true} \
    -bf 0 -refs 4 -g 9999 -strict 1 -fps_mode passthrough -y $output

  # LD CBR (encoding from YUV with Sample Multi-Transcode)
  sample_multi_transcode -i::i420 $inputyuv -hw -async 1 -device ${DEVICE:-/dev/dri/renderD128} \
    -u $preset -b $bitrateKb -cbr -n $numframes -w $width -h $height -override_encoder_framerate $framerate \
    -lowpower:${LOWPOWER:-on} -dist 1 -num_ref 4 -gop_size 9999 -NalHrdConformance:off -VuiNalHrdParameters:off \
     -hrd $((bitrateKb / 32)) -InitialDelayInKB $((bitrateKb / 64)) -o::h265 $output

  # LD CBR (transcoding from raw bitstream with Sample Multi-Transcode)
  sample_multi_transcode -i::${inputcodec} $input -hw -async 1 -device ${DEVICE:-/dev/dri/renderD128} \
    -u $preset -b $bitrateKb -cbr -n $numframes -lowpower:${LOWPOWER:-on} \
    -dist 1 -num_ref 4 -gop_size 9999 -NalHrdConformance:off -VuiNalHrdParameters:off \
    -hrd $((bitrateKb / 32)) -InitialDelayInKB $((bitrateKb / 64)) -o::h265 $output

AV1
---

To achieve better quality for low delay use case with Intel GPU AV1 encoder, we recommend the following settings:

+-------------------------------------------------------+----------------+--------------------------------------------------------------------------+
| ffmpeg-qsv options                                    | ffmpeg version | Comments                                                                 |
+=======================================================+================+==========================================================================+
| CBR                                                                                                                                               |
+-------------------------------------------------------+----------------+--------------------------------------------------------------------------+
| ``-b:v $bitrate -minrate $bitrate -maxrate $bitrate`` | n2.8           | This triggers CBR.                                                       |
+-------------------------------------------------------+----------------+--------------------------------------------------------------------------+
| ``-bufsize $((bitrate / 2))``                         | n4.0           | For low delay we recommend using 0.5s buffer for AV1.                    |
+-------------------------------------------------------+----------------+--------------------------------------------------------------------------+
| ``-rc_init_occupancy $bitrate``                       | n2.8           | This is the initial buffer delay. Recommended value is 1/2 of bufsize.   |
+-------------------------------------------------------+----------------+--------------------------------------------------------------------------+
| ``-bf 0``                                             | n3.0           | Theis setting disables B-Frames.                                         |
+-------------------------------------------------------+----------------+--------------------------------------------------------------------------+
| ``-g 9999``                                           | n2.7           | Select very long GOP size to effectively mimic infinite GOP setting.     |
+-------------------------------------------------------+----------------+--------------------------------------------------------------------------+

Example command lines:

::

  # LD CBR (encoding from YUV with ffmpeg-qsv)
  ffmpeg -init_hw_device vaapi=va:${DEVICE:-/dev/dri/renderD128} -init_hw_device qsv=hw@va -an \
    -f rawvideo -pix_fmt yuv420p -s:v ${width}x${height} -r $framerate -i $inputyuv \
    -frames:v $numframes -c:v av1_qsv -preset $preset -profile:v main -async_depth 1 \
    -b:v $bitrate -maxrate $bitrate -minrate $bitrate -bufsize $((bitrate / 2)) -rc_init_occupancy $((bitrate / 4)) \
    -bf 0 -g 9999 -fps_mode passthrough -y $output

  # LD CBR (transcoding with ffmpeg-qsv)
  ffmpeg -hwaccel qsv -qsv_device ${DEVICE:-/dev/dri/renderD128} -c:v $inputcodec -an -i $input \
    -frames:v $numframes -c:v av1_qsv -preset $preset -profile:v main -async_depth 1 \
    -b:v $bitrate -maxrate $bitrate -minrate $bitrate -bufsize $((bitrate / 2)) -rc_init_occupancy $((bitrate / 4)) \
    -bf 0 -g 9999 -fps_mode passthrough -y $output

  # LD CBR (encoding from YUV with Sample Multi-Transcode)
  sample_multi_transcode -i::i420 $inputyuv -hw -async 1 -device ${DEVICE:-/dev/dri/renderD128} \
    -u $preset -b $bitrateKb -cbr -n $numframes -w $width -h $height -override_encoder_framerate $framerate \
    -hrd $((bitrateKb / 16)) -InitialDelayInKB $((bitrateKb / 32)) \
    -dist 1 -gop_size 9999 -o::av1 $output

  # LD CBR (transcoding from raw bitstream with Sample Multi-Transcode)
  sample_multi_transcode -i::$inputcodec $input -hw -async 1 \
    -device ${DEVICE:-/dev/dri/renderD128} -u $preset -b $bitrateKb \
    -cbr -n $numframes -hrd $((bitrateKb / 16)) -InitialDelayInKB $((bitrateKb / 32)) \
    -dist 1 -gop_size 9999 -o::av1 $output

Reference Codecs
----------------

For assessing the quality of Intel's H.264 Advanced Video Coding (AVC) and H.265 High Efficiency Video Coding (HEVC)
codecs we are using ffmpeg-x264 and ffmpeg-x265 as reference codecs in ``medium`` preset for the BD-rate measure. For
assessing the quality of Intel's AV1 codec we are using ffmpeg-x264 as a reference codec in ``medium`` preset for its
BD-rate measure. The reference codecs use 12 threads and ``-tune zerolatency`` option.  For AVC and HEVC buffer size
was set to 0.25s (N = 4) and for AV1 to 0.5s (N = 2).

ffmpeg-x264
***********
::

  # LD CBR (encoding from YUV)
  ffmpeg -f rawvideo -pix_fmt yuv420p -s:v ${width}x${height} -r $framerate \
    -i $inputyuv -vframes $numframes -y \
    -c:v libx264 -preset medium -profile:v high \
    -b:v $bitrate -maxrate $bitrate -minrate $bitrate -bufsize $((bitrate / N)) \
    -tune zerolatency -threads 12 -fps_mode passthrough $output

ffmpeg-x265
***********

::

  # LD CBR (encoding from YUV)
  ffmpeg -f rawvideo -pix_fmt yuv420p -s:v ${width}x${height} -r $framerate \
    -i $inputyuv -vframes $numframes -y \
    -c:v libx265 -preset medium \
    -b:v $bitrate -maxrate $bitrate -minrate $bitrate -bufsize $((bitrate / N)) \
    -tune zerolatency -threads 12 -fps_mode passthrough $output

Links
-----

* `ffmpeg-qsv <https://trac.ffmpeg.org/wiki/Hardware/QuickSync>`_
* `Intel Media SDK Sample Multi-Transcode <https://github.com/Intel-Media-SDK/MediaSDK/blob/master/doc/samples/readme-multi-transcode_linux.md>`_

.. |na| raw:: html

   &#x2205;

.. |check| raw:: html

   &#x2713;

.. |cross| raw:: html

   &#x2717;

