

### 需要如下的文件结构
```
snakemake
├─ SNPcall
├─ config.yaml
├─ raw_fastq
│    ├─ SRR15006267.1.fq.gz
│    ├─ SRR15006267.2.fq.gz
│    ├─ SRR15006269.1.fq.gz
│    └─ SRR15006269.2.fq.gz
├─ reference
│    └─ ref.fa
└─ rules
       ├─ bwa_mem.rules
       ├─ fastp.rules
       ├─ gatk_INDELfilter.rules
       ├─ gatk_INDELselect.rules
       ├─ gatk_SNPfilter.rules
       ├─ gatk_SNPselect.rules
       ├─ gatk_combine.rules
       ├─ gatk_genotype.rules
       ├─ gatk_haplocall.rules
       ├─ picard_markdup.rules
       ├─ picard_sort.rules
       ├─ samtools_depth.rules
       └─ samtools_index.rules
```
### 只需修改`config.yaml`内容
- 保持文件夹名称和文件后缀和默认一致
- 指定软件位置
- 指定bwa和fastp所用thread

### 运行
```
snakemake -s snpcall --cores 30

# -s/--snakefile 指定Snakefile，否则是当前目录下的Snakefile
# --cores/--jobs/-j N: 指定并行数，如果不指定N，则使用当前最大可用的核心数
# 这个cores运行的任务和你指定的bwa和fastp的thread有关
```
> 由于总体上就分配了10个核心，于是一次就只能运行一个需要消耗8个核心的bwa_map。但是当其中一个bwa_map运行完毕，这个时候snakemaek就会同时运行一个消耗8个核心的bwa_map和没有设置核心数的samtools_sort,来保证效率最大化。因此对于需要多线程或多进程运行的程序而言，将所需的进程单独编码，而不是硬编码到shell命令中，能够更有效的使用资源。
