dnl # Copyright (c) 2020 Intel Corporation
dnl #
dnl # Permission is hereby granted, free of charge, to any person obtaining a copy
dnl # of this software and associated documentation files (the "Software"), to deal
dnl # in the Software without restriction, including without limitation the rights
dnl # to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
dnl # copies of the Software, and to permit persons to whom the Software is
dnl # furnished to do so, subject to the following conditions:
dnl #
dnl # The above copyright notice and this permission notice shall be included in all
dnl # copies or substantial portions of the Software.
dnl #
dnl # THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
dnl # IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
dnl # FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
dnl # AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
dnl # LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
dnl # OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
dnl # SOFTWARE.
dnl #
include(begin.m4)

include(intel-gpu-tools.m4)

DECLARE(`DEVEL',yes)

define(`SAMPLES_INSTALL_DEPS',`dnl
  libmfx-tools dnl
  libnginx-mod-http-lua libnginx-mod-rtmp dnl
  linux-tools-generic nginx pciutils dnl
  python3 python3-matplotlib python3-numpy dnl
  socat tmux vainfo dnl
  ifelse(DEVEL,yes,`curl sudo vim wget')')

define(`INSTALL_SAMPLES',`dnl
# perf is tight to particular kernel version per old WA which will never
# be fixed, we just need to use some version
RUN ln -fs $(find /usr/lib/linux-tools -name perf) /usr/bin/perf;

# Granting CAP_SYS_ADMIN to the Linux perf to be able to get global perf
# events (specifically: i915 events). Mind that this will work if container
# is started with:
#   --cap-add SYS_ADMIN --security-opt="no-new-privileges:false"
# If it was started with
#   --cap-add SYS_ADMIN --security-opt="no-new-privileges:true"
# then you need to adjust /proc/sys/kernel/perf_event_paranoid on a host to have
# value <=0
RUN setcap cap_sys_admin+ep $(readlink -f $(which perf))
#RUN setcap cap_sys_admin+ep $(readlink -f $(which intel_gpu_top))

# Installing entrypoint helper scripts
COPY assets/demo-alive /usr/bin/
COPY assets/demo-bash /usr/bin/
COPY assets/hello-bash /usr/bin/

# Create default container user <user>
RUN groupadd -r user && useradd -lrm -s /bin/bash -g user user
ifelse(DEVEL,yes,`dnl
RUN usermod -aG sudo user && \
  sed -i -e "s/%sudo.*/%sudo ALL=(ALL) NOPASSWD:ALL/g" /etc/sudoers'
)
# Creating locations sample will need and giving permissions
# to the default user
RUN mkdir -p /opt/data/content
RUN mkdir -p /opt/data/artifacts && chown user /opt/data/artifacts
RUN mkdir -p /opt/data/duplicates && chown user /opt/data/duplicates
# The following are locations used by nginx to produce HLS streams,
# dump logs, etc.
RUN mkdir -p /var/www/hls && chown user /var/www/hls
RUN chown -R user /var/log/nginx
RUN chown -R user /var/lib/nginx

# Setting up sample
ARG SAMPLE=cdn
COPY . /tmp/src
RUN cd /tmp/src/samples/$SAMPLE && ./setup.sh BUILD_PREFIX && rm -rf /tmp/src

# Setting up environment common for all samples

# Declaring volumes which you might wish to optionally mount
#  * /opt/data/content is where you can put your own content to access from inside
#    the sample demos
#  * /opt/data/artifacts is a location where sample will produce some output
#    artifacts like generated or captured stream and logs. You can wish to twick
#    this location to get artifacts on your host system
#  * /var/www/hls is a location where sample demos will generate HLS streams. You
#    might wish to twick this location to get access to these streams. Mind that
#    this is server side raw HLS stream. If you run some demo client to capture
#    streaming video - look in the /opt/data/artifacts

VOLUME /opt/data/content
VOLUME /opt/data/artifacts
VOLUME /var/www/hls

# Check running container healthy status with:
#  docker inspect --format="{{json .State.Health}}" <container-id>
HEALTHCHECK CMD /usr/bin/demo-alive

# hello-bash is a default command which will be executed by demo-bash if
# user did not provide any arguments starting the container. Basically hello-bash
# will print welcome message and enter regular bash with correct environment.
CMD ["/usr/bin/hello-bash"]

# demo-bash will execute whatever command is provided by the user making
# sure that environment settings are correct.
ENTRYPOINT ["/usr/bin/demo-bash"]') # define(INSTALL_SAMPLES)

REG(SAMPLES)

include(end.m4)
