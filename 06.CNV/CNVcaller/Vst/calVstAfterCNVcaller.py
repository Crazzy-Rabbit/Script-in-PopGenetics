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
    pop = pd.read_csv(list, sep='\t', header=None)
    return pop


def load_data(infile):
    df = pd.read_csv(infile, sep='\t')
    return df

def target(poplist, infile):
    target_df = infile.filter(items=['chr', 'start', 'end'] + poplist[0].tolist())
    return target_df

def cal_sd2(pop):
    sd2 = pop.iloc[:, 3:].var(numeric_only=True, axis=1)
    return sd2

@click.command()
@click.option('--file', help='GetCleanCNV.py的结果文件')
@click.option('--p1', help='属于群体1的个体ID，一行一个ID')
@click.option('--p2', help='属于群体2的个体ID，一行一个ID')
@click.option('--out', help='输出文件前缀')
def main(file, p1, p2, out):
    data = load_data(file)

    # 计算1群体方差
    pop1list = load_pop(p1)
    pop1 = target(pop1list, data)
    pop1_sd_weight = cal_sd2(pop1) * len(pop1)

    # 计算2群体方差
    pop2list = load_pop(p2)
    pop2 = target(pop2list, data)
    pop2_sd_weight = cal_sd2(pop2) * len(pop2)

    # 两群体方差加权群体大小
    Nt = len(pop1) + len(pop2)
    Vs = (pop1_sd_weight + pop2_sd_weight) / Nt

    # 两比较群体样本量之和的方差
    total = pd.concat([pop1.iloc[:, 3:], pop2.iloc[:, 3:]], axis=1)
    Vt = total.var(numeric_only=True, axis=1)

    # Vst
    Vst = (Vt - Vs) / Vt

    chat = pop1.iloc[:, :3]
    chat['Vst'] = Vst
    chat.to_csv(f'{out}.Vst.txt', sep='\t', index=False)


if __name__ == '__main__':
    main()
