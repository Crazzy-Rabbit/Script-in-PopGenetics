# -*- coding: utf-8 -*-
"""
Created on Tue Jan 16 11:16:13 2018

@author: Caiyd
"""

import click
import numpy as np
import pandas as pd


def load_data(infile, nvars: int):
    df = pd.read_csv(infile, usecols=['CHROM', 'BIN_START', 'BIN_END', 'N_VARIANTS', 'PI'],
                     sep='\t',
                     dtype={'CHROM': str,
                            'BIN_START': int,
                            'BIN_END': int,
                            'N_VARIANTS': int,
                            'PI': float})
    df = df.loc[df['N_VARIANTS'] >= nvars, :]
    return df


@click.command()
@click.option('--group1', help='群体1的vcftools输出的Pi结果文件,支持全基因组压缩')
@click.option('--group2', help='群体2的vcftools输出的Pi结果文件,支持全基因组压缩')
@click.option('--nvars', help='snp数小于这个数的过滤掉, default is 20', default=20, type=int)
@click.option('--outprefix', help='输出结果文件前缀')
def main(group1, group2, nvars, outprefix):
    """
    计算ln(Pi_group1/Pi_group2)
    group1和group2是vcftools计算的滑动窗口Pi值
    """
    df1 = load_data(group1, nvars)
    df2 = load_data(group2, nvars)
    newdf = pd.merge(df1, df2, how='inner', on=['CHROM', 'BIN_START', 'BIN_END'],
                     suffixes=['_g1', '_g2'])
    newdf['ln_ratio'] = np.log(newdf['PI_g1'].values / newdf['PI_g2'].values)
    newdf[['CHROM', 'BIN_START',
           'BIN_END', 'ln_ratio']].to_csv(f'{outprefix}.gz',
                                          sep='\t', index=False, compression='gzip')


if __name__ == '__main__':
    main()
