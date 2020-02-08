Intel Media Delivery Solutions
==============================

.. contents::

Overview
--------

This is collection of solutions which demonstrates how to use Intel GPU in simplified
modelled real live scenarious which involve media streams delivery. Solutions focus
on the key aspects of the proper Intel software setup and integration with other
popular tools you will likely use in your final product. We try to our best to provide
configuration which will demonstrate best quality and performance for Intel media stack.
Please, refer to the below benchmark results to level set expectations.

How to get?
-----------

Each solution is available in a form of Docker container. To build default solution (`CDN`_)
run::

  docker build \
    $(env | grep -E '_proxy=' | sed 's/^/--build-arg /') \
    --network=host \
    --file Dockerfile.ubuntu \
    --tag intel-media-delivery \
    .

Use ``--build-arg SOLUTION=$SOLUTION`` docker build argument to specify other solution to
build.

Host requirements
-----------------

To run these solutions you need to:

1. Have system with enabled Intel GPU card supported by Intel media driver
   (refer to https://github.com/intel/media-driver documentation for the list of
   supported GPUs)
2. Run Linux OS with up to date Linux kernel supporting underlying Intel
   GPU (see recommendations TBD)
3. Have installed and configured Docker

Other than that you might wish to install some tools on your host (or some other
system capable to reach container over network) to be able to interact with the
service(s) running inside the container. Consider to have on a host:

1. `VLC player <https://www.videolan.org/vlc/index.html>`_ to be able to play streaming
   videos
2. `ffmpeg <http://ffmpeg.org/>`_ to be able to receive and save streaming videos

How to run?
-----------

Each solution contains few entrypoints:

1. ``demo`` allows to run a demo (mind ``demo help``)
2. ``bench`` allows to run a benchmark (mind ``bench help``)

In this paragraph we will discuss demo modes. Read how to run benchmarks in
`How to run benchmark?`_ section.

Media delivery solutions are about delivering media streams to the clients. So,
solutions consist of 2 parts:

1. Service(s) running inside the container which produce and distribute media streams
2. And client(s) running somewhere (not necessarily inside the container)
   which consume media streams

Run without entrypoint to enter shell and look around inside the container.

To get list of streams you will be able to play, execute::

  docker run -it \
    $(env | grep -E '_proxy=' | sed 's/^/-e /') \
    --privileged --network=host \
    -v /path/to/content:/content \
    intel-media-delivery demo streams

``content`` folder mapped inside the container should contain AVC encoded video
stream(s) in MP4 container format. On the output of the above command you should
get list of stream in a format::

  TearsOfSteel | http://localhost:8080/live/TearsOfSteel

ffmpeg demo mode
~~~~~~~~~~~~~~~~

Using ``ffmpeg`` demo mode client is ran inside the container. You don't need
to interact with the container in any other way rather than to start and stop it.
To run it, execute::

  docker run -it \
    $(env | grep -E '_proxy=' | sed 's/^/-e /') \
    --privileged --network=host \
    -v /path/to/content:/content \
    intel-media-delivery demo ffmpeg TearsOfSteel
    
Interactive demo mode (use vlc)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

In interactive demo mode container runs all the services required for streaming, but
awaits for the user interaction. To start demo in this mode, execute::

  docker run -it \
    $(env | grep -E '_proxy=' | sed 's/^/-e /') \
    --privileged --network=host \
    -v /path/to/content:/content \
    intel-media-delivery demo

After that you need to trigger streaming via some client running outside of the
container. For example, from the host::

  vlc http://localhost:8080/live/TearsOfSteel
  # or
  ffmpeg -i http://localhost:8080/live/TearsOfSteel -c copy TearsOfSteel.mkv
  
Available solutions and their architectures
-------------------------------------------

CDN
~~~

This solution can be built with ``--build-arg SOLUTION=cdn`` which is the default.

This solution is using ffmpeg generate HLS stream. TODO: describe more.

Edge
~~~~

This solution can be built with ``--build-arg SOLUTION=edge``.

This solution is using Nginx RTMP module to generate HLS stream. TODO: describe more.

Benchmark results
-----------------

Quality
~~~~~~~

Not ready

Performance
~~~~~~~~~~~

Not ready

How to run benchmark?
---------------------

Not ready

Further reading
---------------

* `Solutions HowTo <doc/howto.rst>`_

Links
-----

TBD
