######  FPKM的计算  #####
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

# FPKM/RPKM (Fragments/Reads Per Kilobase Million )  每千个碱基的转录每百万映射读取的Fragments/reads 
counts2FPKM <- function(count=count, efflength=efflen){    
  PMSC_counts <- sum(count)/1e6   #counts的每百万缩放因子 (“per million” scaling factor) 深度标准化   
  FPM <- count/PMSC_counts        #每百万reads/Fragments (Reads/Fragments Per Million) 长度标准化   
  FPM/(efflength/1000)                                       
}
FPKM <- as.data.frame(apply(counts,2,counts2FPKM))
colnames(FPKM) <- c("C1","C2","C3","C4","M1","M3","M4") # 修改列名
FPKM <- FPKM[rowSums(FPKM)>1,] # 去除全部为0的列
colSums(FPKM) 
