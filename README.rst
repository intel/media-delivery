Media Delivery Solutions
========================

.. contents::

Overview
--------

This is a collection of solutions which demonstrate how to use Intel GPU in simplified
modelled real-life scenarios involving media streams delivery. Solutions focus
on the key aspects of the proper Intel software setup and integration with other
popular tools you will likely use in your final product. We try to do our best to provide
a configuration which will demonstrate the best quality and performance for Intel media stack.
Please, refer to the below measurement results to level set expectations.

How to get?
-----------

Each solution is available in a form of `Docker <https://docker.com>`_ container. To install
a docker refer to Docker install `instructions <https://docs.docker.com/install/>`_. To
build default solution (`CDN`_) run::

  docker build \
    $(env | grep -E '_proxy=' | sed 's/^/--build-arg /') \
    --network=host \
    --file Dockerfile.ubuntu \
    --tag intel-media-delivery \
    .

Use ``--build-arg SAMPLE=$SAMPLE`` docker build argument to specify other solution to
build.

Host requirements
-----------------

To run these solutions you need to:

1. Have a system with enabled Intel GPU card supported by Intel media driver
   (refer to https://github.com/intel/media-driver documentation for the list of
   supported GPUs)
2. Run Linux OS with up-to-date Linux kernel supporting underlying Intel
   GPU (see recommendations TBD)
3. Have installed and configured Docker

Other than that you might wish to install some tools on your host (or some other
system capable of reaching the container over network) to be able to interact with the
service(s) running inside the container. Consider having on a host the following:

1. `VLC player <https://www.videolan.org/vlc/index.html>`_ to be able to play streaming
   videos
2. `ffmpeg <http://ffmpeg.org/>`_ to be able to receive and save streaming videos

How to run?
-----------

Each solution contains few entrypoints:

1. ``demo`` allows to run a demo (mind ``demo help``)
2. ``measure`` allows to run a measurement (mind ``measure help``)

In this paragraph we will discuss the demo modes. Read how to run measurements in
`How to run a measure?`_ section.

Media delivery solutions are about delivering media streams to the clients. As such,
the solutions consist of 2 parts:

1. Service(s) running inside the container which produce and distribute media streams
2. Client(s) running somewhere (not neccessarily inside the container)
   which consume media streams

Run without entrypoint to enter shell and look around inside the container::

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

ffmpeg demo mode
~~~~~~~~~~~~~~~~

Using ``ffmpeg`` demo mode client is ran inside the container. You don't need
to interact with the container in any other way rather than to start and stop it.
To run it, execute::

  DEVICE=${DEVICE:-/dev/dri/renderD128}
  DEVICE_GRP=$(ls -g $DEVICE | awk '{print $3}' | \
    xargs getent group | awk -F: '{print $3}')
  docker run --rm -it \
    -e DEVICE=$DEVICE --device $DEVICE --group-add $DEVICE_GRP \
    --cap-add SYS_ADMIN \
    -p 8080:8080 \
    intel-media-delivery demo ffmpeg http://localhost:8080/vod/avc/WAR_TRAILER_HiQ_10_withAudio/index.m3u8

Upon successful launch you will see output similar to the below one.

.. image:: doc/pic/demo-ffmpeg.png
   :width: 50%

Few terminals will be opened in a tiled layout and provide the following information back:

1. Client monitoring statistics (how many clients are running and/or stopped, their FPS, etc.)
2. Server monitoring statistics (how many requests server received, running FPS, etc.)
3. GPU monitoring data (GPU engines utilization)
4. CPU and system monitroing data (CPU and memory utilization, tasks running, etc.)

Tiled terminals are managed by `tmux <https://github.com/tmux/tmux>`_. Please, refer to
its documentation if you wish to navigate and play around with the demo.

Interactive demo mode (use vlc)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

In interactive demo mode container runs all the services required for streaming, but
awaits for the user interaction. To start demo in this mode, execute::

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

Or from some other machine in the network:

  vlc http://<host-ip>:8080/vod/avc/WAR_TRAILER_HiQ_10_withAudio/index.m3u8
  # or
  ffmpeg -i http://<host-ip>:8080/vod/avc/WAR_TRAILER_HiQ_10_withAudio/index.m3u8 -c copy WAR_TRAILER_HiQ_10_withAudio.mkv
  
Available solutions and their architectures
-------------------------------------------

CDN
~~~

This solution can be built with ``--build-arg SAMPLE=cdn`` which is the default.

This solution is using ffmpeg to generate HLS stream. Below image provides solution
architecture diagram.

.. image:: doc/pic/cdn-demo-architecture.png

Solution focus on the very basics to configure HLS streaming thru nginx server.
Client requests are server on the same system where nginx server is running thru
trivial shell script scheduling of background processes. Increasing number of client
requests for different streams would allow to exercise how system behaves under different
loads. Mind that you can use ``-<n>`` demo option to emulate multiple streams
available for streaming::

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

This solution can be further scaled. For example, transcoding requests might not be served
on the same system where nginx server is running. Instead they are served by dedicated
systems managed by special service(s) (like kafka). This solution demo intentionally left
scaling examples aside to focus on streaming configuration basics and key aspects of GPU
accelerated offloads. For bigger scale CDN solution, please, take a look on
`Open Visual Cloud Samples <https://01.org/openvisualcloud>`_.

Edge
~~~~

This solution can be built with ``--build-arg SAMPLE=edge``.

This solution is using Nginx RTMP module to generate HLS stream. TODO: describe more.

Measurement results
-------------------

Quality
~~~~~~~

Not ready

Performance
~~~~~~~~~~~

Not ready

How to run a measure?
---------------------

Not ready

Further reading
---------------

* `Media Delivery Solutions Manual Pages <doc/man/readme.rst>`_
* `Solutions HowTo <doc/howto.rst>`_
* `Solutions Tests <tests/readme.rst>`_

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
