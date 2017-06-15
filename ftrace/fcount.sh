#!/bin/bash
FTRACE_PATH=/sys/kernel/debug/tracing
TEST_PATH=/home/kongyu/ky/memory-test/rw
LOG_PATH=/home/kongyu/ky/ky_tools/ftrace/log
PID=$$
[ `id -u` -ne 0  ]  &&  { echo "needs to be root" ; exit 1; }  # check for root permissions
#reset ftrace
echo 0 > $FTRACE_PATH/tracing_on

#-----------event------------------
#from available_events
echo > $FTRACE_PATH/set_event

#-----------filter------------------
#from available_filter_functions
echo > $FTRACE_PATH/set_ftrace_filter
#echo __lock_page_or_retry >> $FTRACE_PATH/set_ftrace_filter
#echo submit_bio >> $FTRACE_PATH/set_ftrace_filter
#echo blk_finish_plug >> $FTRACE_PATH/set_ftrace_filter
#echo read_swap_cache_async >> $FTRACE_PATH/set_ftrace_filter
echo swapin_readahead >> $FTRACE_PATH/set_ftrace_filter
#echo handle_mm_fault >> $FTRACE_PATH/set_ftrace_filter
echo do_page_fault >> $FTRACE_PATH/set_ftrace_filter
#-----------graph function------------------
#from available_filter_functions
echo > $FTRACE_PATH/set_graph_function
#echo swapin_readahead >> $FTRACE_PATH/set_graph_function

# write current process id to set_ftrace_pid file
#echo $PID > $DPATH/set_ftrace_pid
echo  > $DPATH/set_ftrace_pid
#------------tracer-----------------
#from available_tracers
echo nop > $FTRACE_PATH/current_tracer
echo 1 > $FTRACE_PATH/options/sleep-time
echo 1 > $FTRACE_PATH/options/graph-time
echo 0 > $FTRACE_PATH/function_profile_enabled
echo 1 > $FTRACE_PATH/function_profile_enabled


#####################RUN######################
echo 0 > /proc/sys/vm/page-cluster
echo 0 > /proc/sys/vm/swappiness
sync
echo 3 > /proc/sys/vm/drop_caches
free
echo 1 > $FTRACE_PATH/tracing_on
$TEST_PATH/paging
echo 0 > $FTRACE_PATH/tracing_on
echo 1 > $FTRACE_PATH/options/sleep-time
echo 1 > $FTRACE_PATH/options/graph-time

cat $FTRACE_PATH/trace_stat/function0 > $LOG_PATH/funccount.log
cat $FTRACE_PATH/trace_stat/function1 >> $LOG_PATH/funccount.log
cat $FTRACE_PATH/trace_stat/function2 >> $LOG_PATH/funccount.log
cat $FTRACE_PATH/trace_stat/function3 >> $LOG_PATH/funccount.log
cat $FTRACE_PATH/trace_stat/function4 >> $LOG_PATH/funccount.log
cat $FTRACE_PATH/trace_stat/function5 >> $LOG_PATH/funccount.log
cat $FTRACE_PATH/trace_stat/function6 >> $LOG_PATH/funccount.log
cat $FTRACE_PATH/trace_stat/function7 >> $LOG_PATH/funccount.log
#mv log/funccount.log py/
#python py/fcount.py
