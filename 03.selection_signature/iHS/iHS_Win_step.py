# -*- coding: utf-8 -*-
#! /usr/bin/env python
"""
Created on  06 16 10:37:57  2023
@Author: Lulu Shi
@Mails: crazzy_rabbit@163.com
"""
import pandas as pd
import click

def load_data(file):
    data = pd.read_csv(file, delimiter="\t|\s+",
                       engine='python')
    data.columns = ['CHROM', 'pos', 'freq', 'ihh1', 'ihh0',
                    'unstrandizediHS', 'normiHS', 'score']
    return data

def results(data, step_size, window_size):
    result = []
    chromsome_length = max(data['pos'])

    for BIN_START in range(1, chromsome_length, step_size):
        BIN_END = BIN_START - 1 + window_size
        if BIN_START + window_size > chromsome_length:
            break
        normiHS_vals = []
        for _, row in data[(data['pos'] >= BIN_START) & (data['pos'] < BIN_END)].iterrows():
            if not pd.isna(row['pos']):
                normiHS_vals.append(row['normiHS'])

        # 计算该区间内norm iHS的平均值， 统计区间SNP数量
        avg_normiHS = 0
        nvar = 0
        if len(normiHS_vals) > 0:
            nvar = len(normiHS_vals)
            avg_normiHS = round(sum(normiHS_vals) / nvar, 4)
        result.append([BIN_START, BIN_END, avg_normiHS, nvar])
    return result

@click.command()
@click.option('-f','--file', help='ihs.out.100bins.norm文件，norm后的位点文件', required=True)
@click.option('-c','--chr',help='染色体号，千万别合一起做', type=int, required=True)
@click.option('-w','--window', help='窗口大小', type=int, default=50000)
@click.option('-s','--step', help='步长大小', type=int, default=50000)
def main(file, chr, window, step):
    data = load_data(file)
    out = results(data, step, window)
    result_df = pd.DataFrame(out, columns=["BIN_START", "BIN_END",
                                           "avg_normiHS", "nvar"])
    result_df.loc[:, "CHROM"] = chr

    if chr == 1:
        result_df[["CHROM", "BIN_START", "BIN_END",
                   "nvar", "avg_normiHS"]].to_csv(f'{chr}.iHS', sep='\t',
                                                  index=False)
    else:
        result_df[["CHROM", "BIN_START", "BIN_END",
                   "nvar", "avg_normiHS"]].to_csv(f'{chr}.iHS', sep='\t',
                                                  index=False, header=False)

if __name__ == '__main__':
    main()
