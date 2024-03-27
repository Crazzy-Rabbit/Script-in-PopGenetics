############################
# if (!requireNamespace("BiocManager", quietly = TRUE))
# install.packages("BiocManager")
# BiocManager::install("DESeq2")
# install.packages("corrplot")
# install.packages("PerformanceAnalytics")
# install.packages("factoextra")

###### DESeq2 #####

###数据读入和处理
rm(list=ls()) 
options(stringsAsFactors = F)  
library(tidyverse) 
library(openxlsx)
a1 <- read.xlsx('GSE155489_gc_pcos_counts.xlsx')
countdata <- a1[,2:ncol(a1)] 
rownames(countdata) <- a1$gene
##  过滤featurecounts后，每个样本计数小于等于10的！！！！！！！
countdata.filter <- countdata[rowSums(countdata)>=1&apply(countdata,1,
                                                        function(x){all(x>=10)}),]
condition <- factor(c(rep("pcos",4),rep("control",4)))
contrast <- c("condition","pcos","control")

###### DESeq2 #####
library(DESeq2)
coldata <- data.frame(row.names=colnames(countdata.filter), condition)
dds <- DESeqDataSetFromMatrix(countData=countdata.filter, colData=coldata, design=~condition)
dds <- DESeq(dds)
resdata <- results(dds,contrast = contrast)
table(resdata$padj<0.05)
# define down and up gene
library(dplyr)
resdata <- as.data.frame(resdata)
res_padj <- resdata[order(resdata$padj), ]
res_padj$GENE <- rownames(res_padj)
res_padj <- res_padj %>% 
  mutate(change = case_when(padj < 0.05 & log2FoldChange > 1 ~ "UP",
                            padj < 0.05 & log2FoldChange < -1 ~ "DOWN",
                            TRUE ~ "NOT"))

write.table(res_padj,"GSE155489_diffexpr_padj_results.txt",quote = F,sep = '\t')


####获取DEseq标准化的 counts
#获取 normalized_counts
normalized_counts <- as.data.frame(counts(dds, normalized=TRUE))
write.csv(normalized_counts, file="normalized.csv")

####筛选差异基因
subset(resdata,pvalue < 0.05) -> diff  ## 先筛选pvalue < 0.05的行！！！！！
subset(diff,log2FoldChange < -0.585) -> down  ## 筛选出下调的,1.5倍
subset(diff,log2FoldChange > 0.585) -> up  ## 筛选出上调的，1.5倍
dim(down) # 查看数据维度，即几行几列
dim(up)

#导出上、下调基因的那一列
up_names<-rownames(up)
write.table(up_names,'up_gene.txt',quote = F,sep = '\t',row.names = F)
down_names <- rownames(down)
write.table(down_names,'down_gene.txt',quote = F,sep = '\t',row.names = F)
