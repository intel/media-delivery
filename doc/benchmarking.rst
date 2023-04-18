Benchmark tools
---------------

This project comes with `performance <../measure/performance/MSPerf.py>`__ and
`quality <../measure/quality/measure-quality>`__ measuring tools which implement
measuring methodologies discussed in `performance <performance.rst>`__
and `quality <quality.rst>`__ methodology documents.

See below examples on how to run these tools.

* To evaluate quality of a given YUV file (currently tool accepts only
  8-bit I420 YUV input):

::

  measure quality -w 1920 -h 1080 -f 24 InputVideo.yuv

* To evaluate quality of MP4 file (not supported by oneVPL sample_multi_transcode,
  evaluation will be done via ffmpeg-qsv):

::

  measure quality InputVideo.mp4

* To evaluate performance raw H.264/AVC file:

::

  measure perf InputVideo.h264

By default tools will encode with H.264/AVC. To change a codec,
use a ``--codec`` option::

  measure quality --codec HEVC -w 1920 -h 1080 -f 24 InputVideo.yuv
  measure perf --codec HEVC InputVideo.h264

For detailed tools usage refer to the manual pages for
`performance <man/measure-perf.asciidoc>`__ and
`quality <man/measure-quality.asciidoc>`__. In media-delivery container
these pages are available with ``man measure-perf`` and ``man measure-quality``.

Known limitations
~~~~~~~~~~~~~~~~~

* `measure-quality <man/measure-quality.asciidoc>`__ supports only 8-bit
  I420 input YUV streams

* Intel Media SDK samples don't support input streams in container formats
  (i.e. .mp4, .ts, etc.), hence both measure-quality and measure-perf will
  run measurements only with ffmpeg-qsv path for such streams.

