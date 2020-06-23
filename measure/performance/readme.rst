Prerequisites
=============

1. Python3 
2. Linux Perf Tools
3. Environment setup as below
4. FFMPEG/FFPROBE

Configuration
=============

::

    sudo sh -c "echo -1 > /proc/sys/kernel/perf_event_paranoid"
    export LIBVA_DRIVERS_PATH=/usr/lib/x86_64-linux-gnu/dri
    export LIBVA_DRIVER_NAME=iHD
    export LD_LIBRARY_PATH=/opt/intel/mediasdk/lib64:/usr/lib/x86_64-linux-gnu:/usr/local/lib:/home/intel/install/3556/lin
    export LD_LIBRARY_PATH=/opt/intel/mediasdk/lib64:/usr/lib/x86_64-linux-gnu:/usr/local/lib:/usr/lib/x86_64-linux-gnu:/usr/lib/x86_64-linux-gnu/mfx

Content
=======

Command to run with all clips with specific output path:

    python3 MSPerf.py ~/forMediaDelivery/ -o ~/MultiStreamPerformance_2020WW20/

Command to run with all clips with specific output path, with skipping Application::

    python3 MSPerf.py ~/forMediaDelivery/ --skip-msdk -o ~/MultiStreamPerformance_2020WW20/
	or
	python3 MSPerf.py ~/forMediaDelivery/ --skip-ffmpeg -o ~/MultiStreamPerformance_2020WW20/

Command to run with all clips with specific output path, with verbose/debug and with additional Tools CPU/GPU analysis::

    python3 MSPerf.py ~/forMediaDelivery/ -v --enable-debugfs -o ~/MultiStreamPerformance_2020WW20/

Command to run with all clips with specific output path, with verbose/debug, Disabling LINUX PERF Tools::

    python3 MSPerf.py ~/forMediaDelivery/ -v --skip-perf -o ~/MultiStreamPerformance_2020WW20/

Command to run with all clips with specific output path, with verbose/debug, Disabling just the Trace capture of LINUX PERF Tools::

    python3 MSPerf.py ~/forMediaDelivery/ -v --skip-perf-trace -o ~/MultiStreamPerformance_2020WW20/

Command to run with all clips with specific output path, with skipping Application, and specific encoder codec::

    python3 MSPerf.py ~/forMediaDelivery/ --skip-msdk -c HEVC -o ~/MultiStreamPerformance_2020WW20/
	or
	python3 MSPerf.py ~/forMediaDelivery/ --skip-msdk --codec HEVC -o ~/MultiStreamPerformance_2020WW20/

Command to run with all clips with specific output path, with skipping Application, and specific encoder codec, startStream::

    python3 MSPerf.py ~/forMediaDelivery/ --skip-msdk -c HEVC -s 1080p:2 -o ~/MultiStreamPerformance_2020WW20/
	or
	python3 MSPerf.py ~/forMediaDelivery/ --skip-msdk --codec HEVC -s 720p:4,1080p:3,2160p:2 -o ~/MultiStreamPerformance_2020WW20/

Command to run with all clips with specific output path, with skipping Application, and specific encoder codec, endStream::

    python3 MSPerf.py ~/forMediaDelivery/ --skip-msdk -c HEVC -e 3 -o ~/MultiStreamPerformance_2020WW20/


ChangeLog
=========

MSPERF (MULTI STREAM PERFORMANCE) v0.20.06.03
change-log:
03-Jun-2020 Add support for multiknobsAPI, for codec,outdir, etc.
02-Jun-2020 Fix Compliance API
02-Jun-2020 Adding support for Multi Devices for environment DEVICE=path
01-Jun-2020 rename per session into per stream acording to standard metric
27-May-2020 provide performance readme
16-May-2020 fix application knob fail exit
15-May-2020 Adding GPU mem analysis
15-May-2020 fix tty, invisible terminal from ffmpeg exit
07-May-2020 fixes on exits to return 1 err value status
06-May-2020 minor fix on path files and cpu_average% fix
05-May-2020 Multiple fixes and adding support free/lscpu/top tools
29-Apr-2020 fix for measure_table_sweep to reset during switching modes.
29-Apr-2020 add unsupported warning based on content height.
29-Apr-2020 Adding AVC-HEVC Transcode support. POR command lines updated for SMT and FFMPEG.
29-Apr-2020 fix content height base switching. Now selecting content_object instead of file.
29-Apr-2020 Adding SMT and FFMPEG command line files that are neccessary for performance measures.
29-Apr-2020 Media Performance Measure Script. Initial Cleaned Version.
29-Apr-2020 add dedicated artifact path for seperating Docker/Container/Baremetal. more codes cleaned up.
28-Apr-2020	add default workload-path args, --skip-ffmpeg, --skip-msdk, -codec, backup-traces, --skip-perf, --skip-perf-trace
27-Apr-2020	SMT HEVC-AVC, AVC-AVC, HEVC-HEVC performance measures now run in a single kick-off
15-Apr-2020	add CPU analysis, featuring cycles, IPC, etc
01-Apr-2020	add HEVC-HEVC transcode, for both SMT and FFMPEG performance measure suppport
20-Mar-2020	add AVC-AVC transcode performance measure suppport
06-Mar-2020	add FFMPEG/FFPROBE profiling by default and option to bypass by using the correct naming-format
03-Mar-2020	add -w option for workload_path ( -w ../workload_directories/ ) OR a single workload example (-w ../content.hevc -content_fps_list 50 -content_resolution 1080p )
02-Mar-2020	remove hardcoded path for linux-perf-tools, pre-Requisite System has installed global /perf linux-tools
27-Feb-2020	Disable/Enable trace chart option
25-Feb-2020	Adding Memory BW metrics from Linux Perf source
24-Feb-2020	Add CPU and RC6 Utilization from Linux Perf source
21-Feb-2020	Adding a trace plot for GPU Frequency utilizing metrics from Linux Perf source
20-Feb-2020	Adding AVC-AVC Transcode performance measure capabilities.
19-Feb-2020	Performance measure summary will now include GPU Analysis report out
18-Feb-2020	Add GPU Analysis terminal print-out
13-Feb-2020	Add Linux Perf Tools for VD0/VD1/RCS/etc utilization. please use -lp to enable it
30-Jan-2020	fix print out for sweeptable without bracket
28-Jan-2020	requested for to capture the last fail multistreams run.
27-Jan-2020	Lots of error checking, and add single resolution performance measure through -s option, e.g. -s 1080p:5
21-Jan-2020	requested for adding flexibility to different resolution multistream initialization, e.g. -s 720p:8,1080p:5,2160p:2
13-Jan-2020	adding execution time, and fix iteration limit and fix multistream starting to exit properly
09-Jan-2020	requested for adding required file as input to ease the different command lines as per resolution 720p/1080p/2160p
08-Jan-2020	adding check pass/fail and continue for FPS_limit, margin 2%, and nicer output, a lot Cleaner
06-Jan-2020	requested for adding support for iteration and workload list based on total available in the specified directory
03-Jan-2020	removing hardcoded commandlist, and added automated unique output generation
20-Dec-2019	support and initial run on DG1
18-Dec-2019	automated concurrent multistreams and collected raw fps output
11-Dec-2019	initialized support for sample_application performance measure transcode HEVC-AVC on SKL
-initiated-

