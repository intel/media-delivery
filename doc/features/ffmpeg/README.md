# Capabilities of Intel® Quick Sync Video (QSV) FFmpeg Plugins

* [AV1](./av1.md)
* [H264/AVC](./h264.md)
* [H265/HEVC](./h265.md)
* [MJPEG](./mjpeg.md)
* [MPEG2](./mpeg2.md)
* [VP9](./vp9.md)

# Media SDK and oneVPL backends

FFmpeg QSV plugins can be built against either
  [Media SDK](https://github.com/Intel-Media-SDK/MediaSDK) or
  [oneVPL](https://github.com/oneapi-src/oneVPL) libraries.
Some features might be available under one backend and not available under the
other. This documentation will point out such features (if nothing noted in feature
description - assume that it's supported under both backends).

Not all versions of ffmpeg support both backends. Refer to the table below.

| Backend   | FFmpeg versions    |
| --------- | ------------------ |
| Media SDK | n2.6+              |
| oneVPL    | [master@7158f1e](https://github.com/FFmpeg/FFmpeg/commit/7158f1e)+ |

Mind the following component versions requirements for oneVPL backend in ffmpeg-qsv:

* [oneVPL v2022.1.5](https://github.com/oneapi-src/oneVPL/releases/tag/v2022.1.5) or later
* [oneVPL GPU 22.5.2](https://github.com/oneapi-src/oneVPL-intel-gpu/releases/tag/intel-onevpl-22.5.2) or later
* [libva 2.15.0](https://github.com/intel/libva/releases/tag/2.15.0) or later
* [media-driver 22.5.2](https://github.com/intel/media-driver/releases/tag/intel-media-22.5.2) or later

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

To configure skip frames mode attach `"qsv_skip_frame"` frame metadata:

    filter="[0:v]trim=start_frame=0:end_frame=100,setpts=PTS-STARTPTS[v0];"
    filter+="[0:v]trim=start_frame=100:end_frame=200,setpts=PTS-STARTPTS[v1];"
    filter+="[0:v]trim=start_frame=200:end_frame=300,setpts=PTS-STARTPTS[v2];"
    filter+="[v1]metadata=mode=add:key=qsv_skip_frame:value=1[v1m];"
    filter+="[v0][v1m][v2]concat=n=3:v=1"

    qsvcodec=h264_qsv|hevc_qsv
    skip_mode=no_skip|insert_dummy|insert_nothing|brc_only

    ffmpeg <...> -filter_complex "$filter" -c:v $qsvcodec -skip_frame $skip_mode output.264

