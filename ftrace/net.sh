#!/bin/bash
FTRACE_PATH=/sys/kernel/debug/tracing
#reset ftrace
echo 0 > $FTRACE_PATH/tracing_on

#-----------event------------------
#from available_events
echo > $FTRACE_PATH/set_event

#-----------filter------------------
#from available_filter_functions
echo  > $FTRACE_PATH/set_ftrace_filter
#-----------graph function------------------
#from available_filter_functions
echo > $FTRACE_PATH/set_graph_function


#------------tracer-----------------
#from available_tracers
echo nop > $FTRACE_PATH/current_tracer
echo 1 > $FTRACE_PATH/events/block/enable
#echo 1 > $FTRACE_PATH/events/iommu/enable
#echo 1 > $FTRACE_PATH/events/net/enable

#####################RUN######################
echo 0 > /proc/sys/vm/page-cluster
sync
echo 3 > /proc/sys/vm/drop_caches
free
echo 1 > $FTRACE_PATH/tracing_on
./../memory-test/rw/paging
echo 0 > $FTRACE_PATH/tracing_on

cat $FTRACE_PATH/trace > log/log
echo 0 > $FTRACE_PATH/events/block/enable
