############    Spearman相关性分析 使用TPM值  ###########
#  R语言里自带的相关性分析的函数是cor()，默认的皮尔逊相关性分析,
sp.data<- cor(TPM, method = "spearman")
# 图展示
library(corrplot)
corrplot(sp.data,
         order = "AOE", # 指定相关系数排序的方法，可以是特征向量角序(AOE)、第一主成分顺序(FPC)、层次聚类顺序(hclust)
         type = "full", # 展示类型。默认为全显full，还有upper和lower
         addCoef.col = "grey")# 添加相关系数值

# hclust聚类展示 , 有框框
corrplot(sp.data, order = "hclust", addrect = 2, rect.col = "black",hclust.method = "ward.D2")
## 表格展示
library(PerformanceAnalytics)
chart.Correlation(sp.data,histogram = T,pch=19)

###### PCA  使用TPM值 ###### 
data <- t(TPM) ##转置
data.pca <- prcomp(data, scale. = T)  #对数据标准化后做PCA，这是后续作图的文件 
summary(data.pca)  # 查看结果文件

head(data.pca$x)
#输出特征向量 
write.table(data.pca$rotation, file="PC.xls", quote=F, sep = "\t") 
#输出新表 
write.table(predict(data.pca), file="newTab.xls", quote=F, sep = "\t") 
#输出PC比重 
pca.sum=summary(data.pca) 
write.table(pca.sum$importance, file="importance.xls", quote=F, sep = "\t") 
## 画图
library(factoextra)
# 设置分组：
group=c(rep("C",4),rep("M",3))     ## 样本
fviz_pca_ind(data.pca, col.ind=group, 
             mean.point=F,  # 去除分组的中心点
             label = "none", # 隐藏样本标签
             addEllipses = T, # 添加边界线
             legend.title="Groups",
              # ellipse.type="confidence", # 绘制置信椭圆 
             ellipse.level=0,
             palette = c("#CC3333", "#339999",'red','blue'))+  #Cell配色哦 
  theme(panel.border = element_rect(fill=NA,color="black", size=1, linetype="solid"))#加个边框
