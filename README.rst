Media Delivery Software Stack
=============================

.. contents::

Overview
--------

Media Delivery Software Stack provides samples demonstrating the use of Intel GPU
in simplified modelled real-life scenarios involving media streams delivery. Samples
focus on the key aspects of the proper Intel software setup and integration with other
popular tools you will likely use in your final product. We try to do our best to
provide a configuration which will demonstrate the best quality and performance for
Intel media stack.

Key topcis we are covering:

* Content Delivery Network (CDN) samples showcasing of Video On Demand (VOD)
  streaming under Nginx server
* Reference command lines (for ffmpeg-qsv and mediasdk native samples) tuned
  for the optimal quality and performance (for the showcasing scenario)
* Quality and Performance measuring infrastructure for data collection
* Intel GPU Performance monitoring

How to get?
-----------

Each sample is available in a form of `Docker <https://docker.com>`_ container
which you need to build locally. To build default sample (`CDN`_) run::

  docker build \
    $(env | grep -E '(_proxy=|_PROXY)' | sed 's/^/--build-arg /') \
    --file Dockerfile.ubuntu \
    --tag intel-media-delivery \
    .

Use ``--build-arg SAMPLE=$SAMPLE`` docker build argument to specify other
sample to build.

**Hint:** to install a docker refer to Docker install
`instructions <https://docs.docker.com/install/>`_.

Host requirements
-----------------

To run these samples you need to:

1. Have a system with enabled Intel GPU card supported by Intel media driver
   (refer to https://github.com/intel/media-driver documentation for the list of
   supported GPUs)
2. Run Linux OS with up-to-date Linux kernel supporting underlying Intel GPU
3. Have installed and configured Docker

Other than that you might wish to install some tools on your host (or some other
system capable of reaching the container over network) to be able to interact with the
service(s) running inside the container. Consider having on a host the following:

1. `VLC player <https://www.videolan.org/vlc/index.html>`_ to be able to play streaming
   videos
2. `ffmpeg <http://ffmpeg.org/>`_ to be able to receive and save streaming videos

How to run?
-----------

Each sample contains few entrypoints:

1. ``demo`` allows to run a demo (mind ``demo help`` and ``man demo``)
2. ``measure`` allows to run a measurement tools (mind ``measure help`` and
   ``man measure``)

To be able to run container successfully you need to start it with certain
permissions allowing access to GPU device(s), file system, etc. So, when container
starts it checks that prerequisites are met and guides you toward correct
startup command line. For example::

  # docker run intel-media-delivery
  error: device not available: /dev/dri/renderD128
  error:   if you run under docker add host device(s) with:
  error:     --device=/dev/dri/renderD128 (preferred)
  error:     --device=/dev/dri/
  error:     --privileged
  error:   you can change device you want to use with:
  error:     -e DEVICE=/dev/dri/renderD128
  error: failed to setup demo

The minimal set of arguments to start the container looks as follows::

  DEVICE=${DEVICE:-/dev/dri/renderD128}
  DEVICE_GRP=$(ls -g $DEVICE | awk '{print $3}' | \
    xargs getent group | awk -F: '{print $3}')
  docker run --rm -it \
    -e DEVICE=$DEVICE --device $DEVICE --group-add $DEVICE_GRP \
    --cap-add SYS_ADMIN \
    -p 8080:8080 \
    intel-media-delivery

Effectively you need to allow container access to the host GPU device
(``--device`` and ``--group-add``), grant ``SYS_ADMIN`` capabilities for the
container user to be able to collect GPU metrics (``--cap-add``) and publish a
network port to be able to reach container streaming from outside the
container (``-p``).

Mind that ``-e DEVICE=$DEVICE`` option allows to adjust the host GPU device
to be used under the demo.

Run without entrypoint (as in the example above) to enter shell and look around
inside the container. For example, samples come with the `manual pages <doc/man/readme.rst>`_
which you might review::

  # docker run .... # start container
  # man demo
  # man measure

Please, refer to `Samples HowTo <doc/howto.rst>`_ for the more advanced
topics like which host folders you can map and how to do that coorectly.

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

On the output you should get list of streams in a format::

  http://172.17.0.2:8080/vod/avc/WAR_TRAILER_HiQ_10_withAudio/index.m3u8

``172.17.0.2`` stands for the container IP address (locally you might see
some other value). Mind that since we've published container port to the
host port, streams will also be available via links like::

  http://<host-ip>:8080/vod/avc/WAR_TRAILER_HiQ_10_withAudio/index.m3u8

Above example just lists content embedded in the container on the build stage.
See `Content Attribution`_ for the copyright info for the above video. See
`Container volumes (adding your content, access logs, etc.) <doc/howto.rst#container-volumes-adding-your-content-access-logs-etc>`_
for how to add your own content to the demo.

**Hint:** if you work under proxy and have any issues with the demo playing
on the same system (client and server both running locally), then try to
access streaming with just::

  http://localhost:8080/vod/avc/WAR_TRAILER_HiQ_10_withAudio/index.m3u8

You can run samples in a differnt modes depending on where client is
located. These modes comes with slightly differnt levels of complexity - see
below paragraphs for mode details.

ffmpeg demo mode
~~~~~~~~~~~~~~~~

With ``ffmpeg`` demo mode client is ran inside the container. As such, you don't need
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
    demo ffmpeg http://localhost:8080/vod/avc/WAR_TRAILER_HiQ_10_withAudio/index.m3u8

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

Interactive demo mode (aka vlc mode)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

With "interactive" demo mode container runs all the services required for streaming, but
awaits for the user interaction to trigger the streaming. To start demo in this mode,
execute::

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

Or from some other machine in the network::

  vlc http://<host-ip>:8080/vod/avc/WAR_TRAILER_HiQ_10_withAudio/index.m3u8
  # or
  ffmpeg -i http://<host-ip>:8080/vod/avc/WAR_TRAILER_HiQ_10_withAudio/index.m3u8 -c copy WAR_TRAILER_HiQ_10_withAudio.mkv

Similar to `ffmpeg demo mode`_ described above, container will start few
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
    intel-media-delivery demo -4 ffmpeg \
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
of GPU accelerated offloads. For bigger scale CDN sample, please, take a look on
`Open Visual Cloud Samples <https://01.org/openvisualcloud>`_.

Edge
~~~~

This sample can be built with ``--build-arg SAMPLE=edge``.

"Edge" sample is using Nginx `RTMP module <https://github.com/arut/nginx-rtmp-module>`_
to generate HLS stream. FFmpeg is still used to transcode the stream, but it
does not produce HLS stream. Instead it sends transcoded stream to RTMP
server which actually breaks the stream into fragments and creates HLS
stream. One of the downsides of using RTMP module is that it has limited
codec capabilities. Specifically, as of now H.265 video is not supported.

How to run measurement infrastructure?
--------------------------------------

Not ready

Further reading
---------------

* `Manual Pages <doc/man/readme.rst>`_
* `HowTo <doc/howto.rst>`_
* `Tests <tests/readme.rst>`_

Content Attribution
-------------------

Container image comes with some embedded content attributed as follows::

  /opt/data/embedded/WAR_TRAILER_HiQ_10_withAudio.mp4:
    Film: WAR - Courtesy & Copyright: Yash Raj Films Pvt. Ltd.

Inside the container, please, refer to the following file::

  cat /opt/data/embedded/usage.txt

Links
-----

* `Docker <https://docker.com>`_
* `FFmpeg <http://ffmpeg.org/>`_
* `VLC player <https://www.videolan.org/vlc/index.html>`_
* `NGinx <http://nginx.org>`_
