import sys
file=open("../log/ftrace_rdma","r")
target = ["do_page_fault","swapin_readahead"]
do_pf=0
swapin =0
for line in file:
    log = line.split()
    #sum += float(log[4])
    if log[0] == "do_page_fault" :
        do_pf += int(log[1])
    elif log[0] == "swapin_readahead" :
        swapin += int(log[1])

print do_pf
print swapin
