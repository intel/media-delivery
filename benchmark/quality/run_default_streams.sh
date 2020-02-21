#!/bin/bash

if [[ "$1" =~ ^(help|-help|--help|-h)$ ]]; then
  echo "Usage:"
  echo "  run_default_streams.sh help|-help|--help|-h"
  echo "  run_default_streams.sh AVC|HEVC default|best </path/to/streams>|</path/to/stream.yuv> [--skip-metrics|--skip-encoding]"
  echo ""
  echo "Options:"
  echo "  help|-help|--help|-h - print this help"
  echo "  AVC|HEVC             - encoder to use"
  echo "  default|best         - a set of encoding options to use"
  echo "  --skip-metrics       - do not calculate metrics"
  echo "  --skip-encoding      - do not encode streams"
  echo ""
  echo "Description:"
  echo "Encodes pre-defined default list of streams with the specified codec"
  echo "and encoding options preset."
  echo ""
  echo "Input streams are searched in the provided path including subfolders."
  echo "If path to the file is provides instead of path, only the specified stream is"
  echo "benchmarked (if it's in the list of known streams)."
  echo ""
  echo "--skip-metrics and --skip-encoding allow to skip corresponding stage in the script."
  exit 0
fi

codec=$1
shift
options=$1
shift
vidpath=$1
shift
skip_arg=$1
shift

if [ -z "$codec" -o -z "$options" -o -z "$vidpath" ]; then
  echo "error: missing commnad line arguments"
  exit -1
fi

script_path=$(dirname $(readlink -f $0))

function find_stream() {
  stream=$1
  path=( $(find $vidpath -name "$stream") )

  if [ "${#path[@]}" -eq 0 ]; then
    # error: stream not found
    #   We will just return non-existing path to fail in the application(s)
    echo "$vidpath/$stream"
  elif [ ${#path[@]} -gt 1 ]; then
    echo "warning: multiple streams with the same name: $stream" >&2
    for s in ${path[@]}; do echo "warning:  $s" >&2; done
  fi
  echo ${path[0]}
}

function run() {
  stream=$1
  shift
  if [ -d $vidpath ]; then
    $script_path/run_quality.sh $(find_stream $stream) $@
  elif [ "${vidpath##*/}" = $stream ]; then
    $script_path/run_quality.sh $vidpath $@
    exit 0
  fi
}

# 720p SD streams...

run "BoatNF_1280x720_60.yuv" \
  "Boat_720p" 1280 720 300 60 $codec -SD $options $skip_arg

run "crowd_run_1280x720_50.yuv" \
 "CrowdRun_720p" 1280 720 500 50 $codec -SD $options $skip_arg

run "Kimono1_1280x720_24.yuv" \
  "Kimono_720p" 1280 720 240 24 $codec -SD $options $skip_arg

run "FoodMarket2NF_1280x720_60.yuv" \
  "FoodMarket2_720p" 1280 720 300 60 $codec -SD $options $skip_arg

run "PierSeasideNF_1280x720_60.yuv" \
  "PierSeaside_720p" 1280 720 600 60 $codec -SD $options $skip_arg

run "TangoNF_1280x720_60.yuv" \
  "Tango_720p" 1280 720 294 60 $codec -SD $options $skip_arg

run "park_joy_1280x720_50.yuv" \
  "ParkJoy_720p" 1280 720 500 50 $codec -SD $options $skip_arg

run "ParkScene_1280x720_24.yuv" \
  "ParkScene_720p" 1280 720 240 24 $codec -SD $options $skip_arg

run "touchdown_pass_1280x720_30.yuv" \
  "TouchdownPass_720p" 1280 720 570 30 $codec -SD $options $skip_arg

# 1080p HD streams...

run "BasketballDrive_1920x1080_50.yuv" \
  "BasketballDrive_1080p" 1920 1080 500 50 $codec -HD $options $skip_arg

run "bq_terrace_1920x1080p_600_60.yuv" \
  "BQTerrace_1080p" 1920 1080 600 60 $codec -HD $options $skip_arg

run "Cactus_1920x1080_50.yuv" \
  "Cactus_1080p" 1920 1080 500 50 $codec -HD $options $skip_arg

run "crowd_run_1920x1080p_500_50.yuv" \
  "CrowdRun_1080p" 1920 1080 600 60 $codec -HD $options $skip_arg

run "DinnerScene_1920x1080_60.yuv" \
  "DinnerScene_1080p" 1920 1080 600 60 $codec -HD $options $skip_arg

run "park_joy_1920x1080_500_50.yuv" \
  "ParkJoy_1080p" 1920 1080 500 50 $codec -HD $options $skip_arg

run "Kimono1_1920x1080_24.yuv" \
  "Kimono_1080p" 1920 1080 240 24 $codec -HD $options $skip_arg

run "RedKayak_1920x1080_30.yuv" \
  "RedKayak_1080p" 1920 1080 570 30 $codec -HD $options $skip_arg

run "RushFieldCuts_1920x1080_30.yuv" \
  "RushFieldCuts_1080p" 1920 1080 570 30 $codec -HD $options $skip_arg

run "Bunny_1920x1080_24_600.yuv" \
  "Bunny_1080p" 1920 1080 600 24 $codec -HD $options $skip_arg

run "CSGO_1920x1080_60.yuv" \
  "CSGO_1080p" 1920 1080 600 60 $codec -HD $options $skip_arg

run "DOTA2_1920x1080_60_600.yuv" \
  "DOTA2_1080p" 1920 1080 600 60 $codec -HD $options $skip_arg

run "GTAV_1920x1080_60_600.yuv" \
  "GTAV_1080p" 1920 1080 600 60 $codec -HD $options $skip_arg

run "Hearthstone_1920x1080_60.yuv" \
  "Hearthstone_1080p" 1920 1080 600 60 $codec -HD $options $skip_arg

run "MINECRAFT_1920x1080_60_600.yuv" \
  "MINECRAFT_1080p" 1920 1080 600 60 $codec -HD $options $skip_arg

run "MrFox_BlueBird_1920x1080_30.yuv" \
  "MrFox_BlueBird_1080p" 1920 1080 300 30 $codec -HD $options $skip_arg

run "Sintel_trailer_o537n480_1920x1080_24.yuv" \
  "Sintel_trailer_1080p" 1920 1080 480 24 $codec -HD $options $skip_arg

run "WITCHER3_1920x1080_60.yuv" \
  "WITCHER3_1080p" 1920 1080 600 60 $codec -HD $options $skip_arg

if [ -f $vidpath ]; then
  echo "error: specified file does not belong to the default test set: $vidpath"
  exit 1
fi
