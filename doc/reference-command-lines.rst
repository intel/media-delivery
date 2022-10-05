Reference Command Lines (High-quality and Performance)
------------------------------------------------------

Intel’s advanced software bitrate controller (dubbed “EncTools”) has been
designed to boost GPU video quality for AVC, HEVC and AV1 using various
compression efficiency technologies and content adaptive quality optimization
tools while at the same time having minimal impact on the coding performance
(speed). EncTools technology includes tools such as adaptive pyramid quantization,
persistence adaptive quantization, low power look ahead, advanced scene change
detection and `more <quality.rst#enctools-and-extbrc>`_.

The recommended random access transcoding `ffmpeg-qsv <https://trac.ffmpeg.org/wiki/Hardware/QuickSync>`_
(Intel GPU integration with `ffmpeg <https://ffmpeg.org/>`_) command lines
optimized for high quality and performance are given below:

**AVC/H.264**::

  ffmpeg -hwaccel qsv -qsv_device ${DEVICE:-/dev/dri/renderD128} -c:v $inputcodec -extra_hw_frames 8 -an -i $input \
    -frames:v $numframes -c:v h264_qsv -preset $preset -profile:v high -async_depth 1 \
    -b:v $bitrate -maxrate $((2 * $bitrate)) -bitrate_limit 0 -bufsize $((4 * $bitrate)) \
    -rc_init_occupancy $((2 * $bitrate)) -low_power ${LOW_POWER:-true} \
    -look_ahead_depth 8 -extbrc 1 -b_strategy 1 \
    -adaptive_i 1 -adaptive_b 1 -bf 7 -refs 5 -g 256 -strict -1 \
    -vsync passthrough -y $output

**HEVC/H.265**::

  ffmpeg -hwaccel qsv -qsv_device ${DEVICE:-/dev/dri/renderD128} -c:v $inputcodec -extra_hw_frames 8 -an -i $input \
    -frames:v $numframes -c:v hevc_qsv -preset $preset -profile:v main -async_depth 1 \
    -b:v $bitrate -maxrate $((2 * $bitrate)) -bufsize $((4 * $bitrate)) \
    -rc_init_occupancy $((2 * $bitrate)) -low_power ${LOW_POWER:-true} \
    -look_ahead_depth 8 -extbrc 1 -b_strategy 1 \
    -bf 7 -refs 4 -g 256 -idr_interval begin_only -strict -1 \
    -vsync passthrough -y $output

**AV1**::

  ffmpeg -hwaccel qsv -qsv_device ${DEVICE:-/dev/dri/renderD128} -c:v $inputcodec -extra_hw_frames 8 -an -i $input \
    -frames:v $numframes -c:v av1_qsv -preset $preset -profile:v main -async_depth 1 \
    -b:v $bitrate -maxrate $((2 * bitrate)) -bufsize $((4 * bitrate)) \
    -rc_init_occupancy $((2 * bitrate)) -low_power ${LOW_POWER:-true} -look_ahead_depth 8 -extbrc 1 \
    -b_strategy 1 -adaptive_i 1 -adaptive_b 1 -bf 7 -g 256 -strict -1 \
    -vsync passthrough -y $output

Extra quality boost can be achieved with use of low power look ahead (by setting
``-look_ahead_depth 40`` option) at the expense of a slight performance impact (10-20%).
The use of ``-extra_hw_frames`` option is currently required for transcoding with look ahead
due to the increased GPU memory requirements. Please set the value for ``-extra_hw_frames``
to be the same as the number of lookahead frames.

For best single stream performance or low density use case with high resolutions such as
4K, ``-async_depth 2`` option is recommended (yielding only negligible quality loss 
compared to ``-async_depth 1``).

Recommendations for more specific use cases as well as additional information on
developer configurable bitrate controllers and available advanced coding options
are provided in the supplementary `Video Quality document <quality.rst>`_.

For more details on ffmpeg-qsv supported features, see `ffmpeg-qsv capabilites <features/ffmpeg#readme>`_.

For more information on how to engage with Intel GPU encoding, decoding and transcoding
as well as deal with multiple GPUs, please refer to
`ffmpeg-qsv multi-GPU selection document <https://github.com/Intel-Media-SDK/MediaSDK/wiki/FFmpeg-QSV-Multi-GPU-Selection-on-Linux>`_.

The recommended good practices are used throughout this project: in the demo examples
as well as in the quality and performance measuring scripts. The following links provide
additional information:

* `Video Quality Command Lines and Measuring Methodology <quality.rst>`_
* `Video Performance Command Linux and Measuring Methodology <performance.rst>`_

