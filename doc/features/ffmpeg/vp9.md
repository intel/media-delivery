# VP9 Decoding

| Feature                     | Commit ID                                                                                   | FFmpeg Version |
| --------------------------- | ------------------------------------------------------------------------------------------- | -------------- |
| `-c:v vp9_qsv`              | [655ff47](https://github.com/FFmpeg/FFmpeg/commit/655ff4708bfe160447b07d0cbae6b710666f0139) | n4.3           |
| `-async_depth <int>`        | [655ff47](https://github.com/FFmpeg/FFmpeg/commit/655ff4708bfe160447b07d0cbae6b710666f0139) | n4.3           |
| `-extra_hw_frames <int>`    | [655ff47](https://github.com/FFmpeg/FFmpeg/commit/655ff4708bfe160447b07d0cbae6b710666f0139) | n4.3           |
| `-gpu_copy 0\|1\|2`         | [5345965](https://github.com/FFmpeg/FFmpeg/commit/5345965b3f088ad5acd5151bec421c97470675a4) | n4.3           |

# VP9 Encoding

| Feature                     | Commit ID                                                                                   | FFmpeg Version |
| --------------------------- | ------------------------------------------------------------------------------------------- | -------------- |
| `-c:v vp9_qsv`              | [3358380](https://github.com/FFmpeg/FFmpeg/commit/33583803e107b6d532def0f9d949364b01b6ad5a) | n4.3           |
| `-adaptive_b -1\|0\|1`      | | not supported  |
| `-adaptive_i -1\|0\|1`      | | not supported  |
| `-async_depth <int>`        | [fcbfdee](https://github.com/FFmpeg/FFmpeg/commit/fcbfdeeabe21cb0925313dab6079c50318a7bc71) | n4.3           |
| `-avbr_accuracy <int>`      | [a5b6e29](https://github.com/FFmpeg/FFmpeg/commit/a5b6e292271f18d309389e7672e362332dc7dd7c) | n4.3-n5.1      |
| `-avbr_convergence <int>`   | [a5b6e29](https://github.com/FFmpeg/FFmpeg/commit/a5b6e292271f18d309389e7672e362332dc7dd7c) | n4.3-n5.1      |
| `-b:v <int>`                | [fcbfdee](https://github.com/FFmpeg/FFmpeg/commit/fcbfdeeabe21cb0925313dab6079c50318a7bc71) | n4.3           |
| `-b_strategy <int>`         | | not supported  |
| `-b_qfactor <float>`        | [fcbfdee](https://github.com/FFmpeg/FFmpeg/commit/fcbfdeeabe21cb0925313dab6079c50318a7bc71) | n4.3           |
| `-b_qoffset <float>`        | [fcbfdee](https://github.com/FFmpeg/FFmpeg/commit/fcbfdeeabe21cb0925313dab6079c50318a7bc71) | n4.3           |
| `-bitrate_limit <int>`      | | not supported  |
| `-bufsize <int>`            | [fcbfdee](https://github.com/FFmpeg/FFmpeg/commit/fcbfdeeabe21cb0925313dab6079c50318a7bc71) | n4.3           |
| `-dblk_idc 0\|1\|2`         | | not supported  |
| `-extbrc -1\|0\|1`          | | not supported  |
| `-forced_idr 0\|1`          | [fcbfdee](https://github.com/FFmpeg/FFmpeg/commit/fcbfdeeabe21cb0925313dab6079c50318a7bc71) | n4.3           |
| `-g <int>`                  | [fcbfdee](https://github.com/FFmpeg/FFmpeg/commit/fcbfdeeabe21cb0925313dab6079c50318a7bc71) | n4.3           |
| `-global_quality <int>`     | [fcbfdee](https://github.com/FFmpeg/FFmpeg/commit/fcbfdeeabe21cb0925313dab6079c50318a7bc71) | n4.3           |
| `-i_qfactor <float>`        | [fcbfdee](https://github.com/FFmpeg/FFmpeg/commit/fcbfdeeabe21cb0925313dab6079c50318a7bc71) | n4.3           |
| `-i_qoffset <float>`        | [fcbfdee](https://github.com/FFmpeg/FFmpeg/commit/fcbfdeeabe21cb0925313dab6079c50318a7bc71) | n4.3           |
| `-low_delay_brc 0\|1`       | | not supported  |
| `-low_power 0\|1`           | [fcbfdee](https://github.com/FFmpeg/FFmpeg/commit/fcbfdeeabe21cb0925313dab6079c50318a7bc71) | n4.3           |
| `-max_frame_size <int>`     | | not supported  |
| `-max_frame_size_i <int>`   | | not supported  |
| `-max_frame_size_p <int>`   | | not supported  |
| `-max_slice_size <int>`     | | not supported  |
| `-maxrate <int>`            | [fcbfdee](https://github.com/FFmpeg/FFmpeg/commit/fcbfdeeabe21cb0925313dab6079c50318a7bc71) | n4.3           |
| `-mbbrc -1\|0\|1`           | | not supported  |
| `-p_strategy 0\|1\|2`       | | not supported  |
| `-preset veryfast`          | [fcbfdee](https://github.com/FFmpeg/FFmpeg/commit/fcbfdeeabe21cb0925313dab6079c50318a7bc71) | n4.3           |
| `-preset faster`            | [fcbfdee](https://github.com/FFmpeg/FFmpeg/commit/fcbfdeeabe21cb0925313dab6079c50318a7bc71) | n4.3           |
| `-preset fast`              | [fcbfdee](https://github.com/FFmpeg/FFmpeg/commit/fcbfdeeabe21cb0925313dab6079c50318a7bc71) | n4.3           |
| `-preset medium`            | [fcbfdee](https://github.com/FFmpeg/FFmpeg/commit/fcbfdeeabe21cb0925313dab6079c50318a7bc71) | n4.3           |
| `-preset slow`              | [fcbfdee](https://github.com/FFmpeg/FFmpeg/commit/fcbfdeeabe21cb0925313dab6079c50318a7bc71) | n4.3           |
| `-preset slower`            | [fcbfdee](https://github.com/FFmpeg/FFmpeg/commit/fcbfdeeabe21cb0925313dab6079c50318a7bc71) | n4.3           |
| `-preset veryslow`          | [fcbfdee](https://github.com/FFmpeg/FFmpeg/commit/fcbfdeeabe21cb0925313dab6079c50318a7bc71) | n4.3           |
| `-profile unknown`          | [fcbfdee](https://github.com/FFmpeg/FFmpeg/commit/fcbfdeeabe21cb0925313dab6079c50318a7bc71) | n4.3           |
| `-profile profile0`         | [fcbfdee](https://github.com/FFmpeg/FFmpeg/commit/fcbfdeeabe21cb0925313dab6079c50318a7bc71) | n4.3           |
| `-profile profile1`         | [fcbfdee](https://github.com/FFmpeg/FFmpeg/commit/fcbfdeeabe21cb0925313dab6079c50318a7bc71) | n4.3           |
| `-profile profile2`         | [fcbfdee](https://github.com/FFmpeg/FFmpeg/commit/fcbfdeeabe21cb0925313dab6079c50318a7bc71) | n4.3           |
| `-profile profile3`         | [fcbfdee](https://github.com/FFmpeg/FFmpeg/commit/fcbfdeeabe21cb0925313dab6079c50318a7bc71) | n4.3           |
| `-q <int>`                  | [fcbfdee](https://github.com/FFmpeg/FFmpeg/commit/fcbfdeeabe21cb0925313dab6079c50318a7bc71) | n4.3           |
| `-rc_init_occupancy <int>`  | [3358380](https://github.com/FFmpeg/FFmpeg/commit/33583803e107b6d532def0f9d949364b01b6ad5a) | n4.3           |
| `-rdo -1\|0\|1`             | | not supported |
| `-refs <int>`               | [fcbfdee](https://github.com/FFmpeg/FFmpeg/commit/fcbfdeeabe21cb0925313dab6079c50318a7bc71) | n4.3           |
| `-tile_cols <int>`          | [80801e5](https://github.com/FFmpeg/FFmpeg/commit/80801e570566976195f515216de4403cdcf4f7a3) | n5.1           |
| `-tile_rows <int>`          | [80801e5](https://github.com/FFmpeg/FFmpeg/commit/80801e570566976195f515216de4403cdcf4f7a3) | n5.1           |
| `-strict <int>`             | | not supported |

Notes:

* AVBR options (`-avbr_accuracy` and `-avbr_convergence`) were formally exposed in ffmpeg versions n4.3-n5.1, but
  later were clarified as not supported by underlying VPL/MSDK runtime

