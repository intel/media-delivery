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
documentation for the list of supported settings. In general, dynamic settings сan be divided
into following categories:

* Dynamic settings which can be set at a frame level via `AVFrame`
* Dynamic settings which can be set at global context level ("Global" options)
* Dynamic settings which can be set at private context level ("Custom" options)

Settings on `AVFrame` level might vary depending on the option. For example, to force IDR
frame you need to set `AV_PICTURE_TYPE_I` in `AVFrame::pict_type` and make sure that forcing
of IDR is enabled for QSV encoder on initialization stage.

Settings at context level should be done in the following way:

```
int set_parameter(AVCodecContext *avctx)
{
  AVDictionary *opts = NULL;

  av_dict_set(&opts, "key", "value", 0);

  /* set common "Global" option */
  if ((ret = av_opt_set_dict(avctx, &opts)) < 0)
    goto fail;

  /* set codec specific "Custom" option */
  if ((ret = av_opt_set_dict(avctx->priv_data, &opts)) < 0)
    goto fail;
}
```

Some of the dynamic features may be triggered from the ffmpeg command line, others require
self-written application.

To encode IDR at every 50th frame:

    qsvcodec=h264_qsv|hevc_qsv
    ffmpeg <...> -force_key_frames 'expr:gte(n,n_forced*50)' -c:v $qsvcodec -forced_idr 1 -g 300 <...>

To set Region of Interest (ROI) you can use [addroi](https://ffmpeg.org/ffmpeg-filters.html#addroi) filter:

    qsvcodec=h264_qsv|hevc_qsv
    ffmpeg <...> -vf "addroi=0:0:960:540:-1/2" -c:v $qsvcodec <...>

