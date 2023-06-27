### 几种识别SV以及CNV的软件
### 个人推荐使用CNVcaller，是专门为动植物开发的识别CNV的软件
### 若使用LUNPY的话，建议再加上另外一种软件识别CNV，最后使用SUIVIVOR软件对其进行合并（结果并不好，因为SUIVIVOR适用于SV检测软件结果）。
### 因此，推荐之后使用bedtools进行交集的获取（-f参数设置重叠比例），以CNVcaller为主，LUMPY结果用于矫正
