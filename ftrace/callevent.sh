#!/bin/bash
FTRACE_PATH=/sys/kernel/debug/tracing
PID=$$
[ `id -u` -ne 0  ]  &&  { echo "needs to be root" ; exit 1; }  # check for root permissions
#reset ftrace
echo 0 > $FTRACE_PATH/tracing_on

#echo 1 > $FTRACE_PATH/events/block/enable

#-----------event------------------
#from available_events
echo > $FTRACE_PATH/set_event
echo block:* >> $FTRACE_PATH/set_event

#-----------filter------------------
#from available_filter_functions
echo > $FTRACE_PATH/set_ftrace_filter
echo submit_bio >> $FTRACE_PATH/set_ftrace_filter
echo blk_finish_plug >> $FTRACE_PATH/set_ftrace_filter
echo read_swap_cache_async >> $FTRACE_PATH/set_ftrace_filter
echo swapin_readahead >> $FTRACE_PATH/set_ftrace_filter
echo handle_mm_fault >> $FTRACE_PATH/set_ftrace_filter
echo do_page_fault >> $FTRACE_PATH/set_ftrace_filter
#-----------graph function------------------
#from available_filter_functions
echo > $FTRACE_PATH/set_graph_function
#echo swapin_readahead >> $FTRACE_PATH/set_graph_function

# write current process id to set_ftrace_pid file
#echo $PID > $DPATH/set_ftrace_pid
echo PID > $DPATH/set_ftrace_pid
#------------tracer-----------------
#from available_tracers
echo function_graph > $FTRACE_PATH/current_tracer


#####################RUN######################
echo 0 > /proc/sys/vm/page-cluster
echo 0 > /proc/sys/vm/swappiness
sync
echo 3 > /proc/sys/vm/drop_caches
free
echo 1 > $FTRACE_PATH/tracing_on
./../memory-test/rw/paging
echo 0 > $FTRACE_PATH/tracing_on
echo 0 > $FTRACE_PATH/events/block/enable

cat $FTRACE_PATH/trace_pipe > log/callgraph/log
