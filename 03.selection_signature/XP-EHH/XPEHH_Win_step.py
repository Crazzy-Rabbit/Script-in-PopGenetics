# -*- coding: utf-8 -*-
#! /usr/bin/env python
"""
Created on  05 17 19:33:05  2023
@Author: Lulu Shi
@Mails: crazzy_rabbit@163.com
"""
import pandas as pd
import click

def load_data(file):
    data = pd.read_csv(file, delimiter="\t|\s+", engine='python')
    return data

def results(data, step_size, window_size):
    result = []
    chromosome_length = max(data['pos'])

    for BIN_START in range(1, chromosome_length, step_size):
        BIN_END = BIN_START - 1 + window_size
        # 判断当前区间是否超出染色体范围
        if BIN_START + window_size > chromosome_length:
            break
        # 提取窗口内所有行的 normxpehh 统计值
        normxpehh_vals = []
        for _, row in data[(data['pos'] >= BIN_START) & (data['pos'] < BIN_END)].iterrows():
            if not pd.isna(row['pos']):
                normxpehh_vals.append(row['normxpehh'])

        # 计算 normxpehh 的平均值并保留4位小数, 统计区间SNP数量
        avg_normxpehh = round(sum(normxpehh_vals) / len(normxpehh_vals), 4)
        nvar = len(normxpehh_vals)
        # 将结果加到results列表中
        result.append([BIN_START, BIN_END, avg_normxpehh, nvar])
    return result

@click.command()
@click.option('-f','--file', help='xpehh.out.norm文件，norm后的位点文件，不是区间文件！！', required=True)
@click.option('-c','--chr', help='染色体号，因为是分染色体做的', required=True)
@click.option('-w','--window', help='窗口大小', required=True)
@click.option('-s','--step', help='步长大小', required=True)
def main(file, chr, window, step):
    data = load_data(file)
    window_size = window
    step_size = step
    out = results(data, step_size, window_size)

    # 创建一个 DataFrame 对象来保存结果，并使用 to_csv 方法将其写入文件中
    result_df = pd.DataFrame(out, columns=["BIN_START", "BIN_END", "avg_normxpehh", "navr"])
    result_df['CHROM'] = chr

    if chr == 1:
        result_df[["CHROM", "BIN_START", "BIN_END",
                   "navr", "avg_normxpehh"]].to_csv(f'{chr}.XPEHH', sep='\t',
                                                    index=False)
    else:
        result_df[["CHROM", "BIN_START", "BIN_END",
                   "navr", "avg_normxpehh"]].to_csv(f'{chr}.XPEHH', sep='\t',
                                                    index=False, header=False)

if __name__ == '__main__':
    main()
