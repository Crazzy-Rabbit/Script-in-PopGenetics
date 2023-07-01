# -*- coding: utf-8 -*-
"""
Created on Wed Jun 20 20:06:50 2018

@author: YudongCai

@Email: yudongcai216@gmail.com
"""

import os
import click
import numpy as np
import pandas as pd



def load_FST(fstfile):
    """
    返回一个series
    """
    print(f'FST file: {fstfile}', end='\t')
    df = pd.read_csv(fstfile, sep='\t', low_memory=True,
                     na_values='-nan', dtype={'CHROM': str,
                                              'POS': int,
                                              'WEIR_AND_COCKERHAM_FST': float})
    df['loc'] = df['CHROM'].astype('str') + ":" + df['POS'].astype('str')
    print(df.shape)
    return df.set_index('loc')['WEIR_AND_COCKERHAM_FST']


def load_Pi(pifile):
    """
    同上
    """
    print(f'PI file: {pifile}', end='\t')
    df = pd.read_csv(pifile, sep='\t', low_memory=True,
                     na_values='-nan', dtype={'CHROM': str,
                                              'POS': int,
                                              'WEIR_AND_COCKERHAM_FST': float})
    df['loc'] = df['CHROM'].astype('str') + ":" + df['POS'].astype('str')
    print(df.shape)
    return df.set_index('loc')['PI']



def load_snpeff(snpeffvcf, nskip):
    print(f'load snpeff {snpeffvcf}', end='\t')
    df = pd.read_csv(snpeffvcf, sep='\t', low_memory=False,
                     na_values='-nan', skiprows=nskip, usecols=['#CHROM', 'POS', 'REF', 'ALT', 'INFO'])
    df['loc'] = df['#CHROM'].astype('str') + ":" + df['POS'].astype('str')
    print(df.shape)
    return df


@click.command()
@click.option('--snpeffvcf', help='snpeff注释后的vcf(.gz)文件')
@click.option('--nskip', help='vcf的header前有多少行注释需要跳过', type=int)
@click.option('--fstfile', help='单点fst文件，支持压缩格式, Multiple Options', multiple=True)
@click.option('--pifile', help='单点pi文件，支持压缩格式, Multiple Options', multiple=True)
@click.option('--outprefix', help='输出文件前缀')
def main(snpeffvcf, nskip, fstfile, pifile, outprefix):
    df = load_snpeff(snpeffvcf, nskip)
    addcols = ['loc']
    for file in fstfile:
        name = os.path.basename(file).split('.')[0]
        s = load_FST(file)
        df[name] = df['loc'].map(s)
        addcols.append(name)
    for file in pifile:
        name = os.path.basename(file).split('.')[0]
        s = load_Pi(file)
        df[name] = df['loc'].map(s)
        addcols.append(name)
    outcols = ['#CHROM', 'POS', 'REF', 'ALT'] + addcols + ['INFO']
    df.to_csv(f'{outprefix}.tsv.gz', sep='\t', index=False, compression='gzip', na_rep='-nan')


if __name__ == '__main__':
    main()
