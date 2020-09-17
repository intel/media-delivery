Media Delivery Software Stack
=============================

.. contents::

Overview
--------

This project provides samples to demonstrate the use of Intel GPU in
simplified real-life scenarios involving media streams delivery. It
leverages a Software Stack which consists of the following ingredients:

* `Intel Media SDK <https://github.com/Intel-Media-SDK/MediaSDK>`_
* `Intel Media Driver <https://github.com/intel/media-driver>`_
* `FFmpeg <http://ffmpeg.org/>`_ w/ enabled `ffmpeg-qsv <https://trac.ffmpeg.org/wiki/Hardware/QuickSync>`_
  plugins

Provided samples focus on the key aspects of the proper Intel software
setup and integration with other popular tools you will likely use in
your final product. We try to do our best to provide a configuration which
will demonstrate the best quality and performance for Intel GPU media stack.

Key topcis we are covering:

* Samples which demonstrate operations typical for Content Delivery Network (CDN)
  applications such as Video On Demand (VOD) streaming under Nginx server
* Reference command lines (for ffmpeg-qsv and mediasdk native samples) tuned
  for the optimal quality and performance (for the showcasing scenario)
* Quality and Performance measuring infrastructure for data collection
* Intel GPU Performance monitoring

Host requirements
-----------------

To run these samples you need to:

1. Have a system with enabled Intel GPU card supported by Intel media driver
   (refer to https://github.com/intel/media-driver documentation for the list of
   supported GPUs)
2. Run Linux OS with up-to-date Linux kernel supporting underlying Intel GPU
3. Have installed and configured Docker (see `instructions <https://docs.docker.com/install/>`_)

Other than that you might wish to install some tools on your host (or some other
system capable of reaching the container over network) to be able to interact with the
service(s) running inside the container. Consider having on a host the following:

1. `VLC player <https://www.videolan.org/vlc/index.html>`_ to be able to play streaming
   videos
2. `ffmpeg <http://ffmpeg.org/>`_ to be able to receive and save streaming videos

How to get?
-----------

**Hint:** to install a docker refer to Docker install
`instructions <https://docs.docker.com/install/>`_.

Each sample is available in a form of `Docker <https://docker.com>`_ container
which you need to build locally. To build default sample (`CDN`_) run::

  docker build \
    $(env | grep -E '(_proxy=|_PROXY)' | sed 's/^/--build-arg /') \
    --file docker/ubuntu20.04/intel-gfx/Dockerfile \
    --tag intel-media-delivery \
    .

Use ``--build-arg SAMPLE=$SAMPLE`` docker build argument to specify other
sample to build.

There are few dockerfiles you can use to build the same sample. They differ
by origin of some components included into the docker image.

* `docker/ubuntu20.04/native/Dockerfile <docker/ubuntu20.04/native/Dockerfile>`_ - Intel media stack
  is installed from Ubuntu distro packages

* `docker/ubuntu20.04/intel-gfx/Dockerfile <docker/ubuntu20.04/intel-gfx/Dockerfile>`_ - Intel media stack
  is installed from `Intel Graphics Package Repository <https://dgpu-docs.intel.com/>`_

Going with `Intel Graphics Package Repository <https://dgpu-docs.intel.com/>`_ would
usually allow to fetch the most recent package versions.

Above dockerfiles are being generated from `m4 <https://www.gnu.org/software/m4/>`_
templates via `cmake <https://cmake.org/>`_ build system. Refer to
`generating dockerfiles <doc/docker.rst>`_ document for further details.

How to run?
-----------

Each sample contains few entrypoints:

1. ``demo`` allows to run a demo (mind ``demo help`` and ``man demo``)
2. ``measure`` allows to run a measurement tools (mind ``measure help`` and
   ``man measure``)

