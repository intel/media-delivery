#
# Copyright (c) 2020 Intel Corporation
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

load utils

whoami_test=(/bin/bash -c "set -ex; res=\$(whoami); [[ "\$res" = "user" ]];")
pwd_home_test=(/bin/bash -c "set -ex; res=\$(pwd); [[ "\$res" = "/home/user" ]];")

@test "demo-bash whoami" {
  run docker_run "${whoami_test[@]}"
  print_output
  [ "$status" -eq 0 ]

  run docker_run "${pwd_home_test[@]}"
  print_output
  [ "$status" -eq 0 ]
}

@test "demo-bash whoami host user" {
  opts="-u $(id -u):$(id -g)"
  opts+=" $(get_mounts $opts)"

  run docker_run_opts "$opts" pwd
  print_output
  [ "$status" -eq 0 ]
  grep_for "/tmp" ${lines[@]}
}

@test "demo-bash no gpu" {
  run docker run ${MDS_IMAGE} whoami
  print_output
  [ "$status" -eq 255 ]

  run docker run -e MDS_IGNORE_ERRORS=yes ${MDS_IMAGE} whoami
  print_output
  [ "$status" -eq 0 ]
  grep_for "user" ${lines[@]}
}

@test "demo-bash no such device" {
  run docker_run_opts "-e DEVICE=/dev/dri/nodevice" whoami
  print_output
  [ $status -eq 255 ]
}

@test "demo-bash map all" {
  tmp_content=`mktemp -p $_TMP -d -t content-XXXX`
  tmp_artifacts=`mktemp -p $_TMP -d -t artifacts-XXXX`
  tmp_hls=`mktemp -p $_TMP -d -t hls-XXXX`
  chmod 755 $tmp_content $tmp
  chmod 777 $tmp_artifacts $tmp_hls
  run docker_run_opts \
    "-v $tmp_content:/opt/data/content -v $tmp_artifacts:/opt/data/artifacts -v $tmp_hls:/var/www/hls" \
    "${whoami_test[@]}"
  print_output
  [ "$status" -eq 0 ]
  rm -rf $tmp_content $tmp_artifacts $tmp_hls
}

@test "demo-bash no artifacts rewrite" {
  tmp=`mktemp -p $_TMP -d -t artifacts-XXXX`
  chmod 777 $tmp
  run docker_run_opts "-v $tmp:/opt/data/artifacts" "${whoami_test[@]}"
  print_output
  [ "$status" -eq 0 ]

  touch $tmp/somefile
  run docker_run_opts "-v $tmp:/opt/data/artifacts" whoami
  print_output
  [ "$status" -ne 0 ]

  rm -rf $tmp
}

@test "demo-bash bad content map" {
  tmp=`mktemp -p $_TMP -d -t content-XXXX`
  chmod a-r $tmp
  run docker_run_opts "-v $tmp:/opt/data/content" whoami
  print_output
  [ "$status" -eq 255 ]
  rm -rf $tmp
}

@test "demo-bash bad artifacts map" {
  tmp=`mktemp -p $_TMP -d -t artifacts-XXXX`
  chmod a-r $tmp
  run docker_run_opts "-v $tmp:/opt/data/artifacts" whoami
  print_output
  [ "$status" -eq 255 ]
  rm -rf $tmp
}

@test "demo-bash bad hls map" {
  tmp=`mktemp -p $_TMP -d -t hls-XXXX`
  chmod a-r $tmp
  run docker_run_opts "-v $tmp:/var/www/hls" whoami
  print_output
  [ "$status" -eq 255 ]
  rm -rf $tmp
}
