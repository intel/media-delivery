# AV1 Decoding

| Feature                     | Commit ID                                                                                   | FFmpeg Version |
| --------------------------- | ------------------------------------------------------------------------------------------- | -------------- |
| `AVFilmGrainParams`         | [8ca06a8](https://github.com/FFmpeg/FFmpeg/commit/8ca06a8148db1b5e8394b2941790fcae29a84f46) | n5.1           |
| `-c:v av1_qsv`              | [cc25ae5](https://github.com/FFmpeg/FFmpeg/commit/cc25ae5d8ad2cef2dc8a21b828e89e5077b9dae3) | n4.4           |
| `-async_depth <int>`        | [cc25ae5](https://github.com/FFmpeg/FFmpeg/commit/cc25ae5d8ad2cef2dc8a21b828e89e5077b9dae3) | n4.4           |
| `-extra_hw_frames <int>`    | [5b14529](https://github.com/FFmpeg/FFmpeg/commit/5b145290df2998a9836a93eb925289c6c8b63af0) | n4.0           |
| `-gpu_copy 0\|1\|2`         | [cc25ae5](https://github.com/FFmpeg/FFmpeg/commit/cc25ae5d8ad2cef2dc8a21b828e89e5077b9dae3) | n4.4           |


# AV1 Encoding

Not supported by upstream ffmpeg yet. Required patches are available here:

* https://github.com/intel-media-ci/cartwheel-ffmpeg

QSV AV1 encoder requires ffmpeg built against [oneVPL](https://github.com/oneapi-src/oneVPL) library.

The following table corresponds to [cartwheel-ffmpeg@53a3f44](https://github.com/intel-media-ci/cartwheel-ffmpeg/commit/53a3f442436c471afef579c81965a2f47a675be4).

| Feature                     | Commit ID                                                                                   | FFmpeg Version |
| --------------------------- | ------------------------------------------------------------------------------------------- | -------------- |
| `-c:v av1_qsv`              | 0058-libavcodec-qsvenc_av1-add-av1_qsv-encoder.patch | patched |
| `-adaptive_b -1\|0\|1`      | | not supported |
| `-adaptive_i -1\|0\|1`      | | not supported |
| `-async_depth <int>`        | 0058-libavcodec-qsvenc_av1-add-av1_qsv-encoder.patch | patched |
| `-avbr_accuracy <int>`      | 0058-libavcodec-qsvenc_av1-add-av1_qsv-encoder.patch | patched |
| `-avbr_convergence <int>`   | 0058-libavcodec-qsvenc_av1-add-av1_qsv-encoder.patch | patched |
| `-b:v <int>`                | 0058-libavcodec-qsvenc_av1-add-av1_qsv-encoder.patch | patched |
| `-b_strategy <int>`         | 0058-libavcodec-qsvenc_av1-add-av1_qsv-encoder.patch | patched |
| `-b_qfactor <float>`        | 0058-libavcodec-qsvenc_av1-add-av1_qsv-encoder.patch | patched |
| `-b_qoffset <float>`        | 0058-libavcodec-qsvenc_av1-add-av1_qsv-encoder.patch | patched |
| `-bitrate_limit <int>`      | | not supported |
| `-bufsize <int>`            | 0058-libavcodec-qsvenc_av1-add-av1_qsv-encoder.patch | patched |
| `-dblk_idc 0\|1\|2`         | | not supported |
| `-extbrc -1\|0\|1`          | | not supported |
| `-forced_idr 0\|1`          | 0058-libavcodec-qsvenc_av1-add-av1_qsv-encoder.patch | patched |
| `-g <int>`                  | 0058-libavcodec-qsvenc_av1-add-av1_qsv-encoder.patch | patched |
| `-global_quality <int>`     | 0058-libavcodec-qsvenc_av1-add-av1_qsv-encoder.patch | patched |
| `-i_qfactor <float>`        | 0058-libavcodec-qsvenc_av1-add-av1_qsv-encoder.patch | patched |
| `-i_qoffset <float>`        | 0058-libavcodec-qsvenc_av1-add-av1_qsv-encoder.patch | patched |
| `-low_delay_brc 0\|1`       | | not supported |
| `-low_power 0\|1`           | 0058-libavcodec-qsvenc_av1-add-av1_qsv-encoder.patch | patched |
| `-max_frame_size <int>`     | | not supported |
| `-max_frame_size_i <int>`   | | not supported |
| `-max_frame_size_p <int>`   | | not supported |
| `-max_slice_size <int>`     | | not supported |
| `-maxrate <int>`            | 0058-libavcodec-qsvenc_av1-add-av1_qsv-encoder.patch | patched |
| `-mbbrc -1\|0\|1`           | | not supported |
| `-p_strategy 0\|1\|2`       | | not supported |
| `-preset veryfast`          | 0058-libavcodec-qsvenc_av1-add-av1_qsv-encoder.patch | patched |
| `-preset faster`            | 0058-libavcodec-qsvenc_av1-add-av1_qsv-encoder.patch | patched |
| `-preset fast`              | 0058-libavcodec-qsvenc_av1-add-av1_qsv-encoder.patch | patched |
| `-preset medium`            | 0058-libavcodec-qsvenc_av1-add-av1_qsv-encoder.patch | patched |
| `-preset slow`              | 0058-libavcodec-qsvenc_av1-add-av1_qsv-encoder.patch | patched |
| `-preset slower`            | 0058-libavcodec-qsvenc_av1-add-av1_qsv-encoder.patch | patched |
| `-preset veryslow`          | 0058-libavcodec-qsvenc_av1-add-av1_qsv-encoder.patch | patched |
| `-profile unknown`          | 0058-libavcodec-qsvenc_av1-add-av1_qsv-encoder.patch | patched |
| `-profile main`             | 0058-libavcodec-qsvenc_av1-add-av1_qsv-encoder.patch | patched |
| `-q <int>`                  | 0058-libavcodec-qsvenc_av1-add-av1_qsv-encoder.patch | patched |
| `-rc_init_occupancy <int>`  | 0058-libavcodec-qsvenc_av1-add-av1_qsv-encoder.patch | patched |
| `-rdo -1\|0\|1`             | | not supported |
| `-refs <int>`               | 0058-libavcodec-qsvenc_av1-add-av1_qsv-encoder.patch | patched |
| `-strict <int>`             | | not supported |
| `-tile_cols <int>`          | 0058-libavcodec-qsvenc_av1-add-av1_qsv-encoder.patch | patched |
| `-tile_rows <int>`          | 0058-libavcodec-qsvenc_av1-add-av1_qsv-encoder.patch | patched |
