#! /usr/bin/python3
##################################################################################
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
##################################################################################
########### James.Iwan@intel.com Measure Perf ####################################
########### Scott.Rowe@intel.com Measure Perf ####################################
import subprocess, sys, os, re, argparse, time, statistics, signal

os_env_DEVICE = os.environ.get('DEVICE' , "/dev/dri/renderD128")
device_name=os_env_DEVICE.split('/')[3]
temp_path = "/tmp/perf_" + device_name + "/"

###################################################################
# This shell script is currently not being Run/Execute on this automation.
# Creating the file only for debug purposes.
###################################################################
shell_script_mms = temp_path + "mms.sh"

d = open(shell_script_mms, 'r')
mediacmd_temp           = []
clip_session_iter_tag   = ""

for dispatch_cmdline in d:
    if re.search("echo ", dispatch_cmdline):
        clip_session_iter_tag = re.sub(r'echo ', "", dispatch_cmdline.rstrip())
        continue
    else:
        mediacmd_temp.append(dispatch_cmdline)
d.close()

#Execute Media MultiStreams
processes = [subprocess.Popen(cmd, shell=True, stderr=subprocess.PIPE, stdout=subprocess.PIPE) for cmd in mediacmd_temp]

# TOP monitors for specified period. Later we filter TOP output by PID to avoid
# any conflicts with data for other processes.
cpu_mem_monitor_cmd = "top -b -d 0.01 -i > " + temp_path + clip_session_iter_tag + "_TopSummary.txt &"
top_cpu_mem_process = subprocess.Popen(cpu_mem_monitor_cmd, shell=True, stderr=subprocess.PIPE, stdout=subprocess.PIPE)

#Monitor GPU_MEM Utilization
gpu_mem_monitor_cmd = "watch -n 0.01 -t -c 'sudo cat /sys/kernel/debug/dri/"+str(int(device_name[-3:])-128)+"/i915_gem_objects >> " + temp_path + clip_session_iter_tag + "_GemObjectSummary.txt 2>&1' &"
gem_gpu_mem_process     = subprocess.Popen(gpu_mem_monitor_cmd, shell=True, stderr=subprocess.PIPE, stdout=subprocess.PIPE)
gem_gpu_mem_process_pid = gem_gpu_mem_process.pid

for p in processes:
    p.wait()

os.system("killall top") # Kill Top Application.

for p in processes:
    if p.returncode != 0:
        exit(p.returncode)

top_cpu_mem_process.wait()
gem_gpu_mem_process.kill()  # stop the watch command everytime multistreams process has finished

os.system("killall watch") # kill all watch command , workaround.

############################################################################################
# Top CPU MEM filtered by applications
############################################################################################
top_cpu_mem_grep_cmd      = "grep -E '(sample|ffmpeg)' " + temp_path + clip_session_iter_tag + "_TopSummary.txt > " + temp_path + clip_session_iter_tag + "_cpumem_trace.txt"
top_cpu_mem_grep_process    = subprocess.Popen(top_cpu_mem_grep_cmd, shell=True, stderr=subprocess.PIPE, stdout=subprocess.PIPE)
top_cpu_mem_grep_process.wait()

############################################################################################
# GemObject GPU MEM filtered by applications
############################################################################################
gemobject_gpu_mem_trace_grep_cmd        = "grep -E '(sample_multi|ffmpeg|sample_decode)' " + temp_path + clip_session_iter_tag + "_GemObjectSummary.txt | grep -v '0 active' > " + temp_path + clip_session_iter_tag + "_gpumem_trace.txt"
gemobject_gpu_mem_trace_grep_process    = subprocess.Popen(gemobject_gpu_mem_trace_grep_cmd, shell=True, stderr=subprocess.PIPE, stdout=subprocess.PIPE)
gemobject_gpu_mem_trace_grep_process.wait()

