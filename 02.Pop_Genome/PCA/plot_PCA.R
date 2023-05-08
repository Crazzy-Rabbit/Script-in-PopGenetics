rm(list=ls()) 
################
##在excel中将pca.eigenvec文件的第一列改为品种ID即可
a=read.table("QC.ld.sample126.chart.filter-geno005-maf003-502502.gcta.out.eigenvec",header=F)
a$V1 <- factor(a$V1,levels=c("Angus","Holstein","Simmental","Shorthorn",
                             "Charolais","Mishima-Ushi","Hanwoo","JPBC","Kazakh",
                             "Mongolian","Yanbian","Wenling","Brahman"))  ## 修改图例顺序

library("ggplot2")
Breed=a[,1] 

p = ggplot(data  = a , 
           aes(x = a[,3], y = a[,4],   ############x = a[,3], y = a[,4]代表第3列和第4列比较也就是pc1与pc2比较
               group = Breed,shape = Breed,stroke = 1.5))+
  geom_point(aes(color=Breed),size=3) +
  scale_shape_manual(values = seq(1,15)) + ##设置形状 # scale_shape_manual(values = rep(12,times = 13)) + 
  guides(color=guide_legend(override.aes = list(size=4, stroke = 1.5))) ##改变图例大小

  p + labs(x = "PC1(12.44%)", y = "PC2(5.87%)") + ############修改x轴和y轴的坐标名称   
  scale_color_manual(values=c("#66a61e", "#66a61e","#66a61e","#66a61e","#66a61e",
                                "#7470b3", "#e7288a","#e728e7","#e7288a","#e7288a","#e7288a",
                                "#b35107","#b35107")) +   
  theme_classic()+ # 去除灰色背景及网格线
  theme(panel.border = element_rect(fill=NA,color="black", size=0.5, linetype ="solid")) #添加边框


  ##计算方差解释度
  m <- as.matrix(read.table("QC.ld.sample126.chart.filter-geno005-maf003-502502.gcta.out.eigenval",header=F))
  explainm=m/sum(m)
  explainm[1:3]  #此处上面步骤 --pca 3，一般3个可以解释
