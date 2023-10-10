# AV1 Decoding

Available from n4.4 as hwaccel path for hevc decoder (see [3308bbf](https://github.com/FFmpeg/FFmpeg/commit/3308bbf)).

# AV1 Encoding

## Initialization options

| Feature                     | Commit ID                                                  | FFmpeg Version |
| --------------------------- | ---------------------------------------------------------- | -------------- |
| `-c:v av1_vaapi`            | [3be81e3](https://github.com/FFmpeg/FFmpeg/commit/3be81e3) | master         |
| `-async_depth <int>`        | [3be81e3](https://github.com/FFmpeg/FFmpeg/commit/3be81e3) | master         |
| `-b:v <int>`                | [3be81e3](https://github.com/FFmpeg/FFmpeg/commit/3be81e3) | master         |
| `-b_depth <int>`            | [3be81e3](https://github.com/FFmpeg/FFmpeg/commit/3be81e3) | master         |
| `-b_qfactor <float>`        | [3be81e3](https://github.com/FFmpeg/FFmpeg/commit/3be81e3) | master         |
| `-b_qoffset <float>`        | [3be81e3](https://github.com/FFmpeg/FFmpeg/commit/3be81e3) | master         |
| `-bf <int>`                 | [3be81e3](https://github.com/FFmpeg/FFmpeg/commit/3be81e3) | master         |
| `-bufsize <int>`            | [3be81e3](https://github.com/FFmpeg/FFmpeg/commit/3be81e3) | master         |
| `-g <int>`                  | [3be81e3](https://github.com/FFmpeg/FFmpeg/commit/3be81e3) | master         |
| `-i_qfactor <float>`        | [3be81e3](https://github.com/FFmpeg/FFmpeg/commit/3be81e3) | master         |
| `-i_qoffset <float>`        | [3be81e3](https://github.com/FFmpeg/FFmpeg/commit/3be81e3) | master         |
| `-idr_interval <int>`       | [3be81e3](https://github.com/FFmpeg/FFmpeg/commit/3be81e3) | master         |
| `-level 2.0\|2.1\|2.2\|...` | [3be81e3](https://github.com/FFmpeg/FFmpeg/commit/3be81e3) | master         |
| `-low_power 0\|1`           | [3be81e3](https://github.com/FFmpeg/FFmpeg/commit/3be81e3) | master         |
| `-maxrate <int>`            | [3be81e3](https://github.com/FFmpeg/FFmpeg/commit/3be81e3) | master         |
| `-qmax <int>`               | [3be81e3](https://github.com/FFmpeg/FFmpeg/commit/3be81e3) | master         |
| `-qmin <int>`               | [3be81e3](https://github.com/FFmpeg/FFmpeg/commit/3be81e3) | master         |
| `-qp <int>`                 | [3be81e3](https://github.com/FFmpeg/FFmpeg/commit/3be81e3) | master         |
| `-rc_init_occupancy <int>`  | [3be81e3](https://github.com/FFmpeg/FFmpeg/commit/3be81e3) | master         |
| `-rc_mode CQP`              | [3be81e3](https://github.com/FFmpeg/FFmpeg/commit/3be81e3) | master         |
| `-rc_mode CBR`              | [3be81e3](https://github.com/FFmpeg/FFmpeg/commit/3be81e3) | master         |
| `-rc_mode VBR`              | [3be81e3](https://github.com/FFmpeg/FFmpeg/commit/3be81e3) | master         |
| `-rc_mode ICQ`              | [3be81e3](https://github.com/FFmpeg/FFmpeg/commit/3be81e3) | master         |
| `-rc_mode QVBR`             | [3be81e3](https://github.com/FFmpeg/FFmpeg/commit/3be81e3) | master         |
| `-rc_mode AVBR`             | [3be81e3](https://github.com/FFmpeg/FFmpeg/commit/3be81e3) | master         |
| `-tier main`                | [3be81e3](https://github.com/FFmpeg/FFmpeg/commit/3be81e3) | master         |
| `-tier high`                | [3be81e3](https://github.com/FFmpeg/FFmpeg/commit/3be81e3) | master         |
| `-tiles <image_size>`       | [3be81e3](https://github.com/FFmpeg/FFmpeg/commit/3be81e3) | master         |
| `-tile_groups <int>`        | [3be81e3](https://github.com/FFmpeg/FFmpeg/commit/3be81e3) | master         |
| `-profile main`             | [3be81e3](https://github.com/FFmpeg/FFmpeg/commit/3be81e3) | master         |
| `-profile high`             | [3be81e3](https://github.com/FFmpeg/FFmpeg/commit/3be81e3) | master         |
| `-profile professional`     | [3be81e3](https://github.com/FFmpeg/FFmpeg/commit/3be81e3) | master         |

## Dynamic options

These options can be applied dynamically at runtime to adjust encoder settings.

| Feature                             | Option Type | Mode | Commit ID                                                  | FFmpeg Version |
| ----------------------------------- | ------------| ---- | ---------------------------------------------------------- | -------------- |
| Forced IDR                          | Frame Type  |      | [3be81e3](https://github.com/FFmpeg/FFmpeg/commit/3be81e3) | master         |
| `AV_FRAME_DATA_REGIONS_OF_INTEREST` | Frame Side Data |  | [3be81e3](https://github.com/FFmpeg/FFmpeg/commit/3be81e3) | master         |

