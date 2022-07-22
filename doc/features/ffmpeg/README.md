# Capabilities of Intel® Quick Sync Video (QSV) FFmpeg Plugins

* [AV1](./av1.md)
* [H264/AVC](./h264.md)
* [H265/HEVC](./h265.md)
* [MJPEG](./mjpeg.md)
* [MPEG2](./mpeg2.md)
* [VP9](./vp9.md)

## BRC modes selection

There are few BRC modes which can be used by QSV encoders (all except MJPEG). Mind
that mode availability depends on underlying HW platform and driver software stack.
Below is a summary of options which trigger few key modes:

```
qsvcodec=av1_qsv|h264_qsv|hevc_qsv|mpeg2_qsv|vp9_qsv

# VBR
ffmpeg <...> -c:v $qsvcodec -b:v $bitrate -maxrate $((2 * $bitrate)) <...>

# CBR
ffmpeg <...> -c:v $qsvcodec -b:v $bitrate -maxrate $bitrate -minrate $bitrate <...>

# CQP
ffmpeg <...> -c:v $qsvcodec -b:v $bitrate -q $qp \
  -i_qfactor 1.0 -i_qoffset 1.0 -b_qfactor 1.0 -b_qoffset 0.0 <...>
```

There are few other modes exposed by QSV Plugins, like AVBR, QVBR, ICQ and few others.
These modes are currently not recommended, and some cases may become subject to be
deprecated.

MJPEG encoder does not have bitrate control and in general uses separate configuration
options. It's typical usage would be:

```
ffmpeg <...> -c:v mjpeg_qsv -global_quality $quality <...>
```

## Dynamic encoding settings

FFmpeg QSV encoders support setting some encoding parameters dynamically. Refer to each encoder
documentation for the list of supported settings. In this section we will just list most typical
dynamic settings.

| Feature                             | Mode | QSV Encoders       |
| ----------------------------------- | ---- | ------------------ |
| Forced IDR                          |      | All, except mjpeg  |
| `AV_FRAME_DATA_REGIONS_OF_INTEREST` |      | h264_qsv, hevc_qsv |
| `AVCodecContext::b_quant_factor`    | CQP  | h264_qsv, hevc_qsv |
| `AVCodecContext::b_quant_offset`    | CQP  | h264_qsv, hevc_qsv |
| `AVCodecContext::global_quality`    | CQP  | h264_qsv, hevc_qsv |
| `AVCodecContext::b_quant_factor`    | CQP  | h264_qsv, hevc_qsv |
| `AVCodecContext::b_quant_offset`    | CQP  | h264_qsv, hevc_qsv |

Some of these features might be used from ffmpeg command line, others require self-written application.

To force IDR frames you need to do 2 things:

1. Request `AVFrame::pict_type == AV_PICTURE_TYPE_I` on the frame you want to make IDR
2. Enable QSV encoder (on initialization stage) to actually force IDR on such frames

As such, IDR frame insertion ffmpeg command line might look like (insert IDR every 50 frames):

    qsvcodec=h264_qsv|hevc_qsv
    ffmpeg <...> -force_key_frames 'expr:gte(n,n_forced*50)' -c:v $qsvcodec -forced_idr 1 -g 300 <...>

To set Region of Interest (ROI) you can use [addroi](https://ffmpeg.org/ffmpeg-filters.html#addroi) filter:

    qsvcodec=h264_qsv|hevc_qsv
    ffmpeg <...> -vf "addroi=0:0:960:540:-1/2" -c:v $qsvcodec <...>

