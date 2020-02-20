#!/bin/bash

if [[ "$1" =~ ^(help|-help|--help|-h)$ ]]; then
  echo "Usage:"
  echo "  run_default_streams.sh help|-help|--help|-h"
  echo "  run_default_streams.sh AVC|HEVC default|best </path/to/streams>"
  echo ""
  echo "Options:"
  echo "  help|-help|--help|-h - print this help"
  echo "  AVC|HEVC             - encoder to use"
  echo "  default|best         - a set of encoding options to use"
  echo ""
  echo "Description:"
  echo "Encodes pre-defined default list of streams with the specified codec"
  echo "and ecoding options preset."
  echo "Input streams are searched in the provided path including subfolders."
  exit 0
fi

codec=$1
shift
options=$1
shift
vidpath=$1
shift

if [ -z "$codec" -o -z "$options" -o -z "$vidpath" ]; then
  echo "error: missing commnad line arguments, all are required"
  exit -1
fi

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

script_path=$(dirname $(readlink -f $0))

# 720p SD streams...

$script_path/run_quality.sh \
  $(find_stream "BoatNF_1280x720_60.yuv") \
  "Boat_720p" 1280 720 300 60 $codec -SD $options

$script_path/run_quality.sh \
  $(find_stream "crowd_run_1280x720_50.yuv") \
 "CrowdRun_720p" 1280 720 500 50 $codec -SD $options

$script_path/run_quality.sh \
  $(find_stream "Kimono1_1280x720_24.yuv") \
  "Kimono_720p" 1280 720 240 24 $codec -SD $options

$script_path/run_quality.sh \
  $(find_stream "FoodMarket2NF_1280x720_60.yuv") \
  "FoodMarket2_720p" 1280 720 300 60 $codec -SD $options

$script_path/run_quality.sh \
  $(find_stream "PierSeasideNF_1280x720_60.yuv") \
  "PierSeaside_720p" 1280 720 600 60 $codec -SD $options

$script_path/run_quality.sh \
  $(find_stream "TangoNF_1280x720_60.yuv") \
  "Tango_720p" 1280 720 294 60 $codec -SD $options

$script_path/run_quality.sh \
  $(find_stream "park_joy_1280x720_50.yuv") \
  "ParkJoy_720p" 1280 720 500 50 $codec -SD $options

$script_path/run_quality.sh \
  $(find_stream "ParkScene_1280x720_24.yuv") \
  "ParkScene_720p" 1280 720 240 24 $codec -SD $options

$script_path/run_quality.sh \
  $(find_stream "touchdown_pass_1280x720_30.yuv") \
  "TouchdownPass_720p" 1280 720 570 30 $codec -SD $options

# 1080p HD streams...

$script_path/run_quality.sh \
  $(find_stream "BasketballDrive_1920x1080_50.yuv") \
  "BasketballDrive_1080p" 1920 1080 500 50 $codec -HD $options

$script_path/run_quality.sh \
  $(find_stream "bq_terrace_1920x1080p_600_60.yuv") \
  "BQTerrace_1080p" 1920 1080 600 60 $codec -HD $options

$script_path/run_quality.sh \
  $(find_stream "Cactus_1920x1080_50.yuv") \
  "Cactus_1080p" 1920 1080 500 50 $codec -HD $options

$script_path/run_quality.sh \
  $(find_stream "crowd_run_1920x1080p_500_50.yuv") \
  "CrowdRun_1080p" 1920 1080 600 60 $codec -HD $options

$script_path/run_quality.sh \
  $(find_stream "DinnerScene_1920x1080_60.yuv") \
  "DinnerScene_1080p" 1920 1080 600 60 $codec -HD $options

$script_path/run_quality.sh \
  $(find_stream "park_joy_1920x1080_500_50.yuv") \
  "ParkJoy_1080p" 1920 1080 500 50 $codec -HD $options

$script_path/run_quality.sh \
  $(find_stream "Kimono1_1920x1080_24.yuv") \
  "Kimono_1080p" 1920 1080 240 24 $codec -HD $options

$script_path/run_quality.sh \
  $(find_stream "RedKayak_1920x1080_30.yuv") \
  "RedKayak_1080p" 1920 1080 570 30 $codec -HD $options

$script_path/run_quality.sh \
  $(find_stream "RushFieldCuts_1920x1080_30.yuv") \
  "RushFieldCuts_1080p" 1920 1080 570 30 $codec -HD $options

$script_path/run_quality.sh \
  $(find_stream "Bunny_1920x1080_24_600.yuv") \
  "Bunny_1080p" 1920 1080 600 24 $codec -HD $options

$script_path/run_quality.sh \
  $(find_stream "CSGO_1920x1080_60.yuv") \
  "CSGO_1080p" 1920 1080 600 60 $codec -HD $options

$script_path/run_quality.sh \
  $(find_stream "DOTA2_1920x1080_60_600.yuv") \
  "DOTA2_1080p" 1920 1080 600 60 $codec -HD $options

$script_path/run_quality.sh \
  $(find_stream "GTAV_1920x1080_60_600.yuv") \
  "GTAV_1080p" 1920 1080 600 60 $codec -HD $options

$script_path/run_quality.sh \
  $(find_stream "Hearthstone_1920x1080_60.yuv") \
  "Hearthstone_1080p" 1920 1080 600 60 $codec -HD $options

$script_path/run_quality.sh \
  $(find_stream "MINECRAFT_1920x1080_60_600.yuv") \
  "MINECRAFT_1080p" 1920 1080 600 60 $codec -HD $options

$script_path/run_quality.sh \
  $(find_stream "MrFox_BlueBird_1920x1080_30.yuv") \
  "MrFox_BlueBird_1080p" 1920 1080 300 30 $codec -HD $options

$script_path/run_quality.sh \
  $(find_stream "Sintel_trailer_o537n480_1920x1080_24.yuv") \
  "Sintel_trailer_1080p" 1920 1080 480 24 $codec -HD $options

$script_path/run_quality.sh \
  $(find_stream "WITCHER3_1920x1080_60.yuv") \
  "WITCHER3_1080p" 1920 1080 600 60 $codec -HD $options
