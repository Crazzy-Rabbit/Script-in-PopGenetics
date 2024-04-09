#! /usr/bin/env python
# -*- coding: utf-8 -*-
"""
Created on  07 15 16:18:03  2023

@Author: Lulu Shi

@Mails: crazzy_rabbit@163.com
"""
import allel
import click
import pandas as pd
from collections import defaultdict

@click.command()
@click.option('--invcf')
@click.option('--groupfile', help='sampleID\tgroupID')
@click.option('--outfile', help='outfile name')
def main(invcf, groupfile, outfile):
    """
    使用python的allel库计算vcf文件中的等位基因频率

    如果ALT频率都是0的话，就只会有一列REF的频率了
    """
    group2inds = defaultdict(list)
    with open(groupfile) as f:
        for line in f:
            sampleID, groupID = line.strip().split()
            group2inds[groupID].append(sampleID)

    callset = allel.read_vcf(invcf, fields=['variants/CHROM', 'variants/POS', 'variants/REF', 'variants/ALT'],
                             numbers={'ALT': 1}) # 第2个及以上的ALT将被忽略（但是位点还在） 多等位推荐把不同ALT分开在vcf的不同行
    df = pd.DataFrame({'chr': callset['variants/CHROM'],
                       'pos': callset['variants/POS'],
                       'REF': callset['variants/REF'],
                       'ALT': callset['variants/ALT']})
    for group, samples in group2inds.items():
        print(group)
        print(samples)
        callset = allel.read_vcf(invcf, samples=samples,
                                 fields=['samples', 'calldata/GT'])
        af = allel.GenotypeArray(callset['calldata/GT']).count_alleles().to_frequencies()
        if af.shape[1] > 1: # ALT如果频率都是0的话，就只会有一列REF的频率了
            df[group] = af[:, 1]
        else:
            df[group] = .0
    df.to_csv(outfile, sep='\t', index=False, float_format='%.3f', np_rep='nan')

if __name__ == '__main__':
    main()