To be able to run container successfully you need to start it with certain
permissions allowing access to GPU device(s), file system, etc. The minimal
set of arguments to start a container looks as follows::

  DEVICE=${DEVICE:-/dev/dri/renderD128}
  DEVICE_GRP=$(ls -g $DEVICE | awk '{print $3}' | \
    xargs getent group | awk -F: '{print $3}')
  docker run --rm -it \
    -e DEVICE=$DEVICE --device $DEVICE --group-add $DEVICE_GRP \
    --cap-add SYS_ADMIN \
    -p 8080:8080 \
    intel-media-delivery

Mind that ``-e DEVICE=$DEVICE`` option allows to adjust the host GPU device
to be used under the demo.

Run without entrypoint (as in the example above) to enter shell and look around
inside the container. For example, samples come with the `manual pages <doc/man/readme.rst>`_
which you might review::

  # docker run .... # start container
  # man demo
  # man measure

Please, refer to `Samples HowTo <doc/howto.rst>`_ for the advanced topics like which
host folders you can map and how to do that correctly.

Content Delivery Network (CDN) Samples
--------------------------------------

CDN is about delivering media streams to the clients. As such, samples consist of 2
parts:

1. Service(s) running inside the container which produces and distributes media
   stream(s)
2. Client(s) running somewhere (not neccessarily inside the container)
   which consume media streams

To get list of streams you will be able to play, execute::

  DEVICE=${DEVICE:-/dev/dri/renderD128}
  DEVICE_GRP=$(ls -g $DEVICE | awk '{print $3}' | \
    xargs getent group | awk -F: '{print $3}')
  docker run --rm -it \
    -e DEVICE=$DEVICE --device $DEVICE --group-add $DEVICE_GRP \
    --cap-add SYS_ADMIN \
    -p 8080:8080 \
    intel-media-delivery demo streams

On the output you should get list of streams similar to the following::

  http://localhost:8080/vod/avc/WAR_TRAILER_HiQ_10_withAudio/index.m3u8
  http://localhost:8080/vod/hevc/WAR_TRAILER_HiQ_10_withAudio/index.m3u8

These streams can be supplied as an input to the demo command lines
described below. Mind however that HEVC streaming miпht not be supported by
some client applications, for example, web browsers.

If you want to run a client on some other system rather than host, make sure
to substituite ``localhost`` with the host IP address::

  http://<host-ip>:8080/vod/avc/WAR_TRAILER_HiQ_10_withAudio/index.m3u8

Above example just lists content embedded in the container on the build stage.
See `Content Attribution`_ for the copyright info of the embedded video. See
`Container volumes (adding your content, access logs, etc.) <doc/howto.rst#container-volumes-adding-your-content-access-logs-etc>`_
for how to add your own content to the demo.

You can run samples in different modes depending on where client is
located. These modes comes with slightly different levels of complexity - see
below paragraphs for mode details.

Default demo mode
~~~~~~~~~~~~~~~~~

In a default demo mode client is ran inside the container. As such, you don't need
to interact with the container in any other way rather than to start and stop it.
This is the simplest demo mode. To run it, execute::

  DEVICE=${DEVICE:-/dev/dri/renderD128}
  DEVICE_GRP=$(ls -g $DEVICE | awk '{print $3}' | \
    xargs getent group | awk -F: '{print $3}')
  docker run --rm -it \
    -e DEVICE=$DEVICE --device $DEVICE --group-add $DEVICE_GRP \
    --cap-add SYS_ADMIN \
    -p 8080:8080 \
    intel-media-delivery \
    demo http://localhost:8080/vod/avc/WAR_TRAILER_HiQ_10_withAudio/index.m3u8

Upon successful launch you will see output similar to the below one.

.. image:: doc/pic/demo-ffmpeg.png
   :width: 50%

Few terminals will be opened in a tiled layout and provide the following information:

1. /top-left/ Client monitoring statistics (how many clients are running and/or stopped, their FPS, etc.)
2. /top-right/ GPU monitoring data (GPU engines utilization)
3. /bottom-right/ Server monitoring statistics (how many requests server received, running FPS, etc.)
4. /bottom-left/ CPU and system monitroing data (CPU and memory utilization, tasks running, etc.)

