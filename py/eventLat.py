#Analyze event pattern in ftrace/blk.sh
#U can used analysized pattern to breakdown lock lat. and disk lat.

#The RDMA blk pattern:
#paging-6017  [008] ....  4615.614342: block_bio_remap: 8,32 R 17222768 + 8 <- (8,33) 17220720
#paging-6017  [008] ....  4615.614342: block_bio_queue: 8,32 R 17222768 + 8 [paging]
#paging-6017  [008] ....  4615.614343: block_getrq: 8,32 R 17222768 + 8 [paging]
#paging-6017  [008] ....  4615.614343: block_plug: [paging]
#paging-6017  [008] d...  4615.614343: block_rq_insert: 8,32 R 0 () 17222768 + 8 [paging]
#paging-6017  [008] d...  4615.614343: block_unplug: [paging] 1
#paging-6017  [008] d...  4615.614343: block_rq_issue: 8,32 R 0 () 17222768 + 8 [paging]
#<idle>-0     [008] ..s.  4615.614355: block_rq_complete: 8,32 R () 17222768 + 8 [0]


#The HDD blk pattern:
#paging-10477 [004] .... 28336.973288: block_bio_queue: 253,1 R 8334088 + 8 [paging]
#paging-10477 [004] .... 28336.973289: block_bio_remap: 8,3 R 8336136 + 8 <- (253,1) 8334088
#paging-10477 [004] .... 28336.973289: block_bio_remap: 8,0 R 10844936 + 8 <- (8,3) 8336136
#paging-10477 [004] .... 28336.973289: block_bio_queue: 8,0 R 10844936 + 8 [paging]
#paging-10477 [004] .... 28336.973290: block_getrq: 8,0 R 10844936 + 8 [paging]
#paging-10477 [004] .... 28336.973290: block_plug: [paging]
#paging-10477 [004] d... 28336.973290: block_rq_insert: 8,0 R 0 () 10844936 + 8 [paging]
#paging-10477 [004] d... 28336.973290: block_unplug: [paging] 1
#paging-10477 [004] d... 28336.973291: block_rq_issue: 8,0 R 0 () 10844936 + 8 [paging]
#<idle>-0     [004] ..s. 28336.973316: block_rq_complete: 8,0 R () 10844936 + 8 [0]
#<idle>-0     [004] ..s. 28336.973316: block_bio_complete: 253,1 R 8334088 + 8 [0]

stage = 0 #0~6
rmap_t = 0.0
issue_t = 0.0
comp_t = 0.0
disk_lat = 0.0
lock_lat = 0.0
count = 0
high_bond = 0.000100
low_bond = 0.000070
file = open("../ftrace/log/blk/l2d81.log","r")
#RDMA
#issue_stage = 6
#complete_stage = 7
#target = ["paging","paging","paging","paging","paging","paging","paging","<idle>"]
#event = ["block_bio_remap","block_bio_queue","block_getrq","block_plug","block_rq_insert","block_unplug","block_rq_issue","block_rq_complete"]

#HDD
issue_stage = 8
complete_stage = 9
target = ["paging","paging","paging","paging","paging","paging","paging","paging","paging","<idle>"]
event = ["block_bio_queue","block_bio_remap","block_bio_remap",
        "block_bio_queue","block_getrq","block_plug","block_rq_insert","block_unplug","block_rq_issue","block_rq_complete"]
for line in file :
    line = line.split()
    if "#" in line[0]:
        continue
    if target[stage] in line[0]:
        if line[4][:-1] == event[stage]:
            if stage == 0:
                rmap_t = float(line[3][:-1])
            elif stage == issue_stage:
                issue_t = float(line[3][:-1])
            elif stage == complete_stage:
                if low_bond <(float(line[3][:-1]) - issue_t) < high_bond:
                    #print 'Lock lat. %f' %(issue_t - rmap_t)
                    #print 'Disk lat. %f' %(float(line[3][:-1]) - issue_t)
                    lock_lat = lock_lat+issue_t - rmap_t
                    disk_lat = disk_lat + float(line[3][:-1]) - issue_t
                    count = count+1
                stage = 0
                continue
            stage = stage+1    
        else:
            stage = 0


print "MPF Count %d times" %count
print "Avg. lock lat %f us\nAvg. disk lat %f us" %(lock_lat*1000000/count,disk_lat*1000000/count) 
