# VP9 Decoding

Available from n3.0 as hwaccel path for vp9 decoder (see [d7c2b75](https://github.com/FFmpeg/FFmpeg/commit/d7c2b75)).

# VP9 Encoding

## Initialization options

| Feature                     | Commit ID                                                  | FFmpeg Version |
| --------------------------- | ---------------------------------------------------------- | -------------- |
| `-c:v vp9_vaapi`            | [bde0460](https://github.com/FFmpeg/FFmpeg/commit/bde0460) | n3.4           |
| `-async_depth <int>`        | [d165ce2](https://github.com/FFmpeg/FFmpeg/commit/d165ce2) | n5.1           |
| `-b:v <int>`                | [28e619e](https://github.com/FFmpeg/FFmpeg/commit/28e619e) | n4.2           |
| `-b_depth <int>`            | [5fdcf85](https://github.com/FFmpeg/FFmpeg/commit/5fdcf85) | n4.2           |
| `-b_qfactor <float>`        | [bde0460](https://github.com/FFmpeg/FFmpeg/commit/bde0460) | n3.4           |
| `-b_qoffset <float>`        | [bde0460](https://github.com/FFmpeg/FFmpeg/commit/bde0460) | n3.4           |
| `-bf <int>`                 | [bde0460](https://github.com/FFmpeg/FFmpeg/commit/bde0460) | n3.4           |
| `-bufsize <int>`            | [28e619e](https://github.com/FFmpeg/FFmpeg/commit/28e619e) | n4.2           |
| `-g <int>`                  | [d237b6b](https://github.com/FFmpeg/FFmpeg/commit/d237b6b) | n4.2           |
| `-i_qfactor <float>`        | [bde0460](https://github.com/FFmpeg/FFmpeg/commit/bde0460) | n3.4           |
| `-i_qoffset <float>`        | [bde0460](https://github.com/FFmpeg/FFmpeg/commit/bde0460) | n3.4           |
| `-idr_interval <int>`       | [5fdcf85](https://github.com/FFmpeg/FFmpeg/commit/5fdcf85) | n4.2           |
| `-loop_filter_level <int>`  | [bde0460](https://github.com/FFmpeg/FFmpeg/commit/bde0460) | n3.4           |
| `-loop_filter_sharpness <int>` | [bde0460](https://github.com/FFmpeg/FFmpeg/commit/bde0460) | n3.4        |
| `-low_power 0\|1`           | [aa2563a](https://github.com/FFmpeg/FFmpeg/commit/aa2563a) | n4.1           |
| `-max_frame_size <int>`     | [99446c7](https://github.com/FFmpeg/FFmpeg/commit/99446c7) | n5.1           |
| `-maxrate <int>`            | [28e619e](https://github.com/FFmpeg/FFmpeg/commit/28e619e) | n4.2           |
| `-qmax <int>`               | [8479f99](https://github.com/FFmpeg/FFmpeg/commit/8479f99) | n4.1           |
| `-qmin <int>`               | [8479f99](https://github.com/FFmpeg/FFmpeg/commit/8479f99) | n4.1           |
| `-rc_init_occupancy <int>`  | [28e619e](https://github.com/FFmpeg/FFmpeg/commit/28e619e) | n4.2           |
| `-rc_mode CQP`              | [28e619e](https://github.com/FFmpeg/FFmpeg/commit/28e619e) | n4.2           |
| `-rc_mode CBR`              | [28e619e](https://github.com/FFmpeg/FFmpeg/commit/28e619e) | n4.2           |
| `-rc_mode VBR`              | [28e619e](https://github.com/FFmpeg/FFmpeg/commit/28e619e) | n4.2           |
| `-rc_mode ICQ`              | [28e619e](https://github.com/FFmpeg/FFmpeg/commit/28e619e) | n4.2           |
| `-rc_mode QVBR`             | [28e619e](https://github.com/FFmpeg/FFmpeg/commit/28e619e) | n4.2           |
| `-rc_mode AVBR`             | [28e619e](https://github.com/FFmpeg/FFmpeg/commit/28e619e) | n4.2           |

## Dynamic options 

These options can be applied dynamically at runtime to adjust encoder settings.

| Feature                             | Option Type | Mode | Commit ID                                                  | FFmpeg Version |
| ----------------------------------- | ------------| ---- | ---------------------------------------------------------- | -------------- |
| Forced IDR                          | Frame Type  |      | [bde0460](https://github.com/FFmpeg/FFmpeg/commit/bde0460) | n3.4           |
| `AV_FRAME_DATA_REGIONS_OF_INTEREST` | Frame Side Data |  | [3387147](https://github.com/FFmpeg/FFmpeg/commit/3387147) | n4.3           |

