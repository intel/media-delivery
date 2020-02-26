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

##################################################################################
# Benchmark automation flow: (by intel pnp silicon lab)
##################################################################################
import subprocess, sys, os, re, argparse, time, statistics, signal


########### James.Iwan@intel.com Bench Perf ######################################
class MediaContent:
    width = height = fps_limit = benchmark_stream = benchmark_fps = init_stream_number = linux_perf_cmdlines = 0
    def name (self, name):
        self.name = name
    def height (self, height):
        self.height = height
    def fps_limit (self, fps_limit):
        self.fps_limit = fps_limit
    def width(self, width):
        self.width = width
    def codec(self, codec):
        self.codec = codec
    def benchmark_stream (self, benchmark_stream):
        self.benchmark_stream = benchmark_stream
    def benchmark_fps (self, benchmark_fps):
        self.benchmark_fps = benchmark_fps
    def init_stream_number (self, init_stream_number):
        self.init_stream_number = init_stream_number
    def dispatch_cmdline (self, dispatch_cmdline):
        self.dispatch_cmdline = dispatch_cmdline
    def temp_path (self, temp_path):
        self.temp_path = temp_path
    def linux_perf_dump (self, linux_perf_dump):
        self.linux_perf_dump = linux_perf_dump
    def linux_perf_gpu_freq_trace_dump (self, linux_perf_gpu_freq_trace_dump):
        self.linux_perf_gpu_freq_trace_dump = linux_perf_gpu_freq_trace_dump
    def filename_gpu_freq_trace (self, filename_gpu_freq_trace):
        self.filename_gpu_freq_trace = filename_gpu_freq_trace
    def linux_perf_mem_bw_trace_dump (self, linux_perf_mem_bw_trace_dump):
        self.linux_perf_mem_bw_trace_dump = linux_perf_mem_bw_trace_dump
    def filename_mem_bw_trace (self, filename_mem_bw_trace):
        self.filename_mem_bw_trace = filename_mem_bw_trace
    def tool_linux_perf_trace (self, tool_linux_perf_trace):
        self.tool_linux_perf_trace = tool_linux_perf_trace
    def linux_perf_cmdlines(self, linux_perf_cmdlines):
        self.linux_perf_cmdlines = linux_perf_cmdlines
    def ffmpeg_mode (self, ffmpeg_mode):
        self.ffmpeg_mode = ffmpeg_mode

