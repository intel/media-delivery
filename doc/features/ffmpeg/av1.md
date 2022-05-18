# AV1 Decoding

| Feature                     | Commit ID                                                                                   | FFmpeg Version |
| --------------------------- | ------------------------------------------------------------------------------------------- | -------------- |
| `AVFilmGrainParams`         | [8ca06a8](https://github.com/FFmpeg/FFmpeg/commit/8ca06a8148db1b5e8394b2941790fcae29a84f46) | master         |
| `-c:v av1_qsv`              | [cc25ae5](https://github.com/FFmpeg/FFmpeg/commit/cc25ae5d8ad2cef2dc8a21b828e89e5077b9dae3) | n4.4           |
| `-async_depth <int>`        | [cc25ae5](https://github.com/FFmpeg/FFmpeg/commit/cc25ae5d8ad2cef2dc8a21b828e89e5077b9dae3) | n4.4           |
| `-gpu_copy 0\|1\|2`         | [cc25ae5](https://github.com/FFmpeg/FFmpeg/commit/cc25ae5d8ad2cef2dc8a21b828e89e5077b9dae3) | n4.4           |


# AV1 Encoding

Not supported by upstream ffmpeg yet. Required patches are available here:

* https://github.com/intel-media-ci/cartwheel-ffmpeg