Tiled terminals are managed by `tmux <https://github.com/tmux/tmux>`_. Please, refer to
its documentation if you wish to navigate and play around with the demo. To
terminate, just press CTRL+C and CTRL+D repreatedly to stop and exit each
script and/or monitoring process.

Interactive demo mode
~~~~~~~~~~~~~~~~~~~~~

With "interactive" demo mode container runs all the services required for streaming, but
awaits for the user interaction to trigger it. To start demo in this mode, execute::

  DEVICE=${DEVICE:-/dev/dri/renderD128}
  DEVICE_GRP=$(ls -g $DEVICE | awk '{print $3}' \
    xargs getent group | awk -F: '{print $3}')
  docker run --rm -it \
    -e DEVICE=$DEVICE --device $DEVICE --group-add $DEVICE_GRP \
    --cap-add SYS_ADMIN \
    -p 8080:8080 \
    intel-media-delivery demo

After that you need to trigger streaming via some client running outside of the
container. For example, from the host::

  vlc http://localhost:8080/vod/avc/WAR_TRAILER_HiQ_10_withAudio/index.m3u8
  # or
  ffmpeg -i http://localhost:8080/vod/avc/WAR_TRAILER_HiQ_10_withAudio/index.m3u8 -c copy WAR_TRAILER_HiQ_10_withAudio.mkv

**Note**: use ``<host-ip>`` instead of ``loсalhost`` starting client on a
system other than host.

Similar to `default demo mode`_ described above, container will start few
terminals, but eventually no client statistics will be available since client
is running elsewhere.
  
Available CDN samples and their architectures
---------------------------------------------

CDN
~~~

This sample can be built with ``--build-arg SAMPLE=cdn`` which is the default.

"CDN" sample uses ffmpeg to generate HLS stream which is better scalable approach
comparing to an alternative to use Nginx `RTMP module <https://github.com/arut/nginx-rtmp-module>`_.
(we provide `Edge`_ sample for this alternative approach). See "CDN" sample architecture
diagram below.

.. image:: doc/pic/cdn-demo-architecture.png

Sample focus on the very basics to configure HLS streaming thru nginx server.
Client requests are served on the same system where nginx server is running
by trivial `socat <http://www.dest-unreach.org/socat/>`_ server which performs
shell script scheduling of background processes to handle transcoding. Increasing
number of parallel client requests (for different streams) would allow to explore
how system behaves under different loads. Mind that you can use ``-<n>`` demo
option to emulate multiple streams available for streaming::

  DEVICE=${DEVICE:-/dev/dri/renderD128}
  DEVICE_GRP=$(ls -g $DEVICE | awk '{print $3}' \
    xargs getent group | awk -F: '{print $3}')
  docker run --rm -it \
    -e DEVICE=$DEVICE --device $DEVICE --group-add $DEVICE_GRP \
    --cap-add SYS_ADMIN \
    -p 8080:8080 \
    intel-media-delivery demo -4 \
      http://localhost:8080/vod/avc/WAR_TRAILER_HiQ_10_withAudio-1/index.m3u8
      http://localhost:8080/vod/avc/WAR_TRAILER_HiQ_10_withAudio-2/index.m3u8
      http://localhost:8080/vod/avc/WAR_TRAILER_HiQ_10_withAudio-3/index.m3u8
      http://localhost:8080/vod/avc/WAR_TRAILER_HiQ_10_withAudio-4/index.m3u8

"CDN" sample can be further scaled. For example, transcoding requests might be served
by the dedicated system where server similar to socat one is running.
Furthermore, each transcoding might be done on the dedicated GPU-capbale system
(a node). Typically, such tools like kafka and zookeeper are being used to
manage these many nodes and orchestration server. This sample however intentionally
avoids scaling examples and focuses on streaming configuration basics and key aspects
of GPU accelerated offloads. For the bigger scale CDN sample, please, take a look on
Open Visual Cloud `CDN Transcode Sample <https://github.com/OpenVisualCloud/CDN-Transcode-Sample>`_.

