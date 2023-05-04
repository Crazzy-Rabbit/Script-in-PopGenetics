# 可以将需要可视化的基因进行筛选，重新做成SE.MATS.JC.txt这种文件，然后可视化就可以了
rmats2sashimiplot --b1 SRR17709911_sort.bam,SRR17709912_sort.bam,SRR17709913_sort.bam \
                  --b2 SRR17709916_sort.bam,SRR17709915_sort.bam,SRR17709914_sort.bam \
                  -t SE \
                  -e SE.MATS.JC.txt \
                  --l1 DP_M \
                  --l2 Han_M \
                  -o M_SE_plot

# --b1 B1 sample_1 in bam format(s1_rep1.bam[,s1_rep2.bam])
# --b2 B2 sample_2 in bam format(s2_rep1.bam[,s2_rep2.bam])
# -t  rMATS结果中产生的可变剪切类型{SE,A5SS,A3SS,MXE,RI}
# -e  EVENTS_FILE The rMATS output event file (Onlyif using rMATSformat result as event file).
# --l1 L1 The label for first sample.
# --l2 L2 The label for second sample.-o OUT_DIR The output directory.
