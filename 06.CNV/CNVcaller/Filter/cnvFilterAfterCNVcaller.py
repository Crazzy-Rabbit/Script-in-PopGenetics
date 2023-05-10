# -*- coding: utf-8 -*-
#! /usr/bin/env python
"""
Created on  05 09 16:17:41  2023
@Author : Lulu Shi
@Mails : crazzy_rabbit@163.com
"""
"""
对CNVcaller结果进行过滤，条件为：
1、所有类型： 轮廓系数（silhouette_score） > 0.6
2、缺失型：0.05<del<0.95且dup<=0.01 且 lenth <= 50000
3、重复型： 0.05<dup<0.95且del<=0.01 且lenth <= 500000
4、# Both型： 0.05<dup<0.95 且 0.05<del<0.95 且 lenth < =50000

运行结束会输出5个文件：
1、三个类型的CNVR文件
Del_genotypeCNVR.txt，Del_genotypeCNVR.txt，Both_genotypeCNVR.txt 
2、chat.rectchr，用于Rectchr绘制拷贝数图谱
3、cal_VST.txt，用于计算VST
ps: 写这个脚本真是要了命了（我是新手，哭了）
"""

import pandas as pd

df = pd.read_csv("genotypeCNVR.tsv", usecols=['chr', 'start', 'end', 'silhouette_score','average', 'sd',
                                              'dd', 'Ad', 'AA', 'AB', 'BB', 'BC', 'M'],
                sep='\t',
                dtype={'chr': str, 'start': int, 'end': int,
                       'silhouette_score': float, 'average': float, 'sd': float,
                       'dd': int, 'Ad': int, 'AA': int,
                       'AB': int, 'BB': int, 'BC': int, 'M': int
                })

# 计算重复和缺失的频率
dup_freq = (df['AB'] + 2*df['BB'] + 2*df['BC'] + 2*df['M'])/(2*(df['dd'] + df['Ad'] + df['AA'] + df['AB'] + df['BB'] + df['BC'] + df['M']))
del_freq = (2*df['dd'] + df['Ad'])/(2*(df['dd'] + df['Ad'] + df['AA'] + df['AB'] + df['BB'] + df['BC'] + df['M']))

df['dup_freq'], df['del_freq']  = dup_freq, del_freq
df['lenth'] = df['end'] - df['start']

# 进行过滤
# 所有类型轮廓系数 > 0.6
# 缺失型：0.05<del<0.95且dup<=0.01 且 lenth <= 50000
Del = df.query('silhouette_score > 0.6 and 0.05 < del_freq < 0.95 and dup_freq <= 0.01 and lenth <= 50000')
Del['Type'] = 'Del'
if not Del.empty:
    Del.to_csv(f'Del_genotypeCNVR.txt', sep='\t', index=False)
else:
    print("No rows meet the criteria.")

# 重复型： 0.05<dup<0.95且del<=0.01 且lenth <= 500000
Dup = df.query('silhouette_score > 0.6 and 0.05 < dup_freq < 0.95 and del_freq <= 0.01 and lenth <= 500000')
Dup['Type'] = 'Dup'
if not Dup.empty:
    Dup.to_csv(f'Dup_genotypeCNVR.txt', sep='\t', index=False)
else:
    print("No rows meet the criteria.")

# Both型： 0.05<dup<0.95 且 0.05<del<0.95 且 lenth < =50000
Both = df.query('silhouette_score > 0.6 and 0.05 < dup_freq < 0.95 and 0.05 < del_freq < 0.95 and lenth <= 50000')
Both['Type'] = 'Both'
if not Both.empty:
    Both.to_csv(f'Both_genotypeCNVR.txt', sep='\t', index=False)
else:
    print("No rows meet the criteria.")

# 合并三种类型的拷贝数变异，结果用于画图
rectchr = pd.concat([Del, Dup, Both], axis=0)
rectchr[['chr', 'start', 'end', 'lenth', 'Type']].to_csv(f'chat.rectchr', sep='\t', index=False)

# 输出结果用于在mergeCNVR文件提取计算VST及vcf文件提取下游分析的文件
rectchr[['chr', 'start', 'end']].to_csv(f'Get_Region.txt', sep='\t', index=False)
