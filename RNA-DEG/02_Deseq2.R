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

###############  PCA分析 使用对dds矩阵处理后的vst或rld值#################### 
#计算每个样本的归一化系数
vsd <- vst(dds,blind = FALSE)  ## 方差稳定变换
names(colData(vsd))  # 样本信息的列名,多了1列sizeFactor，colData(vsd)$sizeFactor
names(rowData(vsd))   # 基因信息的列名,多了4列

rld <- rlog(dds,blind = FALSE)  ## 正则化对数变换
names(colData(rld))  # 样本信息的列名,多了1列sizeFactor，colData(vsd)$sizeFactor
names(rowData(rld))
# rlog函数将count data转换为log2尺度，以最小化有small counts的行的样本间差异，并使library size标准化
## vst函数快速估计离散趋势并应用方差稳定变换。
## 数据集小于30个样品可以用rlog，数据集大于30个样品用vst，因为rlog速度慢
# 转换的目的是，为了确保所有基因有大致相同的贡献
plotPCA( DESeqTransform(raw), intgroup=c("condition"))+theme_bw()+ theme(panel.grid.major = element_blank(), #删除主网格线
                                                            panel.grid.minor = element_blank())
plotPCA(vsd, intgroup=c("condition"))
plotPCA(rld, intgroup=c("condition"))




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



####### DESeq2分析中得到的resdata进行绘制火山图  #####
rm(list=ls())  
resdata <- read.table("diffexpr_padj_results.txt",header = T,sep = '\t',row.names = 1)### 加载DESeq2中生成的resdata文件
resdata$label <- c(rownames(resdata)[1:10] ,rep(NA,(nrow(resdata)-10)))##对前10个基因进行标注

library(ggplot2)
ggplot(resdata,aes(x=log2FoldChange,y=-log10(padj))) +
##横向水平参考线，显著性--p值
geom_hline(yintercept = -log10(0.05),linetype = "dashed",color = "#999999")+
##纵向垂直参考线，差异倍数--foldchange
geom_vline(xintercept = c(-1 , 1),linetype = "dashed", color = "#999999")+
##散点图
geom_point(aes(size = -log10(padj),color = -log10(padj))) +
##指定颜色渐变模式
scale_color_gradientn(values = seq(0,1,0.2),
                       colors = c("#39489f","#39bbec","#f9ed36","#f38466","#b81f25"))+
##指定散点渐变模式
scale_size_continuous(range = c(0,3))+
  
##主题调整
###  theme_grey()为默认主题，theme_bw()为白色背景主题，theme_classic()为经典主题
theme_bw()+
##调整主题和图例位置
theme(panel.grid.major = element_blank(), #删除主网格线
        panel.grid.minor = element_blank(), #删除次网格线
        legend.position = c(0.08,0.9),      #设置图例位置
        legend.justification = c(0,1))+
##设置部分图例不显示
guides(col = guide_colourbar(title = "-Log10_q-value"),
         size = "none")+
##添加标签
geom_text(aes(label=c(label),color = -log10(padj)), size = 3, vjust = 1.5, hjust = 1)+
##修改坐标轴
xlab("Log2FC")+ylab("-Log10(FDR q-value)") 
##保存图片
ggsave("vocanol_plot.pdf", height = 9 , width = 10)
  


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

 



#######  Muffz时序表达聚类分析(Mac)   ######
## 使用（rld/vst）均一化后的表达矩阵
exprSet_new=assay(rld)
library("Mfuzz")
library('dplyr')
count <- data.matrix(exprSet_new)
eset <- new("ExpressionSet",exprs = count)
# 根据标准差去除样本间差异太小的基因
eset <- filter.std(eset,min.std=0)
eset <- standardise(eset)

### 基因表达聚类，
## 纵坐标为 随时间变化的表达量
## 横坐标为 时间
# 如何决定聚类个数？
c <- 16
#  评估出最佳的m值
m <- mestimate(eset)
# 聚类
cl <- mfuzz(eset, c = c, m = m)
mfuzz.plot(eset,cl,
  mfrow=c(4,4),## 4行4列布局
  new.window= FALSE)

#每个簇下基因数量
cl$size
#每个基因所属簇
head(cl$cluster)
#基因和 cluster 之间的 membership，用于判断基因所属簇，对应最大值的那个簇
head(cl$membership)
#整合关系输出
gene_cluster <- cbind(cl$cluster, cl$membership)
colnames(gene_cluster)[1] <- 'cluster'

# 每个簇中的基因，具有相似的时间表达特征
# 黄线和绿线表示随时间变化表达量相差小的基因，红线和紫线表明随时间变化表达量相差大的基因。




#######  表达矩阵探索,选取差异表达的基因做热图  deseq后的排序文件 ######
library(pheatmap)
choose_gene=head(rownames(res_padj),50)  
choose_matrix=countdata.filter[choose_gene,]  #抽取差异表达显著的前50个基因
choose_matrix=t(scale(t(choose_matrix)))  #用t函数转置，scale函数标准化

png(filename = "DEG_pheatmap.png", width = 600, height = 1000)
pheatmap(choose_matrix)
dev.off()
