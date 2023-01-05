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
| `-c:v av1_qsv`              | [dc9e478](https://github.com/FFmpeg/FFmpeg/commit/dc9e4789a3b504c08c8cd24e990aa692dde50bc6) | master         |
| `-adaptive_b -1\|0\|1`      | [dc9e478](https://github.com/FFmpeg/FFmpeg/commit/dc9e4789a3b504c08c8cd24e990aa692dde50bc6) | master         |
| `-adaptive_i -1\|0\|1`      | [dc9e478](https://github.com/FFmpeg/FFmpeg/commit/dc9e4789a3b504c08c8cd24e990aa692dde50bc6) | master         |
| `-async_depth <int>`        | [dc9e478](https://github.com/FFmpeg/FFmpeg/commit/dc9e4789a3b504c08c8cd24e990aa692dde50bc6) | master         |
| `-avbr_accuracy <int>`      | | not supported |
| `-avbr_convergence <int>`   | | not supported |
| `-b:v <int>`                | [dc9e478](https://github.com/FFmpeg/FFmpeg/commit/dc9e4789a3b504c08c8cd24e990aa692dde50bc6) | master         |
| `-b_strategy <int>`         | [dc9e478](https://github.com/FFmpeg/FFmpeg/commit/dc9e4789a3b504c08c8cd24e990aa692dde50bc6) | master         |
| `-b_qfactor <float>`        | [dc9e478](https://github.com/FFmpeg/FFmpeg/commit/dc9e4789a3b504c08c8cd24e990aa692dde50bc6) | master         |
| `-b_qoffset <float>`        | [dc9e478](https://github.com/FFmpeg/FFmpeg/commit/dc9e4789a3b504c08c8cd24e990aa692dde50bc6) | master         |
| `-bitrate_limit <int>`      | | not supported |
| `-bufsize <int>`            | [dc9e478](https://github.com/FFmpeg/FFmpeg/commit/dc9e4789a3b504c08c8cd24e990aa692dde50bc6) | master         |
| `-dblk_idc 0\|1\|2`         | | not supported |
| `-extbrc -1\|0\|1`          | [dc9e478](https://github.com/FFmpeg/FFmpeg/commit/dc9e4789a3b504c08c8cd24e990aa692dde50bc6) | master         |
| `-forced_idr 0\|1`          | [dc9e478](https://github.com/FFmpeg/FFmpeg/commit/dc9e4789a3b504c08c8cd24e990aa692dde50bc6) | master         |
| `-g <int>`                  | [dc9e478](https://github.com/FFmpeg/FFmpeg/commit/dc9e4789a3b504c08c8cd24e990aa692dde50bc6) | master         |
| `-global_quality <int>`     | [dc9e478](https://github.com/FFmpeg/FFmpeg/commit/dc9e4789a3b504c08c8cd24e990aa692dde50bc6) | master         |
| `-i_qfactor <float>`        | [dc9e478](https://github.com/FFmpeg/FFmpeg/commit/dc9e4789a3b504c08c8cd24e990aa692dde50bc6) | master         |
| `-i_qoffset <float>`        | [dc9e478](https://github.com/FFmpeg/FFmpeg/commit/dc9e4789a3b504c08c8cd24e990aa692dde50bc6) | master         |
| `-look_ahead_depth <int>`   | [dc9e478](https://github.com/FFmpeg/FFmpeg/commit/dc9e4789a3b504c08c8cd24e990aa692dde50bc6) | master         |
| `-low_delay_brc 0\|1`       | | not supported |
| `-low_power 0\|1`           | [dc9e478](https://github.com/FFmpeg/FFmpeg/commit/dc9e4789a3b504c08c8cd24e990aa692dde50bc6) | master         |
| `-max_frame_size <int>`     | | not supported |
| `-max_frame_size_i <int>`   | | not supported |
| `-max_frame_size_p <int>`   | | not supported |
| `-max_slice_size <int>`     | | not supported |
| `-maxrate <int>`            | [dc9e478](https://github.com/FFmpeg/FFmpeg/commit/dc9e4789a3b504c08c8cd24e990aa692dde50bc6) | master         |
| `-mbbrc -1\|0\|1`           | | not supported |
| `-p_strategy 0\|1\|2`       | | not supported |
| `-preset veryfast`          | [dc9e478](https://github.com/FFmpeg/FFmpeg/commit/dc9e4789a3b504c08c8cd24e990aa692dde50bc6) | master         |
| `-preset faster`            | [dc9e478](https://github.com/FFmpeg/FFmpeg/commit/dc9e4789a3b504c08c8cd24e990aa692dde50bc6) | master         |
| `-preset fast`              | [dc9e478](https://github.com/FFmpeg/FFmpeg/commit/dc9e4789a3b504c08c8cd24e990aa692dde50bc6) | master         |
| `-preset medium`            | [dc9e478](https://github.com/FFmpeg/FFmpeg/commit/dc9e4789a3b504c08c8cd24e990aa692dde50bc6) | master         |
| `-preset slow`              | [dc9e478](https://github.com/FFmpeg/FFmpeg/commit/dc9e4789a3b504c08c8cd24e990aa692dde50bc6) | master         |
| `-preset slower`            | [dc9e478](https://github.com/FFmpeg/FFmpeg/commit/dc9e4789a3b504c08c8cd24e990aa692dde50bc6) | master         |
| `-preset veryslow`          | [dc9e478](https://github.com/FFmpeg/FFmpeg/commit/dc9e4789a3b504c08c8cd24e990aa692dde50bc6) | master         |
| `-profile unknown`          | [dc9e478](https://github.com/FFmpeg/FFmpeg/commit/dc9e4789a3b504c08c8cd24e990aa692dde50bc6) | master         |
| `-profile main`             | [dc9e478](https://github.com/FFmpeg/FFmpeg/commit/dc9e4789a3b504c08c8cd24e990aa692dde50bc6) | master         |
| `-q <int>`                  | [dc9e478](https://github.com/FFmpeg/FFmpeg/commit/dc9e4789a3b504c08c8cd24e990aa692dde50bc6) | master         |
| `-rc_init_occupancy <int>`  | [dc9e478](https://github.com/FFmpeg/FFmpeg/commit/dc9e4789a3b504c08c8cd24e990aa692dde50bc6) | master         |
| `-rdo -1\|0\|1`             | | not supported |
| `-refs <int>`               | [dc9e478](https://github.com/FFmpeg/FFmpeg/commit/dc9e4789a3b504c08c8cd24e990aa692dde50bc6) | master         |
| `-strict <int>`             | | not supported |
| `-tile_cols <int>`          | [dc9e478](https://github.com/FFmpeg/FFmpeg/commit/dc9e4789a3b504c08c8cd24e990aa692dde50bc6) | master         |
| `-tile_rows <int>`          | [dc9e478](https://github.com/FFmpeg/FFmpeg/commit/dc9e4789a3b504c08c8cd24e990aa692dde50bc6) | master         |

## Dynamic options

These options can be applied dynamically at runtime to adjust encoder settings.

| Feature                             | Option Type | Mode | Commit ID                                                  | FFmpeg Version |
| ----------------------------------- | ------------| ---- | ---------------------------------------------------------- | -------------- |
| Forced IDR                          | Frame Type  |      | [dc9e478](https://github.com/FFmpeg/FFmpeg/commit/dc9e478) | master         |
| `bit_rate`                          | Global      |      | [dc9e478](https://github.com/FFmpeg/FFmpeg/commit/dc9e478) | master         |
| `framerate`                         | Global      |      | [dc9e478](https://github.com/FFmpeg/FFmpeg/commit/dc9e478) | master         |
| `gop_size`                          | Global      |      | [dc9e478](https://github.com/FFmpeg/FFmpeg/commit/dc9e478) | master         |
| `rc_buffer_size`                    | Global      |      | [dc9e478](https://github.com/FFmpeg/FFmpeg/commit/dc9e478) | master         |
| `rc_initial_buffer_occupancy`       | Global      |      | [dc9e478](https://github.com/FFmpeg/FFmpeg/commit/dc9e478) | master         |
| `rc_max_rate`                       | Global      |      | [dc9e478](https://github.com/FFmpeg/FFmpeg/commit/dc9e478) | master         |

