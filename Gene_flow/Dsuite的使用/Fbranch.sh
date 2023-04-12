# 4、Dsuite Fbranch：
# 是一种启发式方法，执行f-branch计算，用于解释f4-ratio相关结果
/home/sll/software/Dsuite/Build/Dsuite Fbranch sample.ML.tree.treeout sample_tree.txt > fbranch.out

# fbranch.out：f-branch统计量保存成矩阵格式

# 用dtools.py脚本绘制f-branch图
/home/sll/software/Dsuite/utils/dtools.py fbranch.out sample.ML.tree.treeout --outgroup Outgroup --use_distances --dpi 1200 --tree-label-size 30

# –outgroup：指定外类群（与fbranch.out和species.newick一致，一般是Outgroup）
# –use_distances：画树时使用newick文件里节点距离
# –dpi：设置png分辨率，有些期刊投稿要求1200，800，600不等；最好高点。
# –tree-label-size：设置树节点标签大小
