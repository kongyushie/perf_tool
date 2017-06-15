#!/bin/bash
FTRACE_PATH=$FTRACE_PATH
PID=$$
#reset ftrace
echo 0 > $FTRACE_PATH/tracing_on

#-----------event------------------
#from available_events
echo > $FTRACE_PATH/set_event
echo block:block* >> $FTRACE_PATH/set_event
echo csi:scsi* >> $FTRACE_PATH/set_event

#-----------filter------------------
#from available_filter_functions
echo > $FTRACE_PATH/set_ftrace_filter
#-----------graph function------------------
#from available_filter_functions
echo > $FTRACE_PATH/set_graph_function

# write current process id to set_ftrace_pid file
#echo $PID > $DPATH/set_ftrace_pid
echo  > $DPATH/set_ftrace_pid

#------------tracer-----------------
#from available_tracers
echo nop > $FTRACE_PATH/current_tracer


#####################RUN######################
echo 0 > /proc/sys/vm/page-cluster
echo 0 > /proc/sys/vm/swappiness
sync
echo 3 > /proc/sys/vm/drop_caches
free
echo 1 > $FTRACE_PATH/tracing_on
./../memory-test/rw/paging
echo 0 > $FTRACE_PATH/tracing_on

cat $FTRACE_PATH/trace_pipe > log/event/log