Edge
~~~~

This sample can be built with ``--build-arg SAMPLE=edge``.

"Edge" sample is using Nginx `RTMP module <https://github.com/arut/nginx-rtmp-module>`_
to generate HLS stream. FFmpeg is still used to transcode the stream, but it
does not produce HLS stream. Instead it sends transcoded stream to RTMP
server which actually breaks the stream into fragments and creates HLS
stream. One of the downsides of using RTMP module is that it has limited
codec capabilities. Specifically, as of now H.265 video is not supported.
See "Edge" sample architecture diagram below.

.. image:: doc/pic/edge-demo-architecture.png

Effectively, commands lines to try Edge sample are similar to CDN sample.
For example::

  DEVICE=${DEVICE:-/dev/dri/renderD128}
  DEVICE_GRP=$(ls -g $DEVICE | awk '{print $3}' \
    xargs getent group | awk -F: '{print $3}')
  docker run --rm -it \
    -e DEVICE=$DEVICE --device $DEVICE --group-add $DEVICE_GRP \
    --cap-add SYS_ADMIN \
    -p 8080:8080 \
    intel-media-delivery demo -4 \
      http://localhost:8080/vod/avc/WAR_TRAILER_HiQ_10_withAudio-1/index.m3u8
      http://localhost:8080/vod/avc/WAR_TRAILER_HiQ_10_withAudio-2/index.m3u8
      http://localhost:8080/vod/avc/WAR_TRAILER_HiQ_10_withAudio-3/index.m3u8
      http://localhost:8080/vod/avc/WAR_TRAILER_HiQ_10_withAudio-4/index.m3u8

How to run measuring tools?
---------------------------

This project comes with `performance <measure/performance/MSPerf.py>`_ and
`quality <measure/quality/measure-quality>`_ measuring tools which implement
measuring methodologies discussed in `performance <doc/performance.rst>`_
and `quality <doc/quality.rst>`_ methodology documents.

Running these tools is as simply as the following examples.

* For encoding quality measurement of some YUV file (currently tool accepts
  only 8-bit I420 YUV input):

::

  measure quality -w 1920 -h 1080 -f 24 InputVideo.yuv

* For encoding quality measurement of some MP4 file:

::

  measure quality InputVideo.mp4

* For performance measurement of transcoding of some raw H.264/AVC file:

::

  measure perf InputVideo.h264

By default measuring tools will encode with H.264/AVC, to change a codec,
use a ``--codec`` option::

  measure quality --codec HEVC -w 1920 -h 1080 -f 24 InputVideo.yuv
  measure perf --codec HEVC InputVideo.h264

For detailed tools usage refer to the manual pages for
`performance <doc/man/measure-perf.asciidoc>`_ and
`quality <doc/man/measure-quality.asciidoc>`_.

Known limitations
~~~~~~~~~~~~~~~~~

* `measure-quality <doc/man/measure-quality.asciidoc>`_ supports only 8-bit
  I420 input YUV streams

* Intel Media SDK samples don't support input streams in container formats
  (i.e. .mp4, .ts, etc.), hence both measure-quality and measure-perf will
  run measurements only with ffmpeg-qsv path for such streams.

Tips for best performance
-------------------------

