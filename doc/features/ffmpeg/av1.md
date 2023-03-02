# AV1 Decoding

| Feature                     | Commit ID                                                                                   | FFmpeg Version |
| --------------------------- | ------------------------------------------------------------------------------------------- | -------------- |
| `AVFilmGrainParams`         | [8ca06a8](https://github.com/FFmpeg/FFmpeg/commit/8ca06a8148db1b5e8394b2941790fcae29a84f46) | n5.1           |
| `-c:v av1_qsv`              | [cc25ae5](https://github.com/FFmpeg/FFmpeg/commit/cc25ae5d8ad2cef2dc8a21b828e89e5077b9dae3) | n4.4           |
| `-async_depth <int>`        | [cc25ae5](https://github.com/FFmpeg/FFmpeg/commit/cc25ae5d8ad2cef2dc8a21b828e89e5077b9dae3) | n4.4           |
| `-extra_hw_frames <int>`    | [5b14529](https://github.com/FFmpeg/FFmpeg/commit/5b145290df2998a9836a93eb925289c6c8b63af0) | n4.0           |
| `-gpu_copy 0\|1\|2`         | [cc25ae5](https://github.com/FFmpeg/FFmpeg/commit/cc25ae5d8ad2cef2dc8a21b828e89e5077b9dae3) | n4.4           |


# AV1 Encoding

Recommended version of VPL runtime is [intel-onevpl-22.6.0](https://github.com/oneapi-src/oneVPL-intel-gpu/releases/tag/intel-onevpl-22.6.0)
or later. Earlier versions also support AV1, but the following patches were missing:

* [19d0fc9](https://github.com/oneapi-src/oneVPL-intel-gpu/commit/19d0fc9) Open source av1 enctools
* [dc7fd15](https://github.com/oneapi-src/oneVPL-intel-gpu/commit/dc7fd15) Output entire temporal unit for AV1 

| Feature                     | Commit ID                                                                                   | FFmpeg Version |
| --------------------------- | ------------------------------------------------------------------------------------------- | -------------- |
| `-c:v av1_qsv`              | [dc9e478](https://github.com/FFmpeg/FFmpeg/commit/dc9e4789a3b504c08c8cd24e990aa692dde50bc6) | n6.0           |
| `-adaptive_b -1\|0\|1`      | [dc9e478](https://github.com/FFmpeg/FFmpeg/commit/dc9e4789a3b504c08c8cd24e990aa692dde50bc6) | n6.0           |
| `-adaptive_i -1\|0\|1`      | [dc9e478](https://github.com/FFmpeg/FFmpeg/commit/dc9e4789a3b504c08c8cd24e990aa692dde50bc6) | n6.0           |
| `-async_depth <int>`        | [dc9e478](https://github.com/FFmpeg/FFmpeg/commit/dc9e4789a3b504c08c8cd24e990aa692dde50bc6) | n6.0           |
| `-avbr_accuracy <int>`      | | not supported |
| `-avbr_convergence <int>`   | | not supported |
| `-b:v <int>`                | [dc9e478](https://github.com/FFmpeg/FFmpeg/commit/dc9e4789a3b504c08c8cd24e990aa692dde50bc6) | n6.0           |
| `-b_strategy <int>`         | [dc9e478](https://github.com/FFmpeg/FFmpeg/commit/dc9e4789a3b504c08c8cd24e990aa692dde50bc6) | n6.0           |
| `-b_qfactor <float>`        | [dc9e478](https://github.com/FFmpeg/FFmpeg/commit/dc9e4789a3b504c08c8cd24e990aa692dde50bc6) | n6.0           |
| `-b_qoffset <float>`        | [dc9e478](https://github.com/FFmpeg/FFmpeg/commit/dc9e4789a3b504c08c8cd24e990aa692dde50bc6) | n6.0           |
| `-bitrate_limit <int>`      | | not supported |
| `-bufsize <int>`            | [dc9e478](https://github.com/FFmpeg/FFmpeg/commit/dc9e4789a3b504c08c8cd24e990aa692dde50bc6) | n6.0           |
| `-dblk_idc 0\|1\|2`         | | not supported |
| `-extbrc -1\|0\|1`          | [dc9e478](https://github.com/FFmpeg/FFmpeg/commit/dc9e4789a3b504c08c8cd24e990aa692dde50bc6) | n6.0           |
| `-forced_idr 0\|1`          | [dc9e478](https://github.com/FFmpeg/FFmpeg/commit/dc9e4789a3b504c08c8cd24e990aa692dde50bc6) | n6.0           |
| `-g <int>`                  | [dc9e478](https://github.com/FFmpeg/FFmpeg/commit/dc9e4789a3b504c08c8cd24e990aa692dde50bc6) | n6.0           |
| `-global_quality <int>`     | [dc9e478](https://github.com/FFmpeg/FFmpeg/commit/dc9e4789a3b504c08c8cd24e990aa692dde50bc6) | n6.0           |
| `-i_qfactor <float>`        | [dc9e478](https://github.com/FFmpeg/FFmpeg/commit/dc9e4789a3b504c08c8cd24e990aa692dde50bc6) | n6.0           |
| `-i_qoffset <float>`        | [dc9e478](https://github.com/FFmpeg/FFmpeg/commit/dc9e4789a3b504c08c8cd24e990aa692dde50bc6) | n6.0           |
| `-look_ahead_depth <int>`   | [dc9e478](https://github.com/FFmpeg/FFmpeg/commit/dc9e4789a3b504c08c8cd24e990aa692dde50bc6) | n6.0           |
| `-low_delay_brc 0\|1`       | [c8e7355](https://github.com/FFmpeg/FFmpeg/commit/c8e73558fe0181a0b3e611f486bb8bc308af24b4) | n6.0           |
| `-low_power 0\|1`           | [dc9e478](https://github.com/FFmpeg/FFmpeg/commit/dc9e4789a3b504c08c8cd24e990aa692dde50bc6) | n6.0           |
| `-max_frame_size <int>`     | [13d04e3](https://github.com/FFmpeg/FFmpeg/commit/13d04e30d7753811176e154a2828bf054a9a846a) | n6.0           |
| `-max_frame_size_i <int>`   | | not supported |
| `-max_frame_size_p <int>`   | | not supported |
| `-max_slice_size <int>`     | | not supported |
| `-maxrate <int>`            | [dc9e478](https://github.com/FFmpeg/FFmpeg/commit/dc9e4789a3b504c08c8cd24e990aa692dde50bc6) | n6.0           |
| `-mbbrc -1\|0\|1`           | | not supported |
| `-p_strategy 0\|1\|2`       | | not supported |
| `-preset veryfast`          | [dc9e478](https://github.com/FFmpeg/FFmpeg/commit/dc9e4789a3b504c08c8cd24e990aa692dde50bc6) | n6.0           |
| `-preset faster`            | [dc9e478](https://github.com/FFmpeg/FFmpeg/commit/dc9e4789a3b504c08c8cd24e990aa692dde50bc6) | n6.0           |
| `-preset fast`              | [dc9e478](https://github.com/FFmpeg/FFmpeg/commit/dc9e4789a3b504c08c8cd24e990aa692dde50bc6) | n6.0           |
| `-preset medium`            | [dc9e478](https://github.com/FFmpeg/FFmpeg/commit/dc9e4789a3b504c08c8cd24e990aa692dde50bc6) | n6.0           |
| `-preset slow`              | [dc9e478](https://github.com/FFmpeg/FFmpeg/commit/dc9e4789a3b504c08c8cd24e990aa692dde50bc6) | n6.0           |
| `-preset slower`            | [dc9e478](https://github.com/FFmpeg/FFmpeg/commit/dc9e4789a3b504c08c8cd24e990aa692dde50bc6) | n6.0           |
| `-preset veryslow`          | [dc9e478](https://github.com/FFmpeg/FFmpeg/commit/dc9e4789a3b504c08c8cd24e990aa692dde50bc6) | n6.0           |
| `-profile unknown`          | [dc9e478](https://github.com/FFmpeg/FFmpeg/commit/dc9e4789a3b504c08c8cd24e990aa692dde50bc6) | n6.0           |
| `-profile main`             | [dc9e478](https://github.com/FFmpeg/FFmpeg/commit/dc9e4789a3b504c08c8cd24e990aa692dde50bc6) | n6.0           |
| `-q <int>`                  | [dc9e478](https://github.com/FFmpeg/FFmpeg/commit/dc9e4789a3b504c08c8cd24e990aa692dde50bc6) | n6.0           |
| `-rc_init_occupancy <int>`  | [dc9e478](https://github.com/FFmpeg/FFmpeg/commit/dc9e4789a3b504c08c8cd24e990aa692dde50bc6) | n6.0           |
| `-rdo -1\|0\|1`             | | not supported |
| `-refs <int>`               | [dc9e478](https://github.com/FFmpeg/FFmpeg/commit/dc9e4789a3b504c08c8cd24e990aa692dde50bc6) | n6.0           |
| `-strict <int>`             | | not supported |
| `-tile_cols <int>`          | [dc9e478](https://github.com/FFmpeg/FFmpeg/commit/dc9e4789a3b504c08c8cd24e990aa692dde50bc6) | n6.0           |
| `-tile_rows <int>`          | [dc9e478](https://github.com/FFmpeg/FFmpeg/commit/dc9e4789a3b504c08c8cd24e990aa692dde50bc6) | n6.0           |

## Dynamic options

These options can be applied dynamically at runtime to adjust encoder settings.

| Feature                             | Option Type | Mode | Commit ID                                                  | FFmpeg Version |
| ----------------------------------- | ------------| ---- | ---------------------------------------------------------- | -------------- |
| Forced IDR                          | Frame Type  |      | [dc9e478](https://github.com/FFmpeg/FFmpeg/commit/dc9e478) | n6.0           |
| `bit_rate`                          | Global      |      | [dc9e478](https://github.com/FFmpeg/FFmpeg/commit/dc9e478) | n6.0           |
| `framerate`                         | Global      |      | [dc9e478](https://github.com/FFmpeg/FFmpeg/commit/dc9e478) | n6.0           |
| `gop_size`                          | Global      |      | [dc9e478](https://github.com/FFmpeg/FFmpeg/commit/dc9e478) | n6.0           |
| `rc_buffer_size`                    | Global      |      | [dc9e478](https://github.com/FFmpeg/FFmpeg/commit/dc9e478) | n6.0           |
| `rc_initial_buffer_occupancy`       | Global      |      | [dc9e478](https://github.com/FFmpeg/FFmpeg/commit/dc9e478) | n6.0           |
| `rc_max_rate`                       | Global      |      | [dc9e478](https://github.com/FFmpeg/FFmpeg/commit/dc9e478) | n6.0           |

