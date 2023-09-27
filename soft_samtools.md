##### 查看bam文件
```
samtools view myBAMfile.bam | less -S
```

##### 排序建索引
```
samtools sort -@ 24 -o myBAMfile.sort.bam myBAMfile.bam  #bam文件排序
samtools index -@ 24 myBAMfile.sort.bam #对排序后的bam建立索引
```

##### 提取某条染色体比对后文件
```
samtools view myBAMfile.sort.bam NC_007897.1 -@ 10 -O BAM -o NC_007897.1.bam
```

##### 提取某条染色体某些区域
```
samtools view ZL-30.sorted.addhead.markdup.bam -hb NC_037348.1:6600000-6700000 -@ 10 -O BAM -o NC_037348.1_6.6-6.7.bam
```
