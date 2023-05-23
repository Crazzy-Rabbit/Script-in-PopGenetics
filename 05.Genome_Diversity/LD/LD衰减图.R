
rm (list = ls())
## 绘制LD衰减图

library(ggplot2)

# data样式 Dist pop1 pop2 ... 带有头文件
data = read.table("ALL_LD.txt", sep="\t", header=T)


ggplot(data, aes(x=Dist/1000), ylim=c(0, 1)) +
  # 绘制4条折线，并分别指定颜色和线型
  geom_line(aes(y=Ch_D_T, col="Ch_D_T", linetype="solid"), size =1) +
  geom_line(aes(y=Fe_D_T, col="Fe_D_T", linetype="solid"), size =1) +
  geom_line(aes(y=Fe_W_T, col="Fe_W_T", linetype="solid"), size =1) +
  geom_line(aes(y=Ru_W_T, col="Ru_W_T", linetype="solid"), size =1) +
  
  # 设置图例标签和线型，关闭显示图例标题
  scale_linetype_manual(values=c("solid","solid","solid", "solid"), guide = FALSE) +
  scale_color_manual(name="",
                     values=c("Ch_D_T" = "red",
                              "Fe_D_T" = "blue",
                              "Fe_W_T" = "green", 
                              "Ru_W_T" = "black")) +

  theme_bw()+ # 去除灰色背景
  theme(legend.position = c(0.9, 0.92), 
        legend.background = element_rect(fill = "transparent")) + # 图例背景透明
  theme(plot.title = element_text(hjust = 0.5)) + # 使主标题居中
  # 添加x、y轴标签和标题
  labs(title="LD deacy", x="Distence(Kb)", y= expression(r^{2}))
