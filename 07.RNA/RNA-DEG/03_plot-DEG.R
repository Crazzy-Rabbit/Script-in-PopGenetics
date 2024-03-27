###### DESeq2分析中得到的resdata进行绘制火山图  #####
rm(list=ls())  
resdata <- read.table("diffexpr_padj_results.txt",header = T,sep = '\t',row.names = 1)### 加载DESeq2中生成的resdata文件
# resdata$label <- c(rownames(resdata)[1:10] ,rep(NA,(nrow(resdata)-10)))##对前10个基因进行标注

library(ggplot2)
ggplot(resdata,aes(x=log2FoldChange,y=-log10(padj))) + 
geom_hline(yintercept = -log10(0.05),linetype = "dashed",color = "#999999")+ ##横向水平参考线，显著性--p值
geom_vline(xintercept = c(-1 , 1),linetype = "dashed", color = "#999999")+ ##纵向垂直参考线，差异倍数--foldchange
geom_point(aes(size = -log10(padj),color = -log10(padj))) + ##散点图
scale_color_gradientn(values = seq(0,1,0.2),
                      colors = c("#39489f","#39bbec","#f9ed36","#f38466","#b81f25"))+ ##指定颜色渐变模式
scale_size_continuous(range = c(0,3))+                                                ##指定散点渐变模式
  
##主题调整
###theme_grey()为默认主题，theme_bw()为白色背景主题，theme_classic()为经典主题
theme_bw()+
theme(panel.grid.major = element_blank(), #删除主网格线
        panel.grid.minor = element_blank(), #删除次网格线
        legend.position = c(0.08,0.9),      #设置图例位置
        legend.justification = c(0,1))+
guides(col = guide_colourbar(title = "-Log10_q-value"),
       size = "none")+ ##设置部分图例不显示
geom_text(aes(label=c(label),color = -log10(padj)), size = 3, vjust = 1.5, hjust = 1)+ ##添加标签
xlab("Log2FC")+ylab("-Log10(FDR q-value)")  ##修改坐标轴
ggsave("vocanol_plot.pdf", height = 9 , width = 10) ##保存图片




rm(list=ls())  
resdata <- read.table("GSE155489_diffexpr_padj_results.txt",header = T,sep = '\t',row.names = 1)
resdata$label <- c(rownames(resdata)[1:10] ,rep(NA,(nrow(resdata)-10)))

library(ggplot2)
ggplot(resdata, aes(x=log2FoldChange, y=-log10(padj), color=change))+
  geom_point(alpha=0.8, size=3)+
  labs(x="log2FC", y="-log10(FDR pvalue)")+
  scale_color_manual(values=c('#a121f0','#bebebe','#ffad21'))+
  theme_bw(base_size = 15)+
  theme(legend.position="none")+
  geom_vline(xintercept = 1,lty="dashed")+
  geom_vline(xintercept = -1,lty="dashed")+
  ggtitle("PCOS vs CON") 
