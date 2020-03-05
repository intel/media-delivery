#!/bin/bash

export ARTIFACTS=/opt/data/artifacts/ffmpeg-hls-server

export _scheduled=$ARTIFACTS/scheduled
export _done=$ARTIFACTS/done

function watch_server() {
  running=0
  completed=0
  if [ -f $_scheduled ]; then
    while read p; do
      name=$(echo "$p" | awk -F: '{print $2}')
      log=$(echo "$p" | awk -F: '{print $3}')
      if [ -f $_done ]; then
        done_line=$(fgrep $p $_done)
        if $!; then
          status=$(echo "$done_line" | awk -F: '{print $4}')
        fi
      fi

      fragments=$(ls -1 /var/www/hls/live/$name/stream_0/ 2>/dev/null | wc -l)

      line=$(cat $log | sed 's/\r/\n/' | grep frame= | tail -1)
      # frame= x fps= xx ...
      frames=$(echo $line | awk -F'[ |=]+' '{print $2}')
      fps=$(echo $line | awk -F'[ |=]+' '{print $4}')

      report_line=$(echo | awk \
        -v name=$name \
        -v frames=$frames \
        -v fps=$fps \
        -v fragments=$fragments \
        '{print "  " name ": frames=" frames ", fps=" fps ", fragments=" fragments}')
      if [ -n "$status" ]; then
        report_line+=$(echo | awk -v status=$status '{print ", status=" status}')
        completed=$((++completed))
        completed_reports+="${report_line}\n"
      else
        running=$((++running))
        running_reports+="${report_line}\n"
      fi
    done <$_scheduled
  fi

  echo "nginx server monitor"
  echo "===================="
  echo "Logs path: $ARTIFACTS"
  echo "Total requests: $((running+completed))"
  echo "Running requests: $running"
  echo -ne "$running_reports"
  echo "Completed requests: $completed"
  echo -ne "$completed_reports"

  echo
  echo "CTRL^C to exit monitor and enter shell"
}

export -f watch_server

watch -n 1 -x bash -c "watch_server ${pids[*]}"
# You can press CTRL^C to abort watch command and enter shell to wander about
/bin/bash
