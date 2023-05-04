# 好看的富集气泡图的绘制
# GO气泡图
# BiocManager::install("openxlsx")

library(ggplot2)
library(openxlsx)
goinput <- read.xlsx("go.xlsx")                                   # 载入GO富集分析的结果文件

x=goinput$GeneRatio                                               # 设置以哪个数据为X轴
y=factor(goinput$Description,levels = goinput$Description)        # 设置Y轴

p = ggplot(goinput,aes(x,y))                                      # 开始以X轴和Y轴绘制画布
p1 = p + geom_point(aes(size=Count,color=-0.5*log(pvalue),shape=ONTOLOGY,))+
  scale_color_gradient(low = "SpringGreen", high = "OrangeRed")
p1

p1 + labs(color=expression(-log[10](pvalue)),
               size="Count",
               x="GeneRatio",
               y="Go_term",
               title="Go enrichment of test Genes")

# KEGG气泡图
library(ggplot2)
library(openxlsx)

kegginput <- read.xlsx("kegg.xlsx")
x=kegginput$pvalue
y=factor(kegginput$Term,levels = kegginput$Term)

p = ggplot(kegginput,aes(x,y))
p1 = p + geom_point(aes(size=Count,color=-0.5*log(pvalue)))+
  scale_color_gradient(low = "BLUE", high = "OrangeRed")          # 以颜色的由暗蓝到橙红代表P值的对数值

p2 = p1 + labs(color=expression(-log[10](pvalue)),
               size="Count",
               x="P value",
               y="KEGG",
               title="KEGG pathway of Target Genes")
p2