Ffmpeg is easy to use and flexible in supporting many video transcode pipelines. The
ffmpeg command lines below illustrate good practices in using
`ffmpeg-qsv <https://trac.ffmpeg.org/wiki/Hardware/QuickSync>`_ (Intel Quick Sync Video
- Intel Media SDK integration into ffmpeg. The use of "extbrc" demonstrates the use
of developer configurable bitrate control, in these examples the defaults generate
streams using pyramid coding and other quality optimizations.

**Example 1: AVC VBR Encode**::

  ffmpeg -hwaccel qsv \
    -f rawvideo -pix_fmt yuv420p -s:v ${width}x${height} -r $framerate \
    -i $inputyuv -vframes $numframes -y \
    -c:v h264_qsv -preset medium -profile:v high \
    -b:v $bitrate -maxrate $((2 * $bitrate)) -bufsize $((4 * $bitrate)) \
    -g 256 -extbrc 1 -b_strategy 1 -bf 7 -refs 5 -vsync 0 $output

**Example 2: AVC CBR Encode**::

  ffmpeg -hwaccel qsv \
    -f rawvideo -pix_fmt yuv420p -s:v ${width}x${height} -r $framerate \
    -i $inputyuv -vframes $numframes -y \
    -c:v h264_qsv -preset medium -profile:v high \
    -b:v $bitrate -maxrate $bitrate -minrate $bitrate -bufsize $((2 * $bitrate)) \
    -g 256 -extbrc 1 -b_strategy 1 -bf 7 -refs 5 -vsync 0 $output

**Example 3: HEVC VBR Encode**::

  ffmpeg -hwaccel qsv \
    -f rawvideo -pix_fmt yuv420p -s:v ${width}x${height} -r $framerate \
    -i $inputyuv -vframes $numframes -y \
    -c:v hevc_qsv -preset medium -profile:v main \
    -b:v $bitrate -maxrate $((2 * $bitrate)) -bufsize $((4 * $bitrate)) \
    -g 256 -extbrc 1 -refs 5 -bf 7 -vsync 0 $output


**Example 4: HEVC CBR Encode**::

  ffmpeg -hwaccel qsv \
    -f rawvideo -pix_fmt yuv420p -s:v ${width}x${height} -r $framerate \
    -i $inputyuv -vframes $numframes -y \
    -c:v hevc_qsv -preset medium -profile:v main \
    -b:v $bitrate -maxrate $bitrate -minrate $bitrate -bufsize $((2 * $bitrate)) \
    -g 256 -extbrc 1 -refs 5 -bf 7 -vsync 0 $output

The noted good practices are used throughout the project within demo
examples and quality and performance measuring tools. See the following
document on the further details:

* `Video Quality Command Lines and Measuring Methodology <doc/quality.rst>`_
* `Video Performance Command Linux and Measuring Methodology <doc/performance.rst>`_

Further reading
---------------

* `Manual Pages <doc/man/readme.rst>`_

  * `man demo <doc/man/demo.asciidoc>`_
  * `man measure-perf <doc/man/measure-perf.asciidoc>`_
  * `man measure-quality <doc/man/measure-quality.asciidoc>`_

* Reference command lines & methodologies

  * `performance <doc/performance.rst>`_
  * `quality <doc/quality.rst>`_

* `Generating Dockerfiles <doc/docker.rst>`_
* `HowTo <doc/howto.rst>`_
* `Tests <tests/readme.rst>`_

* `General Purpose GPU Drivers for Linux* Operating Systems <https://intel.com/linux-graphics-drivers>`_
* `GPGPU Documentation <https://dgpu-docs.intel.com/>`_
* `Intel Media SDK <https://github.com/Intel-Media-SDK/MediaSDK>`_
* `Intel Media Driver <https://github.com/intel/media-driver>`_
* `Open Visual Cloud <https://01.org/openvisualcloud>`_

  * `CDN Transcode Sample <https://github.com/OpenVisualCloud/CDN-Transcode-Sample>`_

* `Docker <https://docker.com>`_
* `FFmpeg <http://ffmpeg.org/>`_
* `VLC player <https://www.videolan.org/vlc/index.html>`_
* `NGinx <http://nginx.org>`_

Content Attribution
-------------------

Container image comes with some embedded content attributed as follows::

  /opt/data/embedded/WAR_TRAILER_HiQ_10_withAudio.mp4:
    Film: WAR - Courtesy & Copyright: Yash Raj Films Pvt. Ltd.

Inside the container, please, refer to the following file::

  cat /opt/data/embedded/usage.txt
