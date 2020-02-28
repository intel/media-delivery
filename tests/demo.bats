if [ -z "${MDS_IMAGE}" ]; then
  echo "error: no container specified (\${MDS_IMAGE})" >&2
  exit 1
fi

if ! which docker; then
  echo "error: docker is not available in \${PATH}" >&2
  exit 1
fi

##################
# helper functions
##################
function docker_run() {
  docker run -it --privileged --network=host intel-media-delivery $@
}

function docker_run_opts() {
  docker run -it --privileged --network=host $opts intel-media-delivery $@
}

function print_output() {
  for line in ${lines[@]}; do
    echo "# $line" >&3
  done
}

function grep_for() {
  what=$1
  shift
  text=($@)
  res=1
  for line in ${text[@]}; do
    if [[ "$line" =~ "$what"  ]]; then
      res=0
      break
    fi
  done
  return $res
}

#########################
# demo (no command) tests
#########################
@test "demo unknown command" {
  run docker_run demo unknown
  print_output
  [ $status -eq 255 ]
}

#################
# demo help tests
#################
@test "demo --help" {
  run docker_run demo --help
  print_output
  [ $status -eq 0 ]
}

@test "demo help" {
  run docker_run demo help
  print_output
  [ $status -eq 0 ]
}

@test "demo help ffmpeg" {
  run docker_run demo help ffmpeg
  print_output
  [ $status -eq 0 ]
}

@test "demo help streams" {
  run docker_run demo help streams
  print_output
  [ $status -eq 0 ]
}

@test "demo help unknown topic" {
  run docker_run demo help unknown
  print_output
  [ $status -eq 255 ]
}

####################
# demo streams tests
####################
@test "demo streams" {
  run docker_run demo streams
  print_output
  [ $status -eq 0 ]
  run grep_for "WAR_2Mbps_perceptual_1080p" ${lines[@]}
  [ $status -eq 0 ]
}

@test "demo streams w/ added content" {
  tmp=`mktemp -d -t demo-XXXX`
  chmod a+x $tmp
  chmod a+r $tmp
  touch $tmp/fake.mp4
  opts="-v $tmp:/opt/data/content"
  run docker_run_opts demo streams
  print_output
  [ $status -eq 0 ]
  streams_output=("${lines[@]}")

  run grep_for "fake" ${streams_output[@]}
  [ $status -eq 0 ]
  run grep_for "WAR_2Mbps_perceptual_1080p" ${streams_output[@]}
  [ $status -eq 0 ]
  rm -rf $tmp
}

@test "demo streams too many arguments" {
  run docker_run demo streams param
  print_output
  [ $status -eq 255 ]
}

###################
# demo ffmpeg tests
###################
@test "demo ffmpeg no streams" {
  run docker_run demo ffmpeg
  print_output
  [ $status -eq 255 ]
}

@test "demo ffmpeg unknown stream" {
  run docker_run demo ffmpeg unknown
  print_output
  [ $status -eq 255 ]
}
