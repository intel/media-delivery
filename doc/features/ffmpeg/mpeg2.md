# MPEG2 Decoding

| Feature                     | Commit ID                                                                                   | FFmpeg Version |
| --------------------------- | ------------------------------------------------------------------------------------------- | -------------- |
| `-c:v mpeg2_qsv`            | [bf52f77](https://github.com/FFmpeg/FFmpeg/commit/bf52f773913cf74bdf0d2c8c2cb4473fa1b7801e) | n2.8           |
| `-async_depth <int>`        | [bf52f77](https://github.com/FFmpeg/FFmpeg/commit/bf52f773913cf74bdf0d2c8c2cb4473fa1b7801e) | n2.8           |
| `-extra_hw_frames <int>`    | [5b14529](https://github.com/FFmpeg/FFmpeg/commit/5b145290df2998a9836a93eb925289c6c8b63af0) | n4.0           |
| `-gpu_copy 0\|1\|2`         | [5345965](https://github.com/FFmpeg/FFmpeg/commit/5345965b3f088ad5acd5151bec421c97470675a4) | n4.3           |

# MPEG2 Encoding

| Feature                     | Commit ID                                                                                   | FFmpeg Version |
| --------------------------- | ------------------------------------------------------------------------------------------- | -------------- |
| `-c:v mpeg2_qsv`            | [3a85397](https://github.com/FFmpeg/FFmpeg/commit/3a85397e8bb477eb34678d9edc52893f57003226) | n2.8           |
| `-adaptive_b 0\|1`          | | not supported |
| `-adaptive_i 0\|1`          | | not supported |
| `-async_depth <int>`        | [3a85397](https://github.com/FFmpeg/FFmpeg/commit/3a85397e8bb477eb34678d9edc52893f57003226) | n2.8           |
| `-avbr_accuracy <int>`      | [3a85397](https://github.com/FFmpeg/FFmpeg/commit/3a85397e8bb477eb34678d9edc52893f57003226) | n2.8           |
| `-avbr_convergence <int>`   | [3a85397](https://github.com/FFmpeg/FFmpeg/commit/3a85397e8bb477eb34678d9edc52893f57003226) | n2.8           |
| `-b:v <int>`                | [3a85397](https://github.com/FFmpeg/FFmpeg/commit/3a85397e8bb477eb34678d9edc52893f57003226) | n2.8           |
| `-b_strategy <int>`         | | not supported |
| `-b_qfactor <float>`        | [3a85397](https://github.com/FFmpeg/FFmpeg/commit/3a85397e8bb477eb34678d9edc52893f57003226) | n2.8           |
| `-b_qoffset <float>`        | [3a85397](https://github.com/FFmpeg/FFmpeg/commit/3a85397e8bb477eb34678d9edc52893f57003226) | n2.8           |
| `-bf <int>`                 | [3a85397](https://github.com/FFmpeg/FFmpeg/commit/3a85397e8bb477eb34678d9edc52893f57003226) | n2.8           |
| `-bitrate_limit <int>`      | | not supported |
| `-bufsize <int>`            | [6ff2934](https://github.com/FFmpeg/FFmpeg/commit/6ff29343b01923e9b125fe7404ac8701cdfb1fe5) | n4.0           |
| `-dblk_idc 0\|1\|2`         | | not supported |
| `-extbrc -1\|0\|1`          | | not supported |
| `-forced_idr 0\|1`          | [ac0bcd6](https://github.com/FFmpeg/FFmpeg/commit/ac0bcd6b619479d56612b3938e8f00f5b88c0f10) | n4.2           |
| `-g <int>`                  | [3a85397](https://github.com/FFmpeg/FFmpeg/commit/3a85397e8bb477eb34678d9edc52893f57003226) | n2.8           |
| `-global_quality <int>`     | [e7d7cf8](https://github.com/FFmpeg/FFmpeg/commit/e7d7cf86dcaba8eaaed62c80172ff0aff2588c2a) | n3.0           |
| `-i_qfactor <float>`        | [3a85397](https://github.com/FFmpeg/FFmpeg/commit/3a85397e8bb477eb34678d9edc52893f57003226) | n2.8           |
| `-i_qoffset <float>`        | [3a85397](https://github.com/FFmpeg/FFmpeg/commit/3a85397e8bb477eb34678d9edc52893f57003226) | n2.8           |
| `-low_power 0\|1`           | [a8355ee](https://github.com/FFmpeg/FFmpeg/commit/a8355eed3699acffebb70e1b939989d39b72dfc7) | n4.2           |
| `-low_delay_brc 0\|1`       | | not supported |
| `-max_frame_size <int>`     | | not supported |
| `-max_frame_size_i <int>`   | | not supported |
| `-max_frame_size_p <int>`   | | not supported |
| `-max_slice_size <int>`     | | not supported |
| `-maxrate <int>`            | [f3fbe79](https://github.com/FFmpeg/FFmpeg/commit/f3fbe790d9d4e93b2ec8c7476572f2d155e8b43e) | n2.8           |
| `-mbbrc -1\|0\|1`           | | not supported |
| `-preset veryfast`          | [9c35b8e](https://github.com/FFmpeg/FFmpeg/commit/9c35b8e219549c81e9a73a9b5a38be36b9c98181) | n3.0           |
| `-preset faster`            | [9c35b8e](https://github.com/FFmpeg/FFmpeg/commit/9c35b8e219549c81e9a73a9b5a38be36b9c98181) | n3.0           |
| `-preset fast`              | [3a85397](https://github.com/FFmpeg/FFmpeg/commit/3a85397e8bb477eb34678d9edc52893f57003226) | n2.8           |
| `-preset medium`            | [3a85397](https://github.com/FFmpeg/FFmpeg/commit/3a85397e8bb477eb34678d9edc52893f57003226) | n2.8           |
| `-preset slow`              | [3a85397](https://github.com/FFmpeg/FFmpeg/commit/3a85397e8bb477eb34678d9edc52893f57003226) | n2.8           |
| `-preset slower`            | [9c35b8e](https://github.com/FFmpeg/FFmpeg/commit/9c35b8e219549c81e9a73a9b5a38be36b9c98181) | n3.0           |
| `-preset veryslow`          | [9c35b8e](https://github.com/FFmpeg/FFmpeg/commit/9c35b8e219549c81e9a73a9b5a38be36b9c98181) | n3.0           |
| `-profile unknown\|simple\|main\|high` | [3a85397](https://github.com/FFmpeg/FFmpeg/commit/3a85397e8bb477eb34678d9edc52893f57003226) | n2.8 |
| `-p_strategy 0\|1\|2`       | | not supported |
| `-q <int>`                  | [e7d7cf8](https://github.com/FFmpeg/FFmpeg/commit/e7d7cf86dcaba8eaaed62c80172ff0aff2588c2a) | n3.0           |
| `-qmax <int>`               | | not supported |
| `-qmin <int>`               | | not supported |
| `-rc_init_occupancy <int>`  | [3a85397](https://github.com/FFmpeg/FFmpeg/commit/3a85397e8bb477eb34678d9edc52893f57003226) | n2.8           |
| `-refs <int>`               | [3a85397](https://github.com/FFmpeg/FFmpeg/commit/3a85397e8bb477eb34678d9edc52893f57003226) | n2.8           |
| `-rdo -1\|0\|1`             | [fc4c27c](https://github.com/FFmpeg/FFmpeg/commit/fc4c27c4edfc6a5f9bc7c696e823652474a65ce8) | n3.0           |
| `-strict <int>`             | | not supported |

