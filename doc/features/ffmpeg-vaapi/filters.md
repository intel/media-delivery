# Deinterlace

| Feature                     | Commit ID                                                  | FFmpeg Version |
| --------------------------- | ---------------------------------------------------------- | -------------- |
| `deinterlace_vaapi`         | [359586f](https://github.com/FFmpeg/FFmpeg/commit/359586f) | n3.3           |
| `mode=bob`                  | [359586f](https://github.com/FFmpeg/FFmpeg/commit/359586f) | n3.3           |
| `mode=motion_adaptive`      | [359586f](https://github.com/FFmpeg/FFmpeg/commit/359586f) | n3.3           |
| `mode=motion_compensated`   | [359586f](https://github.com/FFmpeg/FFmpeg/commit/359586f) | n3.3           |
| `mode=weave`                | [359586f](https://github.com/FFmpeg/FFmpeg/commit/359586f) | n3.3           |
| `rate=frame`                | [bff7bec](https://github.com/FFmpeg/FFmpeg/commit/bff7bec) | n3.4           |
| `rate=field`                | [bff7bec](https://github.com/FFmpeg/FFmpeg/commit/bff7bec) | n3.4           |

# Denoise

| Feature                     | Commit ID                                                  | FFmpeg Version |
| --------------------------- | ---------------------------------------------------------- | -------------- |
| `denoise_vaapi`             | [9bba10c](https://github.com/FFmpeg/FFmpeg/commit/9bba10c) | n4.0           |
| `denoise=<int>`             | [9bba10c](https://github.com/FFmpeg/FFmpeg/commit/9bba10c) | n4.0           |

# Overlay

| Feature                     | Commit ID                                                  | FFmpeg Version |
| --------------------------- | ---------------------------------------------------------- | -------------- |
| `overlay_vaapi`             | [5164960](https://github.com/FFmpeg/FFmpeg/commit/5164960) | n5.1           |
| `alpha=<string>`            | [5164960](https://github.com/FFmpeg/FFmpeg/commit/5164960) | n5.1           |
| `x=<string>`                | [5164960](https://github.com/FFmpeg/FFmpeg/commit/5164960) | n5.1           |
| `y=<string>`                | [5164960](https://github.com/FFmpeg/FFmpeg/commit/5164960) | n5.1           |
| `w=<string>`                | [5164960](https://github.com/FFmpeg/FFmpeg/commit/5164960) | n5.1           |
| `h=<string>`                | [5164960](https://github.com/FFmpeg/FFmpeg/commit/5164960) | n5.1           |
| `eof_action=repeat`         | [916447b](https://github.com/FFmpeg/FFmpeg/commit/916447b) | n6.0           |
| `eof_action=endall`         | [916447b](https://github.com/FFmpeg/FFmpeg/commit/916447b) | n6.0           |
| `eof_action=pass`           | [916447b](https://github.com/FFmpeg/FFmpeg/commit/916447b) | n6.0           |
| `repeatlast=0\|1`           | [916447b](https://github.com/FFmpeg/FFmpeg/commit/916447b) | n6.0           |
| `shortest=0\|1`             | [916447b](https://github.com/FFmpeg/FFmpeg/commit/916447b) | n6.0           |

# Procamp

| Feature                     | Commit ID                                                  | FFmpeg Version |
| --------------------------- | ---------------------------------------------------------- | -------------- |
| `procamp_vaapi`             | [fcf5eae](https://github.com/FFmpeg/FFmpeg/commit/fcf5eae) | n4.0           |
| `brightness=<float>`        | [fcf5eae](https://github.com/FFmpeg/FFmpeg/commit/fcf5eae) | n4.0           |
| `contrast=<float>`          | [fcf5eae](https://github.com/FFmpeg/FFmpeg/commit/fcf5eae) | n4.0           |
| `hue=<float>`               | [fcf5eae](https://github.com/FFmpeg/FFmpeg/commit/fcf5eae) | n4.0           |
| `saturation=<float>`        | [fcf5eae](https://github.com/FFmpeg/FFmpeg/commit/fcf5eae) | n4.0           |

# Scale

| Feature                     | Commit ID                                                  | FFmpeg Version |
| --------------------------- | ---------------------------------------------------------- | -------------- |
| `scale_vaapi`               | [98114d7](https://github.com/FFmpeg/FFmpeg/commit/98114d7) | n3.1           |
| `force_divisible_by=<int>`  | [1b4f473](https://github.com/FFmpeg/FFmpeg/commit/1b4f473) | n4.3           |
| `force_original_aspect_ratio=disable`  | [1b4f473](https://github.com/FFmpeg/FFmpeg/commit/1b4f473) | n4.3 |
| `force_original_aspect_ratio=decrease` | [1b4f473](https://github.com/FFmpeg/FFmpeg/commit/1b4f473) | n4.3 |
| `force_original_aspect_ratio=increase` | [1b4f473](https://github.com/FFmpeg/FFmpeg/commit/1b4f473) | n4.3 |
| `format=<string>`           | [98114d7](https://github.com/FFmpeg/FFmpeg/commit/98114d7) | n3.1           |
| `h=<string>`                | [98114d7](https://github.com/FFmpeg/FFmpeg/commit/98114d7) | n3.1           |
| `w=<string>`                | [98114d7](https://github.com/FFmpeg/FFmpeg/commit/98114d7) | n3.1           |
| `mode=fast`                 | [a271025](https://github.com/FFmpeg/FFmpeg/commit/a271025) | n4.2           |
| `mode=hq`                   | [a271025](https://github.com/FFmpeg/FFmpeg/commit/a271025) | n4.2           |
| `mode=nl_anamorphic`        | [a271025](https://github.com/FFmpeg/FFmpeg/commit/a271025) | n4.2           |
| `out_color_matrix=<string>` | [ef2f89b](https://github.com/FFmpeg/FFmpeg/commit/ef2f89b) | n4.2           |
| `out_range=full`            | [ef2f89b](https://github.com/FFmpeg/FFmpeg/commit/ef2f89b) | n4.2           |
| `out_range=limited`         | [ef2f89b](https://github.com/FFmpeg/FFmpeg/commit/ef2f89b) | n4.2           |
| `out_color_primaries=<string>` | [ef2f89b](https://github.com/FFmpeg/FFmpeg/commit/ef2f89b) | n4.2        |
| `out_color_transfer=<string>`  | [ef2f89b](https://github.com/FFmpeg/FFmpeg/commit/ef2f89b) | n4.2        |
| `out_chroma_location=<string>` | [ef2f89b](https://github.com/FFmpeg/FFmpeg/commit/ef2f89b) | n4.2        |

# Sharpness

| Feature                     | Commit ID                                                  | FFmpeg Version |
| --------------------------- | ---------------------------------------------------------- | -------------- |
| `sharpness_vaapi`           | [9bba10c](https://github.com/FFmpeg/FFmpeg/commit/9bba10c) | n4.0           |
| `sharpness=<int>`           | [9bba10c](https://github.com/FFmpeg/FFmpeg/commit/9bba10c) | n4.0           |

# Stack

## HStack

| Feature                     | Commit ID                                                  | FFmpeg Version |
| --------------------------- | ---------------------------------------------------------- | -------------- |
| `hstack_vaapi`              | [aecfec6](https://github.com/FFmpeg/FFmpeg/commit/aecfec6) | n6.0           |
| `inputs=<int>`              | [aecfec6](https://github.com/FFmpeg/FFmpeg/commit/aecfec6) | n6.0           |
| `height=<int>`              | [aecfec6](https://github.com/FFmpeg/FFmpeg/commit/aecfec6) | n6.0           |
| `shortest=0\|1`             | [aecfec6](https://github.com/FFmpeg/FFmpeg/commit/aecfec6) | n6.0           |

## VStack

| Feature                     | Commit ID                                                  | FFmpeg Version |
| --------------------------- | ---------------------------------------------------------- | -------------- |
| `vstack_vaapi`              | [aecfec6](https://github.com/FFmpeg/FFmpeg/commit/aecfec6) | n6.0           |
| `inputs=<int>`              | [aecfec6](https://github.com/FFmpeg/FFmpeg/commit/aecfec6) | n6.0           |
| `shortest=0\|1`             | [aecfec6](https://github.com/FFmpeg/FFmpeg/commit/aecfec6) | n6.0           |
| `width=<int>`               | [aecfec6](https://github.com/FFmpeg/FFmpeg/commit/aecfec6) | n6.0           |

## XStack

| Feature                     | Commit ID                                                  | FFmpeg Version |
| --------------------------- | ---------------------------------------------------------- | -------------- |
| `xstack_vaapi`              | [aecfec6](https://github.com/FFmpeg/FFmpeg/commit/aecfec6) | n6.0           |
| `fill=<int>`                | [aecfec6](https://github.com/FFmpeg/FFmpeg/commit/aecfec6) | n6.0           |
| `grid=<int>`                | [aecfec6](https://github.com/FFmpeg/FFmpeg/commit/aecfec6) | n6.0           |
| `grid_tile_size=<int>`      | [aecfec6](https://github.com/FFmpeg/FFmpeg/commit/aecfec6) | n6.0           |
| `inputs=<int>`              | [aecfec6](https://github.com/FFmpeg/FFmpeg/commit/aecfec6) | n6.0           |
| `shortest=0\|1`             | [aecfec6](https://github.com/FFmpeg/FFmpeg/commit/aecfec6) | n6.0           |
| `layout=<string>`           | [aecfec6](https://github.com/FFmpeg/FFmpeg/commit/aecfec6) | n6.0           |

# Tonemap

| Feature                     | Commit ID                                                  | FFmpeg Version |
| --------------------------- | ---------------------------------------------------------- | -------------- |
| `tonemap_vaapi`             | [2e2dfe6](https://github.com/FFmpeg/FFmpeg/commit/2e2dfe6) | n4.3           |
| `format=<string>`           | [2e2dfe6](https://github.com/FFmpeg/FFmpeg/commit/2e2dfe6) | n4.3           |
| `matrix=<string>`           | [2e2dfe6](https://github.com/FFmpeg/FFmpeg/commit/2e2dfe6) | n4.3           |
| `primaries=<string>`        | [2e2dfe6](https://github.com/FFmpeg/FFmpeg/commit/2e2dfe6) | n4.3           |
| `transfer=<string>`         | [2e2dfe6](https://github.com/FFmpeg/FFmpeg/commit/2e2dfe6) | n4.3           |

# Transpose

| Feature                     | Commit ID                                                  | FFmpeg Version |
| --------------------------- | ---------------------------------------------------------- | -------------- |
| `transpose_vaapi`           | [b8ebce4](https://github.com/FFmpeg/FFmpeg/commit/b8ebce4) | n4.2           |
| `dir=cclock_flip`           | [b8ebce4](https://github.com/FFmpeg/FFmpeg/commit/b8ebce4) | n4.2           |
| `dir=clock`                 | [b8ebce4](https://github.com/FFmpeg/FFmpeg/commit/b8ebce4) | n4.2           |
| `dir=cclock`                | [b8ebce4](https://github.com/FFmpeg/FFmpeg/commit/b8ebce4) | n4.2           |
| `dir=clock_flip`            | [b8ebce4](https://github.com/FFmpeg/FFmpeg/commit/b8ebce4) | n4.2           |
| `dir=reversal`              | [b8ebce4](https://github.com/FFmpeg/FFmpeg/commit/b8ebce4) | n4.2           |
| `dir=hflip`                 | [b8ebce4](https://github.com/FFmpeg/FFmpeg/commit/b8ebce4) | n4.2           |
| `dir=vflip`                 | [b8ebce4](https://github.com/FFmpeg/FFmpeg/commit/b8ebce4) | n4.2           |
| `passthrough=none`          | [b8ebce4](https://github.com/FFmpeg/FFmpeg/commit/b8ebce4) | n4.2           |
| `passthrough=portrait`      | [b8ebce4](https://github.com/FFmpeg/FFmpeg/commit/b8ebce4) | n4.2           |
| `passthrough=landscape`     | [b8ebce4](https://github.com/FFmpeg/FFmpeg/commit/b8ebce4) | n4.2           |

