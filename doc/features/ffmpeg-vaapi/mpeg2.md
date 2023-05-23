# MPEG2 Decoding

Available from n0.10 as hwaccel path for mpeg2 decoder (see [3c32bac](https://github.com/FFmpeg/FFmpeg/commit/3c32bac)).

# MPEG2 Encoding

## Initialization options

| Feature                     | Commit ID                                                  | FFmpeg Version |
| --------------------------- | ---------------------------------------------------------- | -------------- |
| `-c:v mpeg2_vaapi`          | [ca6ae3b](https://github.com/FFmpeg/FFmpeg/commit/ca6ae3b) | n3.4           |
| `-async_depth <int>`        | [d165ce2](https://github.com/FFmpeg/FFmpeg/commit/d165ce2) | n5.1           |
| `-b:v <int>`                | [1e0fac7](https://github.com/FFmpeg/FFmpeg/commit/1e0fac7) | n4.2           |
| `-b_depth <int>`            | [95f6f7b](https://github.com/FFmpeg/FFmpeg/commit/95f6f7b) | n4.1           |
| `-b_qfactor <float>`        | [ca6ae3b](https://github.com/FFmpeg/FFmpeg/commit/ca6ae3b) | n3.4           |
| `-b_qoffset <float>`        | [ca6ae3b](https://github.com/FFmpeg/FFmpeg/commit/ca6ae3b) | n3.4           |
| `-bf <int>`                 | [ca6ae3b](https://github.com/FFmpeg/FFmpeg/commit/ca6ae3b) | n3.4           |
| `-bufsize <int>`            | [1e0fac7](https://github.com/FFmpeg/FFmpeg/commit/1e0fac7) | n4.2           |
| `-g <int>`                  | [ca6ae3b](https://github.com/FFmpeg/FFmpeg/commit/ca6ae3b) | n3.4           |
| `-i_qfactor <float>`        | [ca6ae3b](https://github.com/FFmpeg/FFmpeg/commit/ca6ae3b) | n3.4           |
| `-i_qoffset <float>`        | [ca6ae3b](https://github.com/FFmpeg/FFmpeg/commit/ca6ae3b) | n3.4           |
| `-idr_interval <int>`       | [95f6f7b](https://github.com/FFmpeg/FFmpeg/commit/95f6f7b) | n4.1           |
| `-level low`                | [95f6f7b](https://github.com/FFmpeg/FFmpeg/commit/95f6f7b) | n4.1           |
| `-level main`               | [95f6f7b](https://github.com/FFmpeg/FFmpeg/commit/95f6f7b) | n4.1           |
| `-level high`               | [95f6f7b](https://github.com/FFmpeg/FFmpeg/commit/95f6f7b) | n4.1           |
| `-level high_1440`          | [95f6f7b](https://github.com/FFmpeg/FFmpeg/commit/95f6f7b) | n4.1           |
| `-low_power 0\|1`           | [95f6f7b](https://github.com/FFmpeg/FFmpeg/commit/95f6f7b) | n4.1           |
| `-max_frame_size <int>`     | [95f6f7b](https://github.com/FFmpeg/FFmpeg/commit/95f6f7b) | n4.1           |
| `-maxrate <int>`            | [1e0fac7](https://github.com/FFmpeg/FFmpeg/commit/1e0fac7) | n4.2           |
| `-qmax <int>`               | [8479f99](https://github.com/FFmpeg/FFmpeg/commit/8479f99) | n4.1           |
| `-qmin <int>`               | [8479f99](https://github.com/FFmpeg/FFmpeg/commit/8479f99) | n4.1           |
| `-qp <int>`                 | [1e0fac7](https://github.com/FFmpeg/FFmpeg/commit/1e0fac7) | n4.2           |
| `-rc_init_occupancy <int>`  | [1e0fac7](https://github.com/FFmpeg/FFmpeg/commit/1e0fac7) | n4.2           |
| `-rc_mode CQP`              | [1e0fac7](https://github.com/FFmpeg/FFmpeg/commit/1e0fac7) | n4.2           |
| `-rc_mode CBR`              | [1e0fac7](https://github.com/FFmpeg/FFmpeg/commit/1e0fac7) | n4.2           |
| `-rc_mode VBR`              | [1e0fac7](https://github.com/FFmpeg/FFmpeg/commit/1e0fac7) | n4.2           |
| `-rc_mode ICQ`              | [1e0fac7](https://github.com/FFmpeg/FFmpeg/commit/1e0fac7) | n4.2           |
| `-rc_mode QVBR`             | [1e0fac7](https://github.com/FFmpeg/FFmpeg/commit/1e0fac7) | n4.2           |
| `-rc_moed AVBR`             | [1e0fac7](https://github.com/FFmpeg/FFmpeg/commit/1e0fac7) | n4.2           |
| `-profile simple`           | [95f6f7b](https://github.com/FFmpeg/FFmpeg/commit/95f6f7b) | n4.1           |
| `-profile main`             | [95f6f7b](https://github.com/FFmpeg/FFmpeg/commit/95f6f7b) | n4.1           |

## Dynamic options 

These options can be applied dynamically at runtime to adjust encoder settings.

| Feature                             | Option Type | Mode | Commit ID                                                  | FFmpeg Version |
| ----------------------------------- | ------------| ---- | ---------------------------------------------------------- | -------------- |
| Forced IDR                          | Frame Type  |      | [ca6ae3b](https://github.com/FFmpeg/FFmpeg/commit/ca6ae3b) | n3.4           |
| `AV_FRAME_DATA_REGIONS_OF_INTEREST` | Frame Side Data |  | [3387147](https://github.com/FFmpeg/FFmpeg/commit/3387147) | n4.3           |

