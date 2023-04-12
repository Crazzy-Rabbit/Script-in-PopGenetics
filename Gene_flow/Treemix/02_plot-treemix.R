# 3、 最佳迁移边缘个数选择
# 将生成的llik、cov、modelcov文件放置在同一文件夹，使用R包OptM分析：

library(OptM)
linear = optM("./data") ##文件夹名
plot_optM(linear)

# 生成图中，当Δm值最小时的migration edges为最佳迁移边缘个数




# 4、基因渗入作图
# 使用m=最佳迁移边缘个数结果文件做图

source("plotting_funcs.R") #treemix scr文件夹中R脚本
plot_tree("TreeMix") #TreeMix为结果文件前缀

##===== 绘制混合树====
prefix="sample.3"  ## treemix产生的结果文件前缀
library(RColorBrewer)
library(R.utils)
 par(mfrow=c(2,3))
 for(edge in 1:3){
   plot_tree(cex=0.8,paste0(prefix,".",edge))
   title(paste(edge,"repetition"))
} # 放的是m012345，则0:5
