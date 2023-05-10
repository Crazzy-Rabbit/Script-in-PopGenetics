# -*- coding: utf-8 -*-
#! /usr/bin/env python
"""
Created on  05 10 10:39:56  2023
@Author : Lulu Shi
@Mails : crazzy_rabbit@163.com
"""
"""
CNVFilterAfterCNVcaller.py过滤后，对mergeCNVR文件提取后的文件
计算公式为：
VST =[Vt − (V1×N1+V2×N2)Nt]/Vt

V1和V2分别为两群体各自的拷贝数方差，
Nt为样本量总和，Vt为总的拷贝数方差

简化为：VST =[Vt − Vs]/Vt
Vs为群体各自拷贝数方差加权群体大小
Nt为样本量总和，Vt为总的拷贝数方差
参考：An atlas of CNV maps in cattle, goat and sheep
"""
import pandas as pd

# 读取所有个体的拷贝数列，修改range
total = pd.read_csv("mergeCNVR", sep="\t", dtype=float,
                   usecols=range(8, 10))
# 这里只选取pop1样本拷贝数区域列
pop1 = pd.read_csv("mergeCNVR", sep="\t", dtype=float,
                   usecols=range(8, 10))

# 这里只选取pop2样本拷贝数区域列,由range里面的数字修改
pop2 = pd.read_csv("mergeCNVR", sep="\t", dtype=float,
                  usecols=range(8, 10))

# 这个文件用于后面的注释和画曼哈顿图等
chat = pd.read_csv("mergeCNVR", sep="\t",
                   usecols=['chr', 'start', 'end'],
                   dtype{'chr': int,
                        'start': int, 'end': int})

# 计算各群体方差
pop1_sd = pop1.var(numeric_only=True, axis=1)
n_pop1 = len(pop1.columns)
pop1_sd.weight = pop1_sd*n_pop1

pop2_sd = pop2.var(numeric_only=True, axis=1)
n_pop2 = len(pop2.columns)
pop2_sd.weight = pop2_sd*n_pop2

# 两群体方差加权群体大小
Nt = len(total.columns)
Vs = (pop1_sd.weight + pop2_sd.weight)/Nt
# 两比较群体样本量之和的方差
Vt = total.var(numeric_only=True, axis=1)

# Vst
Vst = (Vt - Vs)/Vt
chat['Vst'] = Vst
chat.to_csv(f'Vst.txt', sep='\t', index=False)
