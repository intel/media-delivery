# VP8 Decoding

Available from n4.0 as hwaccel path for vp8 decoder (see [40b75a9](https://github.com/FFmpeg/FFmpeg/commit/40b75a9)).

# VP8 Encoding

## Initialization options

| Feature                        | Commit ID                                                    | FFmpeg Version |
| ------------------------------ | ------------------------------------------------------------ | -------------- |
| `-c:v vp8_vaapi`               | [d1acab8](https://github.com/FFmpeg/FFmpeg/commit/d1acab8)   | n3.3           |
| `-async_depth <int>`           | [d165ce2](https://github.com/FFmpeg/FFmpeg/commit/d165ce2)   | n5.1           |
| `-b:v <int>`                   | [2efd63a](https://github.com/FFmpeg/FFmpeg/commit/2efd63a)   | n4.2           |
| `-b_depth <int>`               | [5fdcf85](https://github.com/FFmpeg/FFmpeg/commit/5fdcf85)   | n4.2           |
| `-b_qfactor <float>`           | [d1acab8](https://github.com/FFmpeg/FFmpeg/commit/d1acab8)   | n3.3           |
| `-b_qoffset <float>`           | [d1acab8](https://github.com/FFmpeg/FFmpeg/commit/d1acab8)   | n3.3           |
| `-bf <int>`                    | [d1acab8](https://github.com/FFmpeg/FFmpeg/commit/d1acab8)   | n3.3           |
| `-bufsize <int>`               | [2efd63a](https://github.com/FFmpeg/FFmpeg/commit/2efd63a)   | n4.2           |
| `-g <int>`                     | [d237b6b](https://github.com/FFmpeg/FFmpeg/commit/d237b6b)   | n4.2           |
| `-i_qfactor <float>`           | [d1acab8](https://github.com/FFmpeg/FFmpeg/commit/d1acab8)   | n3.3           |
| `-i_qoffset <float>`           | [d1acab8](https://github.com/FFmpeg/FFmpeg/commit/d1acab8)   | n3.3           |
| `-idr_interval <int>`          | [5fdcf85](https://github.com/FFmpeg/FFmpeg/commit/5fdcf85)   | n4.2           |
| `-loop_filter_level <int>`     | [d1acab8](https://github.com/FFmpeg/FFmpeg/commit/d1acab8)   | n3.3           |
| `-loop_filter_sharpness <int>` | [d1acab8](https://github.com/FFmpeg/FFmpeg/commit/d1acab8)   | n3.3           |
| `-low_power 0\|1`              | [aa2563a](https://github.com/FFmpeg/FFmpeg/commit/aa2563a)   | n4.1           |
| `-max_frame_size <int>`        | [99446c7](https://github.com/FFmpeg/FFmpeg/commit/99446c7)   | n5.1           |
| `-maxrate <int>`               | [2efd63a](https://github.com/FFmpeg/FFmpeg/commit/2efd63a)   | n4.2           |
| `-qmax <int>`                  | [8479f99c](https://github.com/FFmpeg/FFmpeg/commit/8479f99c) | n4.1           |
| `-qmin <int>`                  | [8479f99c](https://github.com/FFmpeg/FFmpeg/commit/8479f99c) | n4.1           |
| `-rc_init_occupancy <int>`     | [2efd63a](https://github.com/FFmpeg/FFmpeg/commit/2efd63a)   | n4.2           |
| `-rc_mode CQP`                 | [2efd63a](https://github.com/FFmpeg/FFmpeg/commit/2efd63a)   | n4.2           |
| `-rc_mode CBR`                 | [2efd63a](https://github.com/FFmpeg/FFmpeg/commit/2efd63a)   | n4.2           |
| `-rc_mode VBR`                 | [2efd63a](https://github.com/FFmpeg/FFmpeg/commit/2efd63a)   | n4.2           |
| `-rc_mode ICQ`                 | [2efd63a](https://github.com/FFmpeg/FFmpeg/commit/2efd63a)   | n4.2           |
| `-rc_mode QVBR`                | [2efd63a](https://github.com/FFmpeg/FFmpeg/commit/2efd63a)   | n4.2           |
| `-rc_mode AVBR`                | [2efd63a](https://github.com/FFmpeg/FFmpeg/commit/2efd63a)   | n4.2           |

## Dynamic options

These options can be applied dynamically at runtime to adjust encoder settings.

| Feature                             | Option Type | Mode | Commit ID                                                  | FFmpeg Version |
| ----------------------------------- | ------------| ---- | ---------------------------------------------------------- | -------------- |
| Forced IDR                          | Frame Type  |      | [d1acab8](https://github.com/FFmpeg/FFmpeg/commit/d1acab8) | n3.3           |
| `AV_FRAME_DATA_REGIONS_OF_INTEREST` | Frame Side Data |  | [3387147](https://github.com/FFmpeg/FFmpeg/commit/3387147) | n4.3           |

