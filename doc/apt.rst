Local APT Repository
====================

This section provides steps on how to configure your own http:// APT repository
to fetch packages from. This might be useful if you have some customized packages
and need to build against these packages. If you build docker image, this helps
to reduce image size since you avoid storing packages in the image.

We will demonstrate configuring of APT repository via dedicated docker container.
First, build a docker image with APT web server using the following Dockerfile::

  $ cat Dockerfile
  FROM ubuntu:20.04

  RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      aptly && \
    rm -rf /var/lib/apt/lists/*

  # substitute this with other command to populate /opt/pkgs
  # directory with required *.deb packages
  COPY pkgs /opt/pkgs

  RUN aptly repo create intel-gfx
  RUN aptly repo add intel-gfx /opt/pkgs
  RUN aptly publish repo -skip-signing -distribution=intel-gfx intel-gfx
  CMD ["/usr/bin/aptly", "serve", "-listen=:8080"]

  $ docker build $(env | grep -E '(_proxy=|_PROXY)' | sed 's/^/--build-arg /') \
    -f Dockerfile -t apt-webserver .

Above docker file assumes that .deb packages are stored locally in ``pkgs`` directory.

Now start APT webserver::

  docker network create build
  docker create --network=build --name=local-apt apt-webserver
  docker start apt-webserver

Now you should be able to fetch packages from your APT repository adding this line
to /etc/apt/sources.list::

  echo "deb [trusted=yes] http://<ip>:8080/ intel-gfx main"

If you are using this under docker, make sure to run docker build under same network
as we've created for apt-webserver and use IP address in this network, i.e.::

  IP=$(docker inspect -f '{{.NetworkSettings.Networks.build.IPAddress}}' apt-webserver)
  docker build --network=build \
    --build-arg INTEL_GFX_KEY_URL="" \
    --build-arg INTEL_GFX_APT_REPO="deb [trusted=yes] http://$IP:8080/ intel-gfx main" \
    ...

