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
countdata<- read.table("all_fcount.matrix.txt", header=TRUE,row.names = 1) #导入数据
head(countdata) # 查看数据前几行(列名 太长自己展示看)
##  过滤featurecounts后，每个样本计数小于等于10的！！！！！！！
countdata.filter<-countdata[rowSums(countdata)>=1&apply(countdata,1,function(x){all(x>=10)}),]
head(countdata.filter) 

colnames(countdata.filter) <- c("Han",rep("DP",3),rep("Han",3),"DP","Han","Han","DP","DP")# 修改列名，可以不改，记得样本名别重复，我这个是不对的哦
head(countdata.filter)
dim(countdata.filter) # 查看数据维度，即几行几列

################  dds矩阵的创建 ###############
library(DESeq2)
condition <- factor(c(rep("Zebu",5),rep("Holstein",5))) # 赋值因子，即变量，实验与对照
coldata <- data.frame(row.names=colnames(countdata.filter), condition) # 创建一个condition数据框
dds <- DESeqDataSetFromMatrix(countData=countdata.filter, colData=coldata, design=~condition) ##构建dds矩阵(后面很多分析都是基于这个dds矩阵)

####### DESeq2进行差异分析 #####
dds <- DESeq(dds)
resdata<- results(dds,contrast = c("condition","Zebu","Holstein"))##此为前比后
table(resdata$padj<0.05 ) # Benjamini-Hochberg矫正后的p<0.05的基因数！！！！！！！
res_padj <- resdata[order(resdata$padj), ]  ##按照padj(矫正后的p值)列的值排序

write.table(res_padj,"diffexpr_padj_results.txt",quote = F,sep = '\t')#### 将结果文件保存到本地，打开在第一列头加gene


################   获取DEseq标准化的 counts   ################
#获取 normalized_counts
normalized_counts <- as.data.frame(counts(dds, normalized=TRUE))
write.csv(normalized_counts, file="normalized.csv")


####### 筛选差异基因 #####
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