########### James.Iwan@intel.com Bench Perf ######################################
def main():
    startTime = time.time()
    # Collect command line arguments
    parser = argparse.ArgumentParser(description='MEDIA MULTISTREAM BENCHMARKING v0.20.04.27')
    parser.add_argument('workloads_path',help='Full path option for workload_directories/ OR for single workload_file')
    parser.add_argument('--skip-ffmpeg', '--skip_ffmpeg', action='store_true', help='skipping benchmark that use FFMPEG app')
    parser.add_argument('--skip-msdk', '--skip_msdk', action='store_true', help='skipping benchmark that use MSDK/Sample app')
    parser.add_argument('--skip-perf', '--skip_perf', action='store_true', help='skipping linux perf stat Utilization, such as VD0/VD1/RCS/etc')
    parser.add_argument('--skip-perf-trace', '--skip_perf_trace', action='store_true', help='skipping linux perf stat additional Traces, such as GT-Freq/BW-Rd/BW-Wr/etc')
    parser.add_argument('-codec', '--encode_codec', help='Default both AVC/HEVC, AVC only, or HEVC only')
    parser.add_argument('-s', '--initialized_multiStream', help='Custom initialized concurrent of multi stream e.g. -s 720p:8,1080p:5,2160p:2')
    parser.add_argument('-n', '--numbers_of_iteration', help='Custom limit the number of iteration of each same execution (max is 4)')
    parser.add_argument('-content_fps', '--overwrite_content_fps', help='Only for -w <file> , to overwrite content_fps_list target e.g. (-w ../content.hevc -content_fps_list 50 -content_resolution 1080p )')
    parser.add_argument('-content_resolution', '--overwrite_content_resolution', help='Only for -w <file> , to overwrite content_resolution choices target e.g. (-w ../content.hevc -content_fps_list 50 -content_resolution 1080p )')
    parser.add_argument('-w_max', '--numbers_of_Workloads', help='Custom limit the number of total workloads to be executed')
    parser.add_argument('-c', '--constraint', action='store_true', help='Constraint the fps into content-fps with 0.02 margin limit, (.e.g adding -fps into command line)')
    parser.add_argument('-o', '--user_artifact_path', help='output directory for any artifacts')
    parser.add_argument('-log', '--output_log_file', help='print any run-log into this file onto main directory')
    parser.add_argument('-v', '--verbose', action='store_true', help='Dump debug related printout, such as each-cmdlines/version-log/etc')
    global benchmarkargs
    benchmarkargs = parser.parse_args()

    ################################# Baremetal or Docker/Container check ##################################
    artifacts_path_docker           = "/opt/data/artifacts"
    artifacts_path_baremetal        = os.getenv("HOME")
    isInsideContainer               = os.system("grep docker /proc/1/cgroup -qa")

    if str(benchmarkargs.user_artifact_path) != "None":
        artifacts_path_users = os.path.realpath(benchmarkargs.user_artifact_path)
        artifact_path = artifacts_path_users + "/"
    elif isInsideContainer == 0:
        artifact_path = artifacts_path_docker  + "/benchmark/perf/"
    else:
        artifact_path = artifacts_path_baremetal  + "/benchmark/perf/"

    ################################# Variable Assignment #################################################
    starting_streamnumber           = str(benchmarkargs.initialized_multiStream) if benchmarkargs.initialized_multiStream else "all:1"
    maximum_iteration               = int(benchmarkargs.numbers_of_iteration) if benchmarkargs.numbers_of_iteration else 1
    maximum_workloads               = int(benchmarkargs.numbers_of_Workloads) if benchmarkargs.numbers_of_Workloads else 20
    debug_verbose                   = True if benchmarkargs.verbose else False
    tool_linux_perf                 = False if benchmarkargs.skip_perf else True
    tool_linux_perf_trace           = False if benchmarkargs.skip_perf_trace else True
    fps_constraint_enable           = True if benchmarkargs.constraint else False
    skip_ffmpeg                     = True if benchmarkargs.skip_ffmpeg else False
    skip_msdk                       = True if benchmarkargs.skip_msdk else False
    encode_codec                    = str(benchmarkargs.encode_codec).lower() if benchmarkargs.encode_codec else "all"
    overwrite_content_fps           = float(benchmarkargs.overwrite_content_fps) if benchmarkargs.overwrite_content_fps else 0
    overwrite_content_resolution    = str(benchmarkargs.overwrite_content_resolution) if benchmarkargs.overwrite_content_resolution else "unavailable"
    script_root_path                = os.path.dirname(os.path.realpath(__file__))
    output_log_filename             = str(benchmarkargs.output_log_file) if str(benchmarkargs.output_log_file) != "None" else "benchperf.txt"
    temp_path                       = "/tmp/perf/"
    ##################################################################################
    # Initiate artifacts directory
    ##################################################################################
    try:
        # checks if path is a directory
        isDirectory = os.path.isdir(artifact_path)
        if not isDirectory:
            os.system("mkdir -p " + artifact_path)

        output_log_file                 = artifact_path + output_log_filename
        output_log_handle               = open(output_log_file, 'w')
    except:
        message_block(output_log_handle,'red', 'Unable to create artifact path ' + artifact_path)
        raise
    ######################################################################################################
    if debug_verbose:
        printLog(output_log_handle, '#' * 69)
        printLog(output_log_handle, 'PNP MEDIA BENCHMARKING v0.20.04.28')
        printLog(output_log_handle, '#' * 69 + '\n')
    ######################################################################################################
    # Linux Perf pre-req
    ######################################################################################################
    try:
        if tool_linux_perf and tool_linux_perf_trace:
            import matplotlib
            matplotlib.use('Agg')
    except:
        message_block(output_log_handle,'red', 'Unable to import matplotlib: ')
        raise
    ######################################################################################################
    # output path and header creation
    ######################################################################################################
    try:
        ##################################################################################
        # Initiate temporary directory for calculation and post-processing data.
        ##################################################################################
        directory_check = os.path.isdir(temp_path)
        if not directory_check:
            os.system("mkdir " + temp_path)
        else:
            os.system("rm -rf " + temp_path)
            os.system("mkdir " + temp_path)

        local_output_path = artifact_path + "output/" # all the Metrics/Summary/Traces will be copy further into the current directory.
        directory_check = os.path.isdir(local_output_path)
        if not directory_check: os.system("mkdir " + local_output_path)

        ###############################################
        # assigning initial multistream as per resolution options
        ###############################################
        init_stream_720p = 1
        init_stream_1080p = 1
        init_stream_2160p = 1
        if starting_streamnumber != "all:1":
            starting_streamnumber_split = starting_streamnumber.split(',')
            init_stream_720p = 0
            init_stream_1080p = 0
            init_stream_2160p = 0
            for resolution_mode in starting_streamnumber_split:
                resolution_mode_split = resolution_mode.split(':')
                if resolution_mode_split[1].isdigit():
                    if "720p:" in resolution_mode:
                        init_stream_720p = int(resolution_mode_split[1])
                    elif "1080p:" in resolution_mode:
                        init_stream_1080p = int(resolution_mode_split[1])
                    elif "2160p:" in resolution_mode:
                        init_stream_2160p = int(resolution_mode_split[1])
                    else:
                        printLog(output_log_handle, "ERROR: Syntax incorrect, Can not find resolution, please follow an example: -s 720p:8,1080p:5,2160p:2, and Try again")
                        return ()
                else:
                    printLog(output_log_handle, "ERROR: Syntax incorrect, Value is not integer,", resolution_mode_split[1], "please follow an example: -s 720p:8,1080p:5,2160p:2, and Try again")
                    return()
    except:
        message_block(output_log_handle,'red', 'Unable to create directory or inaccessible: ' + local_output_path)
        raise

    ######################################################################################################
    # Setup for Workloads directory or a  single Workload benchmarking
    ######################################################################################################
    try:
        benchmarkargs.workloads_path = os.path.realpath(benchmarkargs.workloads_path)

        # checks if path is a directory
        isDirectory = os.path.isdir(benchmarkargs.workloads_path)

        # checks if path is a file
        isFile = os.path.isfile(benchmarkargs.workloads_path)

        benchmark_sweeping_table = {}
        content_fps_list    = {}
        content_height_list = {}
        content_codec_list  = {}
        benchmark_object_list = {}
        printLog(output_log_handle, "\n")
        printLog(output_log_handle, '#' * 69)

        if (isDirectory):
            content_path = str(benchmarkargs.workloads_path)
            if (content_path[-1] != "/"):
                content_path = content_path + "/"
            #################################################################################
            # Contentlist naming convention array <content_name>_<resolution>_<bitrate>_<fps>_<totalFrames>.<codec>
            # jiwan
            ##################################################################################
            content_list_filename = temp_path + "content.list"
            cmd_generate_content_list = "ls " + content_path + " | grep -E '\.h264|\.hevc|\.h265' > " + content_list_filename
            generate_list_status = os.system(cmd_generate_content_list)

            with open(content_list_filename, "r") as content_list_temp_fh:
                for content_filename in content_list_temp_fh:
                    content_filename = content_filename.rstrip()

                    printLog (output_log_handle, " Profiling: " + content_filename)

                    if ffmpegffprobeCheck(output_log_handle, content_path, content_filename, temp_path, debug_verbose, benchmark_sweeping_table, content_fps_list, content_height_list, content_codec_list, benchmark_object_list):
                        if debug_verbose:
                            printLog(output_log_handle, " PASS: via FFMPEG/FFPROBE")

                    elif ContentNamingCheck(output_log_handle, content_filename, benchmark_sweeping_table, content_fps_list, content_height_list, content_codec_list):
                        if debug_verbose:
                            printLog(output_log_handle, " PASS: via File-Naming-Format")

                    if debug_verbose:
                        printLog(output_log_handle, " content_fps =", content_fps_list[content_filename], ", content_height =", content_height_list[content_filename], ", content_codec =", content_codec_list[content_filename], ", initialized_benchmark =", benchmark_sweeping_table[content_filename], "\n")

            content_list_temp_fh.close()

        elif (isFile):
            content_path, content_filename = os.path.split(benchmarkargs.workloads_path)
            content_path = content_path + "/" # required because the extraction dir/filename above doesn't include the "/" character.
            printLog(output_log_handle, " Profiling: " + content_filename)

            if ffmpegffprobeCheck(output_log_handle, content_path, content_filename, temp_path, debug_verbose, benchmark_sweeping_table, content_fps_list, content_height_list, content_codec_list, benchmark_object_list):
                if debug_verbose:
                    printLog(output_log_handle, " PASS: via FFMPEG/FFPROBE")

            elif ContentNamingCheck(output_log_handle, content_filename, benchmark_sweeping_table, content_fps_list, content_height_list, content_codec_list):
                if debug_verbose:
                    printLog(output_log_handle, " PASS: via File-Naming-Format")

            if debug_verbose:
                printLog(output_log_handle, " content_fps =", content_fps_list[content_filename], ", content_height =", content_height_list[content_filename], ", content_codec =", content_codec_list[content_filename], ", initialized_benchmark =", benchmark_sweeping_table[content_filename], "\n")

            if (float(overwrite_content_fps) > 0):
                content_fps_list[content_filename] = float(overwrite_content_fps)

        else:
            message_block(output_log_handle,'red', 'Unable to locate required workload path: ' + benchmarkargs.workloads_path)
            raise


    except:
        message_block(output_log_handle,'red', 'Unable to locate required workload path: ' + benchmarkargs.workloads_path + " OR ")
        message_block(output_log_handle,'red', "found an incorrect content (.hevc/.h264/etc) naming convention : " + content_filename)
        message_block(output_log_handle,'white', "Install FFMPEG/FFPROBE OR Rename content to the following format <clipname>_<width>x<height>p_<bitrate>_<content_fps>_<total_frames>.<codec>")
        raise

    ##################################################################################
    # Iterating benchmark applications
    # 1st SMT
    # 2nd FFMPEG
    # 3rd TBD/continue..
    ##################################################################################
    startTime_application = time.time()
    for benchmark_applications in range (2):
        required_information_file = os.path.dirname(os.path.realpath(__file__))
        if (benchmark_applications == 0) and not skip_msdk:
            required_information_file += "/por_SMT_LB.txt"
            ffmpeg_mode = False
            benchmark_app_tag = "SMT"
        elif (benchmark_applications == 1) and not skip_ffmpeg:
            required_information_file += "/por_FFMPEG_LB.txt"
            ffmpeg_mode = True
            benchmark_app_tag = "FFMPEG"
        else:
            continue
        ######################################################################################################
        # command line based on resolution
        ######################################################################################################
        try:
            with open(required_information_file, 'r') as configfile:
                for workloadline in configfile:
                    if (not re.search("^#", str(workloadline))):
                        if (re.search(r"^720p_hevc-avc:\s", str(workloadline))): benchmark_cmdline_720p_hevc2avc = workloadline.replace("720p_hevc-avc: ", "")
                        if (re.search(r"^1080p_hevc-avc:\s", str(workloadline))): benchmark_cmdline_1080p_hevc2avc = workloadline.replace("1080p_hevc-avc: ", "")
                        if (re.search(r"^2160p_hevc-avc:\s", str(workloadline))): benchmark_cmdline_2160p_hevc2avc = workloadline.replace("2160p_hevc-avc: ", "")
                        if (re.search(r"^720p_avc-avc:\s", str(workloadline))): benchmark_cmdline_720p_avc2avc = workloadline.replace("720p_avc-avc: ", "")
                        if (re.search(r"^1080p_avc-avc:\s", str(workloadline))): benchmark_cmdline_1080p_avc2avc = workloadline.replace("1080p_avc-avc: ", "")
                        if (re.search(r"^2160p_avc-avc:\s", str(workloadline))): benchmark_cmdline_2160p_avc2avc = workloadline.replace("2160p_avc-avc: ", "")
                        if (re.search(r"^720p_hevc-hevc:\s", str(workloadline))): benchmark_cmdline_720p_hevc2hevc = workloadline.replace("720p_hevc-hevc: ", "")
                        if (re.search(r"^1080p_hevc-hevc:\s", str(workloadline))): benchmark_cmdline_1080p_hevc2hevc = workloadline.replace("1080p_hevc-hevc: ", "")
                        if (re.search(r"^2160p_hevc-hevc:\s", str(workloadline))): benchmark_cmdline_2160p_hevc2hevc = workloadline.replace("2160p_hevc-hevc: ", "")
        except:
            message_block(output_log_handle,'red', 'Unable to locate required file: ' + benchmarkargs.required_information_file)
            raise


        ##################################################################################
        # Iterating benchmark sequence
        # 1st HEVC-AVC
        # 2nd AVC-AVC
        # 3rd HEVC-HEVC
        # 4th TBD/continue..
        ##################################################################################
        startTime_sequence = time.time()
        for benchmark_sequence in range(3):
            ##################################################################################
            # Initiate outputfile benchmark result as per last best stream# and fps#
            # Initiate outputfile benchmark table sweep as per last best stream# and fps#
            ##################################################################################
            if benchmark_sequence == 0 and (encode_codec == "all" or encode_codec == "avc"):
                output_log_file_benchmark_media = re.sub(r'.txt', "_" + benchmark_app_tag + "_hevc2avc_benchmark.csv",output_log_file)
                output_log_file_benchmark_sweep = re.sub(r'.txt',"_" + benchmark_app_tag + "_hevc2avc_benchmark_table_sweep.csv",output_log_file)
                benchmark_tag = "HEVC-AVC"
            elif benchmark_sequence == 1 and (encode_codec == "all" or encode_codec == "avc"):
                output_log_file_benchmark_media = re.sub(r'.txt', "_" + benchmark_app_tag + "_avc2avc_benchmark.csv",output_log_file)
                output_log_file_benchmark_sweep = re.sub(r'.txt',"_" + benchmark_app_tag + "_avc2avc_benchmark_table_sweep.csv",output_log_file)
                benchmark_tag = "AVC-AVC"
            elif benchmark_sequence == 2 and (encode_codec == "all" or encode_codec == "hevc"):
                output_log_file_benchmark_media = re.sub(r'.txt', "_" + benchmark_app_tag + "_hevc2hevc_benchmark.csv",output_log_file)
                output_log_file_benchmark_sweep = re.sub(r'.txt',"_" + benchmark_app_tag + "_hevc2hevc_benchmark_table_sweep.csv",output_log_file)
                benchmark_tag = "HEVC-HEVC"
            else:
                continue

            ##################################################################################
            # Initiate temporary directory for calculation and post-processing data.
            ##################################################################################
            directory_check = os.path.isdir(temp_path)
            if not directory_check:
                os.system("mkdir " + temp_path)
            else:
                os.system("rm -rf " + temp_path)
                os.system("mkdir " + temp_path)

            for a in range(int(maximum_iteration)):
                iteration_path_cmd = temp_path + "iteration_" + str(a)
                directory_check = os.path.isdir(iteration_path_cmd)
                if not directory_check: os.system("mkdir " + iteration_path_cmd)

            bm_output_handle = open(output_log_file_benchmark_media, 'w')
            benchmark = "clipname, benchmark_session, fps, runtime(s), GPU_Vid0(%), GPU_Vid1(%), GPU_Render(%), CPU_All(%), RC6(%), GPU_Freq_Avg(MHz)\n"
            bm_output_handle.write(benchmark)
            benchmark_table_sweep = output_log_file_benchmark_sweep
            bt_output_handle = open(benchmark_table_sweep, 'w')

            ########### James.Iwan@intel.com Bench Perf ######################################
            # ITERATION/WORKLOADS/etc START HERE
            ##################################################################################
            for key in content_fps_list:
                curContent = key.rstrip()

                #printLog(output_log_handle, "CLEANUP:", benchmark_object_list[curContent], key)
                if benchmark_sequence == 0 and (encode_codec == "all" or encode_codec == "avc"):  # HEVC-AVC benchmark sequence
                    if benchmark_object_list[curContent].codec != "hevc":  # skip if its not HEVC input clip
                        continue
                elif benchmark_sequence == 1 and (encode_codec == "all" or encode_codec == "avc"):  # AVC-AVC benchmark sequence
                    if benchmark_object_list[curContent].codec != "h264":  # skip if its not h264 input clip
                        continue
                elif (benchmark_sequence == 2) and (encode_codec == "all" or encode_codec == "hevc"):  # HEVC-HEVC benchmark sequence
                    if benchmark_object_list[curContent].codec != "hevc":  # skip if its not HEVC input clip
                        continue
                else:
                    continue
                ##################################################################################
                # Create initialize streamnumber for each resolution
                ##################################################################################
                if benchmark_object_list[curContent].height == 720:
                    streamnumber = init_stream_720p
                    benchmark_object_list[curContent].init_stream_number = init_stream_720p
                elif benchmark_object_list[curContent].height == 1080:
                    streamnumber = init_stream_1080p
                    benchmark_object_list[curContent].init_stream_number = init_stream_1080p
                elif benchmark_object_list[curContent].height == 2160:
                    streamnumber = init_stream_2160p
                    benchmark_object_list[curContent].init_stream_number = init_stream_2160p
                else:
                    streamnumber = 1
                    benchmark_object_list[curContent].init_stream_number = 1

                nextStreamNumber = True if int(streamnumber) > 0 else False
                content_fps_limit = 0
                benchmark_stream = 0
                benchmark_fps = 0
                benchmark_exetime = 0
                benchmark_vid0_u = 0
                benchmark_vid1_u = 0
                benchmark_render_u = 0
                benchmark_cpu_u = 0
                benchmark_rc6_u = 0
                benchmark_avg_freq = 0

                while nextStreamNumber:
                    shell_script_mms = temp_path + "mms.sh" # Move this to /tmp/perf/
                    shell_script_handle = open(shell_script_mms, 'w')
                    avg_fps = exetime = vid0_u = vid1_u = render_u = avg_freq = 0
                    avg_fps_split = []
                    ##################################################################################
                    # Creates Unique Concurrent Command Lines
                    ##################################################################################
                    content_split = key.replace('.', '_').split('_')
                    linux_perf_stream_number = content_split[0] + "_" + content_split[1] + "_" + str(streamnumber) + "_streams"
                    if fps_constraint_enable:
                        fps_constraint = benchmark_object_list[curContent].fps_limit
                    else:
                        fps_constraint  = 0

                    for m in range(int(streamnumber)):
                        ##################################################################################
                        # Construct 720p/1080p/2160p Command lines for
                        ##################################################################################
                        dispatch_cmdline = transcode_input_clip = "N/A"
                        if benchmark_sequence == 0 and (encode_codec == "all" or encode_codec == "avc"): # HEVC-AVC benchmark sequence
                            if benchmark_object_list[curContent].height == 720 or re.search(r"720p", overwrite_content_resolution):
                                dispatch_cmdline = benchmark_cmdline_720p_hevc2avc
                            elif benchmark_object_list[curContent].height == 1080 or re.search(r"1080p", overwrite_content_resolution):
                                dispatch_cmdline = benchmark_cmdline_1080p_hevc2avc
                            elif benchmark_object_list[curContent].height == 2160 or re.search(r"2160p", overwrite_content_resolution):
                                dispatch_cmdline = benchmark_cmdline_2160p_hevc2avc
                        elif benchmark_sequence == 1 and (encode_codec == "all" or encode_codec == "avc"): # AVC-AVC benchmark sequence
                            if benchmark_object_list[curContent].height == 720 or re.search(r"720p", overwrite_content_resolution):
                                dispatch_cmdline = benchmark_cmdline_720p_avc2avc
                            elif benchmark_object_list[curContent].height == 1080 or re.search(r"1080p", overwrite_content_resolution):
                                dispatch_cmdline = benchmark_cmdline_1080p_avc2avc
                            elif benchmark_object_list[curContent].height == 2160 or re.search(r"2160p", overwrite_content_resolution):
                                dispatch_cmdline = benchmark_cmdline_2160p_avc2avc
                        elif benchmark_sequence == 2 and (encode_codec == "all" or encode_codec == "hevc"): # HEVC-HEVC benchmark sequence
                            if benchmark_object_list[curContent].height == 720 or re.search(r"720p", overwrite_content_resolution):
                                dispatch_cmdline = benchmark_cmdline_720p_hevc2hevc
                            elif benchmark_object_list[curContent].height == 1080 or re.search(r"1080p", overwrite_content_resolution):
                                dispatch_cmdline = benchmark_cmdline_1080p_hevc2hevc
                            elif benchmark_object_list[curContent].height == 2160 or re.search(r"2160p", overwrite_content_resolution):
                                dispatch_cmdline = benchmark_cmdline_2160p_hevc2hevc

                        if (ffmpeg_mode):
                            transcode_input_clip = "-i " + content_path + key
                            dispatch_cmdline = dispatch_cmdline.replace("-i <>", transcode_input_clip)

                        else: # SMT section (DEFAULT)
                            if re.search(r".*\.hevc", key):
                                transcode_input_clip = "-i::h265 " + content_path + key
                                dispatch_cmdline = dispatch_cmdline.replace("-i::h265 <>", transcode_input_clip)
                            elif re.search(r".*\.h264", key):
                                transcode_input_clip = "-i::h264 " + content_path + key
                                dispatch_cmdline = dispatch_cmdline.replace("-i::h264 <>", transcode_input_clip)

                        ######################################################################################################
                        # this below code is for constructing unique output for each session.
                        # e.g. Crowdrun_720p_output_1.264, Crowdrun_720p_output_2.264,
                        # and constructing unique log file for each session for further post processing
                        # e.g. Crowdrun_720p_log_1.txt, Crowdrun_720p_log_2.txt,
                        # jiwan
                        ##################################################################################
                        if (ffmpeg_mode):
                            if fps_constraint_enable:
                                transcode_output_clip = "-maxrate " + str(fps_constraint) + " -y " + temp_path + content_split[0] + "_" + content_split[1] + "_" + str(m)
                            else:
                                transcode_output_clip = local_output_path + content_split[0] + "_" + content_split[1] + "_" + str(m)

                        else: # SMT section (DEFAULT)
                            if fps_constraint_enable:
                                transcode_output_clip = "-fps " + str(fps_constraint) + " -o::h264 " + temp_path + content_split[0] + "_" + content_split[1] + "_" + str(m)
                            else:
                                transcode_output_clip = local_output_path + content_split[0] + "_" + content_split[1] + "_" + str(m)

                        if (ffmpeg_mode):
                            dispatch_cmdline = dispatch_cmdline.replace("-y <>", "-y " + transcode_output_clip)

                        else: # SMT section (DEFAULT)
                            dispatch_cmdline = dispatch_cmdline.replace("-o::h264 <>", "-o::h264 " + transcode_output_clip)
                            dispatch_cmdline = dispatch_cmdline.replace("-o::h265 <>", "-o::h265 " + transcode_output_clip)

                        if (ffmpeg_mode):
                            transcode_output_logfile = " 2> " + temp_path + content_split[0] + "_" + content_split[1] + "_" + str(streamnumber) + "_" + str(m) + "_transcode_log.txt"
                            dispatch_cmdline = dispatch_cmdline.replace("-report", transcode_output_logfile).rstrip()

                        else: # SMT section (DEFAULT)
                            transcode_output_logfile = " -p " + temp_path + content_split[0] + "_" + content_split[1] + "_" + str(m) + "_transcode_log.txt"
                            dispatch_cmdline = dispatch_cmdline.replace("-p <>", transcode_output_logfile).rstrip()

                        ##################################################################################
                        # Adding piping to log file and strip out the error messages
                        ##################################################################################
                        if (ffmpeg_mode):
                            dispatch_cmdline = dispatch_cmdline + "\n"

                        else: # SMT section (DEFAULT)
                            dispatch_cmdline = dispatch_cmdline + " >> " + temp_path + "console_log.txt 2>&1" + "\n"

                        benchmark_object_list[curContent].dispatch_cmdline = dispatch_cmdline
                        shell_script_handle.write(dispatch_cmdline)
                    shell_script_handle.close()

                    nextStreamNumber0 = False
                    nextStreamNumber1 = False
                    nextStreamNumber2 = False
                    nextStreamNumber3 = False

                    ##################################################################################
                    # Dispatch and Post Process each result +-2%
                    ##################################################################################
                    for j in range(maximum_iteration):
                        printLog(output_log_handle, "\n")
                        printLog(output_log_handle, '#' * 69)
                        print_benchmark_label = "PNP MEDIA " + benchmark_app_tag + " " + benchmark_tag + ": " + "MULTISTREAM: " + str(streamnumber) + " & ITERATION: " + str(j)
                        printLog(output_log_handle, print_benchmark_label)
                        printLog(output_log_handle, '#' * 69)

                        linux_perf_dump = temp_path + linux_perf_stream_number + "_" + str(j) + "_metrics.txt"
                        filename_gpu_freq_trace = linux_perf_stream_number + "_" + str(j) + "_gpu_freq_traces"
                        linux_perf_gpu_freq_trace_dump = temp_path + filename_gpu_freq_trace + ".txt"
                        filename_mem_bw_trace = linux_perf_stream_number + "_" + str(j) + "_mem_bw_traces"
                        linux_perf_mem_bw_trace_dump = temp_path + filename_mem_bw_trace + ".txt"


                        benchmark_object_list[curContent].temp_path                       = temp_path
                        benchmark_object_list[curContent].linux_perf_dump                 = linux_perf_dump
                        benchmark_object_list[curContent].filename_gpu_freq_trace         = filename_gpu_freq_trace
                        benchmark_object_list[curContent].linux_perf_gpu_freq_trace_dump  = linux_perf_gpu_freq_trace_dump
                        benchmark_object_list[curContent].filename_mem_bw_trace           = filename_mem_bw_trace
                        benchmark_object_list[curContent].linux_perf_mem_bw_trace_dump    = linux_perf_mem_bw_trace_dump
                        benchmark_object_list[curContent].tool_linux_perf_trace           = tool_linux_perf_trace
                        benchmark_object_list[curContent].ffmpeg_mode                     = ffmpeg_mode

                        ########### Scott.Rowe@intel.com Linux Perf ################################################
                        metrics = 'i915/actual-frequency/,i915/bcs0-busy/,i915/bcs0-sema/,i915/bcs0-wait/,i915/interrupts/,i915/rc6-residency/,i915/rcs0-busy/,i915/rcs0-sema/,i915/rcs0-wait/,i915/requested-frequency/,i915/vcs0-busy/,i915/vcs0-sema/,i915/vcs0-wait/,i915/vcs1-busy/,i915/vcs1-sema/,i915/vcs1-wait/,i915/vecs0-busy/,i915/vecs0-sema/,i915/vecs0-wait/,msr/tsc/,duration_time,mem-loads,mem-stores,cycle_activity.cycles_mem_any,task-clock,cycles,instructions,branches,branch-misses,cache-references,cache-misses,LLC-loads,LLC-load-misses,LLC-stores,LLC-store-misses,uncore_imc/data_reads/,uncore_imc/data_writes/ '
                        gpu_freq_traces = 'i915/actual-frequency/'
                        mem_bw_traces = 'uncore_imc/data_reads/,uncore_imc/data_writes/'

                        linux_perf_cmdlines = os.path.dirname(os.path.realpath(__file__)) + "/MMSStandAlone.py"
                        if tool_linux_perf:
                            linux_perf_cmdlines = "perf stat -a -e {} -o " + linux_perf_dump + " " + linux_perf_cmdlines
                            linux_perf_cmdlines = linux_perf_cmdlines.format(metrics)
                            linux_perf_cmdlines = "perf stat -I 100 -a -e {} -o " + linux_perf_gpu_freq_trace_dump + " " + linux_perf_cmdlines
                            linux_perf_cmdlines = linux_perf_cmdlines.format(gpu_freq_traces)
                            linux_perf_cmdlines = "perf stat -I 100 -a -e {} -o " + linux_perf_mem_bw_trace_dump + " " + linux_perf_cmdlines
                            linux_perf_cmdlines = linux_perf_cmdlines.format(mem_bw_traces)


                        benchmark_object_list[curContent].linux_perf_cmdlines = linux_perf_cmdlines

                        p = subprocess.Popen(linux_perf_cmdlines, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
                        p.wait()
                        ############################################################################################

                        nextStreamNumber0, avg_fps, exetime, vid0_u, vid1_u, render_u, cpu_u, rc6_u, avg_freq = postprocess_multistream(output_log_handle, streamnumber, j, debug_verbose, benchmark_object_list[curContent])

                        if j == 0:
                            move_command = "mv " + temp_path + "*transcode_log.txt " + temp_path + "iteration_0/."
                            os.system(move_command)
                            avg_fps_split.append(avg_fps)
                        if j == 1:
                            move_command = "mv " + temp_path + "*transcode_log.txt " + temp_path + "iteration_1/."
                            os.system(move_command)
                            avg_fps_split.append(avg_fps)
                        if j == 2:
                            move_command = "mv " + temp_path + "*transcode_log.txt " + temp_path + "iteration_2/."
                            os.system(move_command)
                            avg_fps_split.append(avg_fps)
                        if j == 3:
                            move_command = "mv " + temp_path + "*transcode_log.txt " + temp_path + "iteration_3/."
                            os.system(move_command)
                            avg_fps_split.append(avg_fps)

                        printLog(output_log_handle, "ITERATION: Done")

                    ##################################################################################
                    # Compare and Decide
                    ##################################################################################
                    if nextStreamNumber0 or nextStreamNumber1 or nextStreamNumber2 or nextStreamNumber3:
                        benchmark_stream    = streamnumber
                        benchmark_fps       = round(statistics.mean(avg_fps_split),1)
                        benchmark_exetime   = exetime
                        benchmark_vid0_u    = vid0_u
                        benchmark_vid1_u    = vid1_u
                        benchmark_render_u  = render_u
                        benchmark_cpu_u     = cpu_u
                        benchmark_rc6_u     = rc6_u
                        benchmark_avg_freq  = avg_freq
                        #printLog(output_log_handle, "benchmark_stream: ",benchmark_stream, "average_fps: ", benchmark_fps)
                        benchmark_sweeping_table[key].append(benchmark_fps)
                        nextStreamNumber = True
                        if int(streamnumber) == 1:
                            benchmark_table = key + "," + str(benchmark_fps)
                            bt_output_handle.write(benchmark_table)
                        else:
                            benchmark_table = "," + str(benchmark_fps)
                            bt_output_handle.write(benchmark_table)

                        streamnumber = streamnumber + 1
                    elif int(streamnumber) == 1:
                        benchmark_stream = 0
                        benchmark_fps = round(statistics.mean(avg_fps_split), 1)
                        benchmark_exetime = exetime
                        benchmark_vid0_u = vid0_u
                        benchmark_vid1_u = vid1_u
                        benchmark_render_u = render_u
                        benchmark_cpu_u = cpu_u
                        benchmark_rc6_u = rc6_u
                        benchmark_avg_freq = avg_freq
                        printLog(output_log_handle, " average current TPT: ",benchmark_stream, "average_fps: ", benchmark_fps)
                        benchmark_sweeping_table[key].append(benchmark_fps)
                        nextStreamNumber = False
                        benchmark_table = key + "," + str(benchmark_fps)
                        bt_output_handle.write(benchmark_table)
                    else:
                        last_failing_fps = round(statistics.mean(avg_fps_split), 1)
                        benchmark_sweeping_table[key].append(last_failing_fps) # to add the last failing multistreams.
                        nextStreamNumber = False
                        benchmark_table = "," + str(last_failing_fps)
                        bt_output_handle.write(benchmark_table)

                    printLog(output_log_handle, "MULTISTREAM: Done")

                ##################################################################################
                # Before go to next workload, captured the benchmark result
                ##################################################################################
                benchmark = key + "," + str(benchmark_stream) + "," + str(benchmark_fps)  + "," + str(benchmark_exetime) + "," + str(benchmark_vid0_u) + "," + str(benchmark_vid1_u) + "," + str(benchmark_render_u) + "," + str(benchmark_cpu_u) + "," + str(benchmark_rc6_u) +   "," + str(benchmark_avg_freq) + "\n"
                bm_output_handle.write(benchmark)

                benchmark_table = "\n"
                bt_output_handle.write(benchmark_table)

                if str(benchmark_sweeping_table[key])[1:-1] == "":
                    printLog(output_log_handle, key, ": SKIPPED")
                else:
                    printLog(output_log_handle, " benchmark sessions of", key, ":", len(benchmark_sweeping_table[key]) - 1, ":", str(benchmark_sweeping_table[key])[1:-1])
                printLog(output_log_handle, "WORKLOAD: Done")

            ##################################################################################
            # Benchmark sequence is done
            ##################################################################################

            ##################################################################################
            # Saved traces.
            ##################################################################################
            output_directory_archived = "NONE"
            if benchmark_sequence == 0 and (encode_codec == "all" or encode_codec == "avc"):
                output_directory_archived = re.sub(r'.txt', "_" + benchmark_app_tag + "_hevc2avc_traces", output_log_filename)
            elif benchmark_sequence == 1 and (encode_codec == "all" or encode_codec == "avc"):
                output_directory_archived = re.sub(r'.txt', "_" + benchmark_app_tag + "_avc2avc_traces", output_log_filename)
            elif benchmark_sequence == 2 and (encode_codec == "all" or encode_codec == "hevc"):
                output_directory_archived = re.sub(r'.txt', "_" + benchmark_app_tag + "_hevc2hevc_traces", output_log_filename)

            # print out total time during the benchmark sequence
            end_message = "BENCHMARK SEQUENCE : " + benchmark_tag + " : Done"
            execution_time(output_log_handle, end_message, startTime_sequence, time.time())

            # checks if path is a directory
            output_directory_archived = artifact_path + output_directory_archived
            isDirectory = os.path.isdir(output_directory_archived)
            if (isDirectory):
                archived_tag = str(time.ctime())
                archived_tag = re.sub(r'\:', "", archived_tag)
                archived_tag = re.sub(r'\s', "_", archived_tag)
                move_command = "mv " + output_directory_archived + " " + output_directory_archived + "_" + archived_tag
                os.system(move_command)
                move_command = "mv /tmp/perf " + output_directory_archived
                os.system(move_command)
            else:
                move_command = "mv /tmp/perf " + output_directory_archived
                os.system(move_command)

            # remove_command = "rm -f /tmp/perf"
            # os.system(remove_command)
            ##################################################################################
            # start new start time of next benchmark sequence
            ##################################################################################
            startTime_sequence = time.time()

        #printLog(output_log_handle, benchmark_app_tag , " APPLICATION: Done")
        end_message = "BENCHMARK APPLICATION: " + benchmark_app_tag +  " : Done"
        execution_time(output_log_handle, end_message, startTime_application, time.time())
        ##################################################################################
        # start new start time of next benchmark application
        ##################################################################################
        startTime_application = time.time()

    end_message = "PNP MEDIA BENCHMARK: Done"
    execution_time(output_log_handle, end_message, startTime, time.time())

    printLog(output_log_handle, "\nDate:", time.ctime())

######################## PnP SiLab Sumack ########################################
def message_block(output_log_handle, block_color, block_str):
    color_str = {'red': u'\u001b[41;1m', 'green': u'\u001b[42;1m', 'white': u'\u001b[7m', 'yellow': u'\u001b[43:1m'}
    formatted_string = '\n' + color_str[block_color] + ' ' * (4 + len(block_str)) + u'\u001b[0m\n' + color_str[
        block_color] \
                       + '  ' + block_str + u'  \u001b[0m\n' + color_str[block_color] + ' ' * (
                               4 + len(block_str)) + u'\u001b[0m\n'
    printLog(output_log_handle, formatted_string)

##################################################################################
# Post Process Multistream FPS/session against Content_FPS definition
# jiwan
##################################################################################
def postprocess_multistream(output_log_handle, stream_number, iteration_number, debug_verbose, benchmark_object):
    if debug_verbose:
        printLog(output_log_handle, " [VERBOSE][CMD]", benchmark_object.dispatch_cmdline)
        printLog(output_log_handle, " [VERBOSE][LINUX_PERF_TOOLS]", benchmark_object.linux_perf_cmdlines, "\n")

    next = True
    runtime = vid0_utilization = vid1_utilization = render_utilization = cpu_cycles = rc6_utilization = avg_frequency = cpu_task_clock = 0
    #t = open(temp_path_file, 'a+')
    temp_file = benchmark_object.temp_path + "iteration_temp.txt"
    average_fps = 0

    # 5% (default)
    fps_limit = round(0.95 * float(benchmark_object.fps_limit), 2)

    if (benchmark_object.ffmpeg_mode):
        cmd_grep = "grep -b1 'video:' " + benchmark_object.temp_path + "*transcode_log.txt " + "> " + temp_file
        exit_progress = os.system(cmd_grep)
        cmd_perl = "perl -pi -e 's/^.*video\:.*\n//' " + benchmark_object.temp_path + "iteration_temp.txt"
        os.system(cmd_perl)
        cmd_perl = "perl -pi -e 's/^.*fps=\s*/fps /' " + benchmark_object.temp_path + "iteration_temp.txt"
        os.system(cmd_perl)
        cmd_perl = "perl -pi -e 's/q=.*\n//' " + benchmark_object.temp_path + "iteration_temp.txt"
        os.system(cmd_perl)
        # with open(temp_file, "r") as b2b_temp_fh:
        #     for line in b2b_temp_fh:
        #         printLog(output_log_handle, line)
    else:
        cmd_grep = "grep -H ' fps' " + benchmark_object.temp_path + "*transcode_log.txt " + "> " + temp_file
        exit_progress = os.system(cmd_grep)
        cmd_perl = "perl -pi -e 's/_transcode_log.*,//' " + benchmark_object.temp_path + "iteration_temp.txt"
        os.system(cmd_perl)

    if exit_progress == 0:
        # using With to open file to ensure the next codes are blocked until the file is exited.
        #temp_file = benchmark_object.temp_path + "/iteration_temp.txt"
        #with open("/home/intel/forMediaDelivery/interim/iteration_temp.txt", "r") as b2b_temp_fh:
        with open(temp_file, "r") as b2b_temp_fh:
            fps_per_session_previous = 0
            average_iter = 0
            average_fps_split = []
            for line in b2b_temp_fh:
                line_split = line.split(' ')
                if len(line_split) < 2:
                    continue
                elif not float(line_split[1]):
                    continue
                fps_per_session = round(float(line_split[1]), 2)
                average_fps_split.append(fps_per_session)
                ##################################################################################
                # Post Process Multistream FPS/session against Content FPS limit target
                ##################################################################################
                next = True if fps_per_session > fps_limit else False

                ##################################################################################
                # Post Process Multistream FPS/session is within 2% margin among its own average
                ##################################################################################
                two_percent_margin = True
                delta_margin = 0
                if fps_per_session_previous > 0:
                    delta_margin = round(abs(1 - (fps_per_session / fps_per_session_previous)), 2)
                    two_percent_margin = True if delta_margin <= 0.02 else False
                else:
                    fps_per_session_previous = fps_per_session

                ##################################################################################
                # Readable console output for fps/session, 2%margin, and limit
                ##################################################################################
                output_file_split = line_split[0].split("/")
                output_file_split_len = len(output_file_split)
                clipname = output_file_split[output_file_split_len - 1]
                print_check_result = " CONCURRENT: " + clipname + " " + str(fps_per_session) + " fps/session" + " , Meets ContentFPS " + str(fps_limit) + " : " + str(next) + " , Within margin 2%: " + str(delta_margin) + " " + str(two_percent_margin)
                printLog(output_log_handle, print_check_result)

                ##################################################################################
                # Report Summary print out
                ##################################################################################
                average_iter = average_iter + 1

            average_fps = statistics.mean(average_fps_split) if average_fps_split != [] else 0

    ##################################################################################
    # Post Process Linux Perf for GPU Utilization and Average GPU Frequency
    ##################################################################################
    if os.path.isfile(benchmark_object.linux_perf_dump):
        dump_lp_list = {}
        with open(benchmark_object.linux_perf_dump, "r") as tools_lp:
            for line in tools_lp:
                line = line.replace("\t","")
                if re.search(r'\sns',line):
                    line = line.replace(" ns",":")
                elif re.search(r'\smsec',line):
                    line = line.replace(" msec",":")
                elif re.search(" M",line):
                    line = line.replace(" M",":")
                elif re.search(" seconds",line):
                    line = line.replace(" seconds",":")
                elif re.search("cycles",line):
                    line = line.replace("cycles",":cycles")
                elif re.search("instructions", line):
                    line = line.replace("instructions", ":instructions")
                else:
                    continue

                line_split = line.split(":")

                if (len(line_split) > 1):
                    line_lp_value = line_split[0].replace(" ","").replace(",","")
                    line_lp_description = line_split[1].strip()
                    if re.search(r'vcs0-busy',line_lp_description):
                        line_lp_description = "Video0_time(ns)"
                    elif re.search(r'vcs1-busy', line_lp_description):
                        line_lp_description = "Video1_time(ns)"
                    elif re.search(r'rcs0-busy', line_lp_description):
                        line_lp_description = "Render_time(ns)"
                    elif re.search(r'actual-frequency', line_lp_description):
                        line_lp_description = "Average-Frequency(M)"
                    elif re.search(r'time elapsed', line_lp_description):
                        line_lp_description = "Runtime(seconds)"
                    elif re.search(r'task-clock', line_lp_description):
                        line_lp_description = "CPU_task_clock"
                    elif re.search(r'cycles', line_lp_description):
                        line_lp_description = "CPU_cycles"
                    elif re.search(r'instructions', line_lp_description):
                        line_lp_description = "CPU_instructions"
                    elif re.search(r'rc6-residency', line_lp_description):
                        line_lp_description = "RC6_time(ns)"
                    else:
                        continue

                    dump_lp_list[line_lp_description] = float(line_lp_value.strip())

                else:
                    continue

        runtime                 = round(dump_lp_list["Runtime(seconds)"],2)
        vid0_utilization        = round(dump_lp_list["Video0_time(ns)"] / 1000000000 / runtime * 100, 2)
        vid1_utilization        = round(dump_lp_list["Video1_time(ns)"] / 1000000000 / runtime * 100, 2)
        render_utilization      = round(dump_lp_list["Render_time(ns)"] / 1000000000 / runtime * 100, 2)
        cpu_task_clock          = round(dump_lp_list["CPU_task_clock"])
        cpu_cycles              = round(dump_lp_list["CPU_cycles"])
        cpu_instructions        = round(dump_lp_list["CPU_instructions"])
        cpu_utilized_estimated  = round(cpu_task_clock / runtime / 1000,2)
        cpu_frequency_combined  = round(cpu_cycles / runtime / 1000000000, 2)
        cpu_frequency_per_thread= round(cpu_frequency_combined / cpu_utilized_estimated, 2)
        cpu_ipc                 = round(cpu_instructions / cpu_cycles,2)
        rc6_utilization         = round(dump_lp_list["RC6_time(ns)"] / 1000000000 / runtime * 100, 2)
        avg_frequency           = round(dump_lp_list["Average-Frequency(M)"] / runtime, 2)

        if debug_verbose:
            printLog(output_log_handle, "\n [VERBOSE][LINUX_PERF_TOOLS]")

        printLog(output_log_handle, " GPU analysis: ")
        printLog(output_log_handle, "\tRuntime\t\t:", runtime, "seconds",
               "\n\tVideo0\t\t:", vid0_utilization, "%" ,
               "\n\tVideo1\t\t:", vid1_utilization, "%" ,
               "\n\tRender\t\t:", render_utilization, "%" ,
               "\n\tRC6_Idle\t:", rc6_utilization, "%",
               "\n\tFreq_AVG\t:", avg_frequency, "MHz",
                 )
        printLog(output_log_handle, " CPU analysis: ")
        printLog(output_log_handle, "\tCycles\t\t:", cpu_cycles, "raw",
                 "\n\tTask_Clock\t:", cpu_task_clock, "miliseconds",
                 "\n\t~Utilized\t:", cpu_utilized_estimated, "Thread",
                 "\n\tFreq_Combined\t:", cpu_frequency_combined, "GHz",
                 "\n\tFreq_AVG\t:", cpu_frequency_per_thread, "GHz",
                 "\n\tInstructions\t:", cpu_instructions, "raw",
                 "\n\tIPC\t\t:", cpu_ipc, "Instructions Per Cycle",
                 )

        ##################################################################################
        # Post Process Linux Perf for Traces
        ##################################################################################
        if (benchmark_object.tool_linux_perf_trace):
            import matplotlib.pyplot as plt
            import numpy as np
            printLog(output_log_handle, " Traces Chart:")
            ##################################################################################
            # Post Process Linux Perf for GPU Analysis Traces - GT Freq
            ##################################################################################
            y_axis = []

            with open(benchmark_object.linux_perf_gpu_freq_trace_dump, 'r') as lp_traces:
                for sampling_line in lp_traces:
                    if re.search(r'actual-frequency', sampling_line):
                        sampling_line_split = re.sub('[^0-9a-zA-Z\.]+', "_", sampling_line).split("_")
                        freq_trace = round(float(int(sampling_line_split[2]) / 100), 2)
                        y_axis.append(freq_trace)


            x_axis = np.arange(len(y_axis))
            plot_output = plt.figure()
            subplot_output = plt.subplot()
            subplot_output.plot(x_axis, y_axis, label='GT-Freq(GHz)')
            trace_title = "MMSBench Trace - " + benchmark_object.filename_gpu_freq_trace
            plt.title(trace_title)
            subplot_output.legend()
            # plt.show()

            plot_filename = benchmark_object.temp_path + benchmark_object.filename_gpu_freq_trace + ".png"
            plot_output.savefig(plot_filename)
            printLog(output_log_handle, "\tGPU-Freq-Trace\t:", re.sub(r'.*\/',"" , plot_filename))

            ##################################################################################
            # Post Process Linux Perf for GPU Analysis Traces - Mem BW
            ##################################################################################
            mem_bw_rd = []
            mem_bw_wr = []

            with open(benchmark_object.linux_perf_mem_bw_trace_dump, 'r') as lp_gpubw_traces:
                for membw_line in lp_gpubw_traces:
                    if re.search(r'data_reads', membw_line):
                        membw_line_split = re.sub('[^0-9a-zA-Z\.]+', "_", membw_line).split("_")
                        read_trace = round((float(membw_line_split[2]) * 1.024 / 100), 2)
                        mem_bw_rd.append(read_trace)
                    elif re.search(r'data_writes', membw_line):
                        membw_line_split = re.sub('[^0-9a-zA-Z\.]+', "_", membw_line).split("_")
                        write_trace = round((float(membw_line_split[2]) * 1.024 / 100), 2)
                        mem_bw_wr.append(write_trace)
                    else:
                        continue

            r = np.arange(len(mem_bw_rd))
            plot_output = plt.figure()
            subplot_output = plt.subplot()
            subplot_output.plot(r, mem_bw_rd, label='MEMORY-Read-BW-Traces(MB/s)')
            trace_title = "MMSBench Trace - " + benchmark_object.filename_mem_bw_trace
            plt.title(trace_title)
            subplot_output.legend()
            # plt.show()

            plot_filename = benchmark_object.temp_path + benchmark_object.filename_mem_bw_trace + "_read.png"
            plot_output.savefig(plot_filename)
            printLog(output_log_handle, "\tMEM-RD-BW-Trace\t:", re.sub(r'.*\/',"" , plot_filename))

            w = np.arange(len(mem_bw_wr))
            plot_output = plt.figure()
            subplot_output = plt.subplot()
            subplot_output.plot(w, mem_bw_wr, label='MEMORY-Write-BW-Traces(MB/s)')
            trace_title = "MMSBench Trace - " + benchmark_object.filename_mem_bw_trace
            plt.title(trace_title)
            subplot_output.legend()
            # plt.show()

            plot_filename = benchmark_object.temp_path + benchmark_object.filename_mem_bw_trace + "_write.png"
            plot_output.savefig(plot_filename)
            printLog(output_log_handle, "\tMEM-WR-BW-Trace\t:", re.sub(r'.*\/',"" , plot_filename))

            ###################################
            # myplotlib
            # Clean up after plot creation.
            ###################################
            plt.cla() # Clear an axis
            plt.clf() # Clears the entire current figure
            plt.close('all') # close all open figures.

            printLog(output_log_handle, " RAW files:")
            printLog(output_log_handle, "\tmetrics\t\t:", re.sub(r'.*\/',"" , benchmark_object.linux_perf_dump))
            printLog(output_log_handle, "\tGPU-Freq traces\t:", re.sub(r'.*\/',"" , benchmark_object.linux_perf_gpu_freq_trace_dump))
            printLog(output_log_handle, "\tMEMORY traces\t:", re.sub(r'.*\/',"" , benchmark_object.linux_perf_mem_bw_trace_dump))
    # else:
    #     printLog(output_log_handle, " GPU analysis: N/A (enabled by adding -lp into the commandline)")

    return next, average_fps, runtime, vid0_utilization, vid1_utilization, render_utilization, cpu_cycles, rc6_utilization, avg_frequency

########### James.Iwan@intel.com Bench Perf ######################################
def execution_time(output_log_handle, message, start,end):
    time = float(end - start)
    total = time
    day = time // (24 * 3600)
    time = time % (24 * 3600)
    hour = time // 3600
    time %= 3600
    minutes = time // 60
    time %= 60
    seconds = time

    printLog(output_log_handle, message, " - execution time: %d s (%dD:%dhr:%dmin:%dsec)\n" % (total, day, hour, minutes, seconds))

########### James.Iwan@intel.com Bench Perf ######################################
def ffmpegffprobeCheck(output_log_handle, filepath, filename, out_temp_path, debug_verbose, benchmark_sweeping_table, content_fps_list, content_height_list, content_codec_list, benchmark_object_list):
    status = True
    filename_split = filename.replace('.', '_').split('_')
    ffprobe_dump        = out_temp_path + "/ffprobe_" + filename_split[0] + ".txt"
    ffprobe_cmd         = "ffprobe -hide_banner -loglevel panic -show_streams -i " + filepath + filename.rstrip() + " | grep -e ^height= -e ^r_frame_rate= -e ^codec_name= " + " > " + ffprobe_dump
    os.system(ffprobe_cmd)
    ffprobe_height = ffprobe_frame_rate = ffprobe_codec_name = 0

    with open(ffprobe_dump, "r") as ffprobedump_fh:
        for content_profile_line in ffprobedump_fh:
            content_profile_line_split  = content_profile_line.rstrip().split("=")
            attribute                   = content_profile_line_split[0]
            value                       = content_profile_line_split[1]

            if (attribute == "height"):
                ffprobe_height      = int(value)
            elif (attribute == "r_frame_rate"):
                ffprobe_frame_rate  = int(value.replace("/1",""))
            elif (attribute == "codec_name"):
                ffprobe_codec_name  = str(value)

    ######################################################
    # ERROR Checking.
    ######################################################
    if (ffprobe_height ==0) | (ffprobe_frame_rate == 0):
        if debug_verbose:
            printLog(output_log_handle, " FAIL: via FFMPEG/FFPROBE")
        status = False

    if status:
        benchmark_object_list[filename.rstrip()]            = MediaContent()
        benchmark_object_list[filename.rstrip()].name       = filename.rstrip()
        #benchmark_object_list[filename.rstrip()].fps_limit  = round(0.95 * float(ffprobe_frame_rate), 2)
        benchmark_object_list[filename.rstrip()].fps_limit  = ffprobe_frame_rate
        benchmark_object_list[filename.rstrip()].height     = ffprobe_height
        benchmark_object_list[filename.rstrip()].codec      = ffprobe_codec_name
        content_fps_list[filename.rstrip()]                 = ffprobe_frame_rate
        content_height_list[filename.rstrip()]              = ffprobe_height
        content_codec_list[filename.rstrip()]               = ffprobe_codec_name
        benchmark_sweeping_table[filename.rstrip()]         = []

    return status

########### James.Iwan@intel.com Bench Perf ######################################
# Contentlist
# Naming convention for each benchmark workload
# 0 - content name
# 1 - content resolution
# 2 - content bitrate
# 3 - content fps
# 4 - content total_frames
# 5 - content codec type
##################################################################################
def ContentNamingCheck(output_log_handle, filename, benchmark_sweeping_table, content_fps_list, content_height_list, content_codec_list):
    status = True
    filename_split      = filename.rstrip().replace('.', '_').split('_')
    for profile in filename_split:
        #rint (profile)
        if re.search(r'1080|2160|720',profile):
            filename_height = re.sub(r'.*x', '', profile)
            filename_height = int(re.sub(r'p', '', filename_height))
        elif re.search(r'fps', profile):
            filename_fps = int(re.sub(r'fps', '', profile))
        elif re.search(r'hevc|h264|h265', profile):
            filename_codec = profile


    #printLog(output_log_handle, filename_fps, " ", filename_height, " ", filename_codec)
    if (filename_fps != 0) or (filename_height != 0):
        content_fps_list[filename] = filename_fps
        benchmark_sweeping_table[filename] = []
        content_height_list[filename] = filename_height
        content_codec_list[filename] = filename_codec
        status = True
    else:
        status = False
        printLog(output_log_handle, " Found incorrect content naming convention: " + filename + " Please rename with the following pattern <clipname>_<width>x<height>p_<bitrate>_<content_fps_list>_<total_frames>.<codec>")

    return status

########### James.Iwan@intel.com Bench Perf ######################################
# Print log
##################################################################################
def printLog(filehandle_printout, *args):
    console_printout = ' '.join([str(arg) for arg in args])
    print(console_printout)
    console_printout = console_printout + "\n"
    filehandle_printout.write(console_printout)

########### James.Iwan@intel.com Bench Perf ######################################
# Execute
##################################################################################
main()
