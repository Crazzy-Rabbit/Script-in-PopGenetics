# install.packages("tidyverse")
# install.packages("data.table")
####
rm(list=ls()) 
options(stringsAsFactors = F)  
library(tidyverse) 
# ggplot2 stringer dplyr tidyr readr purrr  tibble forcats 
library(data.table) #可多核读取文件 
a1 <- fread('all.featurecounts.txt', header = T, data.table = F)#载入counts，第一列设置为列名 
### counts矩阵的构建 
counts <- a1[,7:ncol(a1)] 
#截取样本基因表达量的counts部分作为counts  
rownames(counts) <- a1$Geneid #将基因名作为行名 
### 从featurecounts 原始输出文件counts.txt中提取Geneid、Length(转录本长度)， 
geneid_efflen <- subset(a1,select = c("Geneid","Length"))        
colnames(geneid_efflen) <- c("geneid","efflen")   
geneid_efflen_fc <- geneid_efflen #用于之后比较 
### 取出counts中geneid的对应的efflen 
dim(geneid_efflen) 
efflen <- geneid_efflen[match(rownames(counts),                               
                              geneid_efflen$geneid),"efflen"] 

#当前推荐使用 TPM 进行相关性分析、PCA分析等 (Transcripts Per Kilobase Million)  每千个碱基的转录每百万映射读取的Transcripts 
counts2TPM <- function(count=count, efflength=efflen){   
  RPK <- count/(efflength/1000)   #每千碱基reads (reads per kilobase) 长度标准化   
  PMSC_rpk <- sum(RPK)/1e6        #RPK的每百万缩放因子 (“per million” scaling factor ) 深度标准化   
  RPK/PMSC_rpk                       
}
TPM <- as.data.frame(apply(counts,2,counts2TPM))
colnames(TPM) <- c("C1","C2","C3","C4","M1","M3","M4")# 修改列名
TPM <- TPM[rowSums(TPM)>1,] # 去除全部为0的列
colSums(TPM)
