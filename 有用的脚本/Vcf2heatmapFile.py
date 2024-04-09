#! /usr/bin/env python
# -*- coding: utf-8 -*-
"""
Created on  10 05 18:57:48  2023

@Author: Lulu Shi

@Mails: crazzy_rabbit@163.com
"""
import os
import click
import numpy as np
import pandas as pd
def load_vcf(vcf):
    tempout = open ("tempfile.txt", 'w')
    for line in vcf:
        if not line.startswith('##'):
            snp = line.strip().split('\t')[9:]
            ID = line.strip().split('\t')[2:3]
            tempout.write('\t'.join(ID + snp) + '\n')

def changesnp():
    file = pd.read_csv("tempfile.txt",
                       sep='\t', header=None)
    file_arr = np.array(file.T)
    file_arr[file_arr == '0/0'] = 0
    file_arr[file_arr == '0/1'] = 1
    file_arr[file_arr == '1/0'] = 1
    file_arr[file_arr == '1/1'] = 1
    return file_arr

@click.command()
@click.option('--vcf', type=click.File('r'), help='VCF file to heatmap', required=True)
@click.option('--out', type=str, help='out file perfix', required=True)
def main(vcf, out):
    """
    直接将提取的vcf文件转换为绘制单倍型图R脚本的输入文件
    """
    load_vcf(vcf)
    file_arr = changesnp()
    os.system('rm tempfile.txt')
    file_pd = pd.DataFrame(file_arr)
    file_pd.to_csv(f'{out}.txt', sep='\t',
                   header=False, index=None)

if __name__ == '__main__':
    main()




