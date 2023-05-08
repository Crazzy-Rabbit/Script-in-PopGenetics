library(scatterplot3d)
## 在做完pca后的数据中将一二列删除，加上对应的品种一列，并在第一行中加上行名
dat = read.table("PCA3D.txt",header=T, stringsAsFactors = T )
## stringsAsFactors = T 以factor格式将非数字变量导入
## class(dat$Breed) 查看变量类型
#####(这个是你的数据中包含的品种，顺序和txt里的顺序要一致)

# 颜色
####, "blue",   "red1", "cyan",  "blue", 
### "magenta4", "yellowgreen", "darkorange3", "grey60", "black","red4",  "lawngreen"

##, "black","red4","orange","red","magenta4", "yellowgreen", "darkorange3","purple3","paleturquoise3","green3"
color = c("cyan","darkred","green","dodgerblue1","blue","grey60")
color <- color[as.numeric(dat$Breed)]
# 形状
shapes = c(1:6)
shapes <- shapes[as.numeric(dat$Breed)]
# 画图
scatterplot3d(dat[,1:3], main='PCA', type='p',
              highlight.3d=F, angle=45, grid=T, box=T, scale.y=1,
              cex.symbols=0.9 , col.grid='lightblue',
              xlab = "PC1",ylab = "PC2",zlab = "PC3",
              pch= shapes,
              color = color)
# 图例
## pch和上面的shapes对应，col和 上面color对应即可
legend("topleft", legend = levels(dat$Breed) ,
       col =  c("cyan","darkred","green","dodgerblue1","blue","grey60"),
       cex = 0.8, xpd = TRUE,inset = 0.03,ncol = 2, bty = "n",
       pch= c(1:6))

### cex  修改字体， ### pt.cex  修改点的大小
### inset  调整图注位置， ### xpd  是否允许在作图区域外作图
### bty  图例框  是否画出，o为画出，n为不画出  ### ncol  图例分类的列数
### title  给图例添加标题   ### pch   点的类型


###pdf 把画图那部分替换了就行了
pdf("pca-3D.pdf", onefile = TRUE, width = 8, height = 8)
diffangle = function(ang){
  scatterplot3d(dat[,1:3], main='PCA', type='p',
                highlight.3d=F, angle=ang, grid=T, box=T, scale.y=1,
                cex.symbols=0.8 , col.grid='lightblue',
                xlab = "PC1",ylab = "PC2",zlab = "PC3",
                pch= shapes,
                color = color)
  # 图例
  ## pch和上面的shapes对应，col和 上面color对应即可
  
legend("topright",  legend = levels(dat$Breed) ,
         col = c("cyan","darkred","green","dodgerblue1","blue","grey60", "black","red4","red","magenta4", "yellowgreen", "darkorange3", "grey60"),
         cex = 0.8, xpd = TRUE,inset = 0.03,ncol = 2, bty = "n",
         pch= c(1:13))
  
}
sapply(seq(-360,260,5),diffangle)
dev.off()
