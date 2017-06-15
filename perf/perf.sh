#!/bin/bash
swapoff -a
echo 0 > /proc/sys/vm/page-cluster
echo 0 > /proc/sys/vm/swappiness
# RDMA test
swapon /dev/sdc1
sync
echo 3 > /proc/sys/vm/drop_caches

free
perf record -g -e instructions /home/kongyu/ky/memory-test/rw/paging
perf report --stdio > log/rdma.perf
rm perf.data
swapoff -a


#HDD test
swapon /dev/mapper/cl-swap
sync
echo 3 > /proc/sys/vm/drop_caches

free
perf record -g -e instructions /home/kongyu/ky/memory-test/rw/paging
perf report --stdio > log/hdd.perf
rm perf.data
swapoff -a
