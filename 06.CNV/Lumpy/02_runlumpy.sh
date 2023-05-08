#!/bin/bash
# 需要使用python2.7的环境
source /home/sll/miniconda3/bin/activate
conda activate python2.7

# 需要提供bam文件的bai索引文件
# 1.run lumpy
lumpyexpress \
-B /home/sll/2023-deer-study/20230405-deer/ReiD-18-bam/ReiD-18.sorted.addhead.markdup.bam,/home/sll/2023-deer-study/20230405-deer/ReiD-19-bam/ReiD-19.sorted.addhead.markdup.bam \ # 指定输入文件,可以多个样品
-S ReiD-18.splitters.bam,ReiD-19.splitters.bam \             # 指定分裂比对的文件，可以多个样品
-D ReiD-18.discordants.bam,ReiD-18.discordants.bam \           # 指定不正常比对文件，可以多个样品 
-o all.sv.lumpy.vcf
