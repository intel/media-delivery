Prerequisites
=============

1. Python3 
2. Linux Perf Tools
3. Environment setup as below

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

Media Clips to be allocated into specific single directory e.g. below::

    cd ~/forMediaDelivery/

Place all Automation Script files into the same directory as the clips::

    python3 MSPerf.py -r /home/intel/forMediaDelivery/req_low_bitrate.txt -lp

Custom Command Line::

    python3 MSPerf.py -r /home/intel/forMediaDelivery/req_low_bitrate.txt -lp -s 1080p:1 -n 1 -v

ChangeLog
=========

MEDIA MULTISTREAM PERFORMANCE MEASURE v0.20.02.25

2019-12-11 - initialized support for sample_application performance measure transcode HEVC-AVC on SKL

2019-12-18 - automated concurrent multistreams and collected raw fps output

2019-12-20 - support and initial run on DG1

2020-01-03 - removing hardcoded commandlist, and added automated unique output generation

2020-01-06 - requested - adding support for iteration and workload list based on total available in the specified directory

2020-01-08 - adding check pass/fail and continue for FPS_limit, margin 2%, and nicer output, a lot Cleaner

2020-01-09 - requested - adding required file as input to ease the different command lines as per resolution 720p/1080p/2160p

2020-01-13 - adding execution time, and fix iteration limit and fix multistream starting to exit properly

2020-01-21 - requested - adding flexibility to different resolution multistream initialization, e.g. -s 720p:8,1080p:5,2160p:2

2020-01-27 - Lots of error checking, and add single resolution performance measure through -s option, e.g. -s 1080p:5

2020-01-28 - requested - to capture the last fail multistreams run.

2020-01-30 - fix print out for sweeptable without bracket

2020-02-13 - Add Linux Perf Tools for VD0/VD1/RCS/etc utilization. please use -lp to enable it

2020-02-18 - Add GPU Analysis terminal print-out

2020-02-19 - Performance measure summary will now include GPU Analysis report out

2020-02-20 - Adding AVC-AVC Transcode performance measure capabilities.

2020-02-21 - Adding a trace plot for GPU Frequency utilizing metrics from Linux Perf source

2020-02-24 - Add CPU and RC6 Utilization from Linux Perf source

2020-02-21 - Adding Memory BW metrics from Linux Perf source

2020-03-TBD - stay tuned.. =)
