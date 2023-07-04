# -*- coding: utf-8 -*-
#! /usr/bin/env python
"""
Created on  05 10 10:39:56  2023
@Author : Lulu Shi
@Mails : crazzy_rabbit@163.com
"""
import click
import pandas as pd

def load_pop(list):
    pop = pd.read_csv(list, header=None)
    return pop

def load_data(infile):
    df = pd.read_csv(infile, sep='\t')
    return df

def tochat(infile):
    df = pd.read_csv(infile, sep='\t',
                    usecols=['chr', 'start', 'end'],
                    dtype{'chr': str, 'start': ind, 'end': int})
    return df

def target(poplist, infile):
    target_df = infile.filter(items=['chr', 'start', 'end',
                                     'number', 'gap', 'repeat', 'gc', 'kmer',
                                     'average', 'sd'] + poplist[0].tolist())
    return target_df

@click.command()
@click.option('--file', help='GetCleanCNV.py的结果文件')
@click.option('--pop1', help='属于群体1的个体ID，一行一个ID')
@click.option('--pop2', help='属于群体2的个体ID，一行一个ID')
@click.option('--out', help='输出文件前缀')

def main(file, pop1, pop2, out):
    pop1list = load_pop(pop1)
    pop1 = target(pop1list, file)
    # 计算1群体方差
    pop1_sd = pop1.var(numeric_only=True, axis=1)
    n_pop1 = len(pop1.columns)
    pop1_sd.weight = pop1_sd * n_pop1

    pop2list = load_pop(pop2)
    pop2 = target(pop2list, file)
    # 计算2群体方差
    pop2_sd = pop2.var(numeric_only=True, axis=1)
    n_pop2 = len(pop2.columns)
    pop2_sd.weight = pop2_sd * n_pop2

    # 两群体方差加权群体大小
    Nt = len(total.columns)
    Vs = (pop1_sd.weight + pop2_sd.weight) / Nt
    # 两比较群体样本量之和的方差
    Vt = total.var(numeric_only=True, axis=1)

    # Vst
    Vst = (Vt - Vs) / Vt

    chat = tochat(file)
    chat['Vst'] = Vst
    chat.to_csv(f'{out}.Vst.txt', sep='\t', index=False)


if __name__ == '__main__':
    main()
