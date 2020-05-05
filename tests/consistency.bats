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

# These are image consistency tests, i.e. tests which assure that
# self-built apps included into the image can actually be run (dependencies
# are satisfied).

@test "info is ready" {
  run docker_run info
  print_output
  [ $status -eq 0 ]
}

@test "ffmpeg is ready" {
  run docker_run ffmpeg --help
  print_output
  [ $status -eq 0 ]
}

@test "ffprobe is ready" {
  run docker_run ffprobe --help
  print_output
  [ $status -eq 0 ]
}

# this test is indirect check that ffmpeg patches were actually applied
# and user did not forget to rebuild image with --no-cache
@test "ffmpeg patches were applied" {
  run docker_run diff \
    /opt/intel/solutions/patches \
    /opt/intel/solutions/src/intel-media-delivery/patches
  print_output
  [ $status -eq 0 ]
}

@test "vmaf python tools are importable" {
  run docker_run python3 -c "import vmaf; help(vmaf)"
  print_output
  [ $status -eq 0 ]
}

@test "vmaf bdrate calculator works" {
  run docker_run python3 -c "$(cat << END
from vmaf.tools.bd_rate_calculator import BDrateCalculator;
setA = [(35, 21),(37, 25),(39, 28),(42, 30)];
setB = [(49, 28),(52, 32),(55, 35),(58, 37)];
print(int(BDrateCalculator.CalcBDRate(setA,setB)*100));
END
  )"
  print_output
  [ $status -eq 0 ]
  [ $output -eq 23 ]
}

@test "i915 pmu is ready" {
  run docker_run perf list
  print_output
  [ $status -eq 0 ]
  events=(${lines[@]})

  # i915 pmu is available from vanilla kernel 4.16
  if [[ $(uname -r)  =~ ^([0-9]+)\.([0-9]+) ]]; then
    if [[ ${BASH_REMATCH[1]} -le 3 || ${BASH_REMATCH[1]} -eq 4 && ${BASH_REMATCH[2]} -lt 16 ]]; then
      skip
    fi
  else
    echo "# bug: something is very wrong" >&3
    skip
  fi
  run grep_for "i915" ${events[@]}
  [ $status -eq 0 ]
  for e in ${events[@]};
  do
    if echo $e | grep i915; then
      ee=$(echo $e | sed 's/  */ /g' | sed 's/^ //g' | cut -d' ' -f1)
      run docker_run perf stat -a -e $ee whoami
      [ $status -eq 0 ]
      break # single working event is enough for us
    fi
  done
}
