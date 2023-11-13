# AV1 Decoding

Available from n4.4 as hwaccel path for hevc decoder (see [3308bbf](https://github.com/FFmpeg/FFmpeg/commit/3308bbf)).

# AV1 Encoding

## Initialization options

| Feature                     | Commit ID                                                  | FFmpeg Version |
| --------------------------- | ---------------------------------------------------------- | -------------- |
| `-c:v av1_vaapi`            | [3be81e3](https://github.com/FFmpeg/FFmpeg/commit/3be81e3) | n6.1           |
| `-async_depth <int>`        | [3be81e3](https://github.com/FFmpeg/FFmpeg/commit/3be81e3) | n6.1           |
| `-b:v <int>`                | [3be81e3](https://github.com/FFmpeg/FFmpeg/commit/3be81e3) | n6.1           |
| `-b_depth <int>`            | [3be81e3](https://github.com/FFmpeg/FFmpeg/commit/3be81e3) | n6.1           |
| `-b_qfactor <float>`        | [3be81e3](https://github.com/FFmpeg/FFmpeg/commit/3be81e3) | n6.1           |
| `-b_qoffset <float>`        | [3be81e3](https://github.com/FFmpeg/FFmpeg/commit/3be81e3) | n6.1           |
| `-bf <int>`                 | [3be81e3](https://github.com/FFmpeg/FFmpeg/commit/3be81e3) | n6.1           |
| `-bufsize <int>`            | [3be81e3](https://github.com/FFmpeg/FFmpeg/commit/3be81e3) | n6.1           |
| `-g <int>`                  | [3be81e3](https://github.com/FFmpeg/FFmpeg/commit/3be81e3) | n6.1           |
| `-i_qfactor <float>`        | [3be81e3](https://github.com/FFmpeg/FFmpeg/commit/3be81e3) | n6.1           |
| `-i_qoffset <float>`        | [3be81e3](https://github.com/FFmpeg/FFmpeg/commit/3be81e3) | n6.1           |
| `-idr_interval <int>`       | [3be81e3](https://github.com/FFmpeg/FFmpeg/commit/3be81e3) | n6.1           |
| `-level 2.0\|2.1\|2.2\|...` | [3be81e3](https://github.com/FFmpeg/FFmpeg/commit/3be81e3) | n6.1           |
| `-low_power 0\|1`           | [3be81e3](https://github.com/FFmpeg/FFmpeg/commit/3be81e3) | n6.1           |
| `-maxrate <int>`            | [3be81e3](https://github.com/FFmpeg/FFmpeg/commit/3be81e3) | n6.1           |
| `-qmax <int>`               | [3be81e3](https://github.com/FFmpeg/FFmpeg/commit/3be81e3) | n6.1           |
| `-qmin <int>`               | [3be81e3](https://github.com/FFmpeg/FFmpeg/commit/3be81e3) | n6.1           |
| `-qp <int>`                 | [3be81e3](https://github.com/FFmpeg/FFmpeg/commit/3be81e3) | n6.1           |
| `-rc_init_occupancy <int>`  | [3be81e3](https://github.com/FFmpeg/FFmpeg/commit/3be81e3) | n6.1           |
| `-rc_mode CQP`              | [3be81e3](https://github.com/FFmpeg/FFmpeg/commit/3be81e3) | n6.1           |
| `-rc_mode CBR`              | [3be81e3](https://github.com/FFmpeg/FFmpeg/commit/3be81e3) | n6.1           |
| `-rc_mode VBR`              | [3be81e3](https://github.com/FFmpeg/FFmpeg/commit/3be81e3) | n6.1           |
| `-rc_mode ICQ`              | [3be81e3](https://github.com/FFmpeg/FFmpeg/commit/3be81e3) | n6.1           |
| `-rc_mode QVBR`             | [3be81e3](https://github.com/FFmpeg/FFmpeg/commit/3be81e3) | n6.1           |
| `-rc_mode AVBR`             | [3be81e3](https://github.com/FFmpeg/FFmpeg/commit/3be81e3) | n6.1           |
| `-tier main`                | [3be81e3](https://github.com/FFmpeg/FFmpeg/commit/3be81e3) | n6.1           |
| `-tier high`                | [3be81e3](https://github.com/FFmpeg/FFmpeg/commit/3be81e3) | n6.1           |
| `-tiles <image_size>`       | [3be81e3](https://github.com/FFmpeg/FFmpeg/commit/3be81e3) | n6.1           |
| `-tile_groups <int>`        | [3be81e3](https://github.com/FFmpeg/FFmpeg/commit/3be81e3) | n6.1           |
| `-profile main`             | [3be81e3](https://github.com/FFmpeg/FFmpeg/commit/3be81e3) | n6.1           |
| `-profile high`             | [3be81e3](https://github.com/FFmpeg/FFmpeg/commit/3be81e3) | n6.1           |
| `-profile professional`     | [3be81e3](https://github.com/FFmpeg/FFmpeg/commit/3be81e3) | n6.1           |

## Dynamic options

These options can be applied dynamically at runtime to adjust encoder settings.

| Feature                             | Option Type | Mode | Commit ID                                                  | FFmpeg Version |
| ----------------------------------- | ------------| ---- | ---------------------------------------------------------- | -------------- |
| Forced IDR                          | Frame Type  |      | [3be81e3](https://github.com/FFmpeg/FFmpeg/commit/3be81e3) | n6.1           |
| `AV_FRAME_DATA_REGIONS_OF_INTEREST` | Frame Side Data |  | [3be81e3](https://github.com/FFmpeg/FFmpeg/commit/3be81e3) | n6.1           |

