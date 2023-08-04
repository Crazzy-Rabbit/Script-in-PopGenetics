##### Circos是个perl包，需要很多依赖，建议用conda安装
安装完成使用`circos -modules`检查依赖

###### 绘图
```
circos -conf main.conf
```

main.conf内容详解
```
<<include etc/colors_fonts_patterns.conf>>  # 导入配置文件：颜色
<<include ticks.conf>> # 这个文件记得提供

# 定义输出
<image>    
<<include etc/image.conf>>
</image>

# karyotype定义染色体名字、ID、位置信息，绘图的根本
karyotype = chr.txt

chromosomes_units = 1000000   # 指定距离单位u
chromosomes_display_default = yes  # 显示所有的染色体(no的话需要自己指定)
# chromosomes = ... 这样指定，染色体间用分号隔开

##################################################################

# 1. 第一圈：染色体，必须的部分
<ideogram>
<spacing>

default = 0.005r
# 设置圈图中染色体之间的空隙大小，我们设置为0.005r的意思是每个染色体之间的空隙

</spacing>

radius = 1r  # 初始圈半径
thickness = 40p  # 圈厚度
fill = yes  # 圈颜色，使用指定颜色
stroke_color = 160,32,240  #染色体外边框轮廓颜色，十进制RGB，英文单词也可
stroke_thickness=2p  #轮廓厚度

show_label = yes
label_font = default
label_radius = 1.075r
label_size = 30
label_parallel = yes

</ideogram>
#################################################################

# 绘制散点图
<plots>   # 整个绘图区域以这个开头，以</plots>结束，中间都是<plot></plot>代表一层

type             = scatter
stroke_thickness = 1
<plot>

file             = data.txt  # 指定绘制散点图文件
fill_color       = grey      # 点的填充色
stroke_color     = black     # 边框颜色
glyph            = circle    # 控制点的形状，circle代表圆形，triangle代表三角形，rectangle代表矩形
glyph_size       = 10

max   = 16    # 定义y轴的最大值
min   = 0
r1    = 0.95r     # 定义圆环的位置
r0    = 0.65r

### 定义本层的背景,可不要
### 每个background 定义一个区域的背景色，这个区域由y0和y1定义。y0代表起始位置，y1代表终止位置
<backgrounds>
<background>
color      = vvlgreen           
y0         = 0.006          
y1         = 0.013
</background>
</backgrounds>

### 定义本层的y轴刻度线
<axes>
<axis>
color      = lgreen
thickness  = 1      # 刻度线线条粗细
spacing    = 0.05r  # 定义刻度线的间隔
y0         = 0.006
</axis>
</axes>

### 满足condition这个条件时，执行rule语句，用来标注显著的东西咯
<rules>
<rule>
condition    = var(value) > 0.006
stroke_color = dgreen
fill_color   = green
glyph        = rectangle
glyph_size   = 8
</rule>
</rules>

</plot>

</plots>
<<include etc/housekeeping.conf>>
```
![circos](https://github.com/Crazzy-Rabbit/Script-in-Bio/assets/111029483/2c411449-5d6f-4fad-9884-f1d7b61be1b4)


