#!/bin/bash
FTRACE_PATH=/sys/kernel/debug/tracing
#reset ftrace
echo 0 > $FTRACE_PATH/tracing_on

#-----------event------------------
#from available_events
echo > $FTRACE_PATH/set_event

#-----------filter------------------
#from available_filter_functions
echo > $FTRACE_PATH/set_ftrace_filter
#-----------graph function------------------
#from available_filter_functions
echo > $FTRACE_PATH/set_graph_function


#------------tracer-----------------
#from available_tracers
echo function > $FTRACE_PATH/current_tracer


#####################RUN######################
sync
echo 3 > /proc/sys/vm/drop_caches
free
echo 1 > $FTRACE_PATH/tracing_on
#./../paging
ping 140.112.90.49
echo 0 > $FTRACE_PATH/tracing_on

cat $FTRACE_PATH/trace_pipe > log/log
