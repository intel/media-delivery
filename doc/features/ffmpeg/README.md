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

