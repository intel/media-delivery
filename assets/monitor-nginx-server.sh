#!/bin/bash

export ARTIFACTS=/opt/data/artifacts/ffmpeg-hls-server

export _scheduled=$ARTIFACTS/scheduled
export _done=$ARTIFACTS/done

function watch_server() {
  echo "nginx server monitor"
  echo "===================="
  s=$(cat $_scheduled 2>/dev/null | wc -l)
  d=$(cat $_done 2>/dev/null | wc -l)

  echo "Total requests: $s"

  echo "Running requests: $(($s-$d))"
  if [ -f $_scheduled ]; then
    # printing info for each currently running process
    while read p; do
      if ! fgrep $p $_done >/dev/null 2>&1; then
        name=$(echo "$p" | awk -F: '{print $2}')
        log=$(echo "$p" | awk -F: '{print $3}')

        line=$(cat $log | grep frame= | tail -1)
        # frame= x fps= xx ...
        frames=$(echo $line | awk -F'[ |=]+' '{print $2}')
        fps=$(echo $line | awk -F'[ |=]+' '{print $4}')

        echo | awk \
          -v name=$name \
          -v frames=$frames \
          -v fps=$fps \
          '{print "  " name ": frames=" frames ", fps=" fps}';
      fi
    done <$_scheduled
  fi

  echo "Completed: $d"
  if [ -f $_done ]; then
    # printing info for each currently running process
    while read p; do
      name=$(echo "$p" | awk -F: '{print $2}')
      log=$(echo "$p" | awk -F: '{print $3}')
      status=$(echo "$p" | awk -F: '{print $4}')

      line=$(cat $log | grep frame= | tail -1)
      # frame= x fps= xx ...
      frames=$(echo $line | awk -F'[ |=]+' '{print $2}')
      fps=$(echo $line | awk -F'[ |=]+' '{print $4}')

      echo | awk \
        -v name=$name \
        -v frames=$frames \
        -v fps=$fps \
        -v status=$status \
        '{print "  " name ": frames=" frames ", fps=" fps ", status=" status}';
    done <$_done
  fi

  echo
  echo "CTRL^C to exit monitor and enter shell"
}

export -f watch_server

watch -n 1 -x bash -c "watch_server ${pids[*]}"
# You can press CTRL^C to abort watch command and enter shell to wander about
/bin/bash
