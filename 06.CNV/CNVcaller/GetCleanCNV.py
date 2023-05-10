# -*- coding: utf-8 -*-
#! /usr/bin/env python
"""
Created on  05 10 14:19:40  2023
@Author : Lulu Shi
@Mails : crazzy_rabbit@163.com
"""
import click
import pandas as pd

def load_data(infile):
    df = pd.read_csv(infile, sep='\t',
                          dtype={'chr': str, 'start': int, 'end': int})
    return df

@click.command()
@click.option('--cnvr', help='genotype之前生成的合并拷贝数区域的文件mergeCNVR')
@click.option('--clean', help='做完过滤的cnv文件，三列包含头文件，chr start end')
@click.option('--out', help='输出文件前缀')
def main(cnvr, clean, out):
    """
    提取过滤后的CNVR文件，输入文件为mergeCNVR
    """
    df_data = load_data(cnvr)
    df_region = load_data(clean)

    # 向 df_data 中加入一列来标志是否在区域内
    df_data['match'] = False
    for index, row in df_region.iterrows():
        region_chr = row['chr']
        region_start = row['start']
        region_end = row['end']

        mask = (df_data['chr'] == region_chr) & (df_data['start'] == region_start) & (df_data['end'] == region_end)

        df_data.loc[mask, 'match'] = True

    df_result = df_data[df_data['match'] == True].copy()
    df_result.to_csv(f'{out}.txt', sep='\t', index=False)


if __name__ == '__main__':
    main()