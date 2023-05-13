# -*- coding: utf-8 -*-
#! /usr/bin/env python
"""
Created on  05 13 10:49:45  2023
@Author: Lulu Shi
@Mails: crazzy_rabbit@163.com
"""
import pandas as pd
import click
import os


def load_data(infile):
    df = pd.read_csv(infile, header=None,
                     delimiter="\t|\s+", engine='python')
    return df

def convert(pop, bed):
    fam = pd.read_csv(f'{bed}.fam', delimiter='\t|\s+',
                      header=None, engine='python')
    fam[0] = fam[0].map(pop.set_index(1)[2]).fillna(fam[0])
    fam[1] = fam[1]
    return fam


@click.command()
@click.option('-s', '--sample', type=str, help='样本文件，三列 群体ID 样本ID 群体ID', required=True)
@click.option('-b', '--bed', type=str, help='plink格式bed文件前缀', required=True)
@click.option('-o', '--output', type=str, help='输出文件前缀', required=True)
def main(sample, bed, plink2treemix, output):
    """
    将plink格式文件转换为treemix软件的输入文件

    """
    pop = load_data(sample)
    covfam = convert(pop, bed)
    covfam.to_csv(f'{bed}.fam', index=False,
                  header=False, sep='\t')

    Shell = open(f'plink2treemix.in.sh', 'w')
    Shell.write('#! /bin/bash\n')
    Shell.write(f'plink --bfile {bed} --allow-extra-chr --chr-set 29 --freq --within {sample}\n')
    Shell.write(f'gzip plink.frq.strat\n')
    Shell.write(f'python2 /home/sll/miniconda3/bin/plink2treemix.py plink.frq.strat.gz {output}.treemix.in.gz')
    os.system(f'bash plink2treemix.in.sh')


if __name__ == '__main__':
    main()
