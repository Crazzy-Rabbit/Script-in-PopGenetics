# -*- coding: utf-8 -*-
"""
Created on Thu Jul 23 15:45:47 2020

@author: YudongCai

@Email: yudongcai216@gmail.com
"""

import click
import numpy as np
import pandas as pd
from scipy.stats import norm
from scipy.stats import zscore
#from pingouin import multicomp
from statsmodels.stats.multitest import fdrcorrection


@click.command()
@click.option('--infile', help='input tsv data file, first row is header')
@click.option('--val-col', help='待计算值列名')
@click.option('--sep', help='分割符，默认tab分割', default=None)
@click.option('--tail', type=click.Choice(['left', 'right']), help='检验类型，默认右尾', default='right')
@click.option('--outfile', help='输出文件名')
def main(infile, val_col, sep, tail, outfile):
    """
    P values were estimated based on Z-transformed values using the standard normal distribution,
    and were further corrected by multiple testing using the Benjamini–Hochberg false discovery rate (FDR) method
    """
    if not sep:
        df = pd.read_csv(infile, sep='\t', dtype={val_col: float})
    else:
        df = pd.read_csv(infile, sep=sep, dtype={val_col: float})
    print(f'data loaded: {df.shape[0]} rows, {df.shape[1]} columns')
    df = df.dropna(subset=[val_col])
    print(f'data after dropna: {df.shape[0]} rows, {df.shape[1]} columns')
    mean = df[val_col].mean()
    std = df[val_col].std()
    print(f'mean: {mean}, std: {std}')
    df['Z-score'] = zscore(df[val_col].values)
    if tail == 'right':
        df['Pvalue'] = df['Z-score'].apply(lambda x: norm.sf(x)) # Survival function (also defined as 1 - cdf, but sf is sometimes more accurate).
    elif tail == 'left':
        df['Pvalue'] = df['Z-score'].apply(lambda x: norm.cdf(x)) # Cumulative distribution function.
#    df['FDR'] = multicomp(df['Pvalue'].values, method='fdr_bh')[1]
    df['FDR'] = fdrcorrection(df['Pvalue'].values, alpha=0.05, method='indep', is_sorted=False)[1]
    df.to_csv(outfile, sep='\t', index=False)


if __name__ == '__main__':
    main()
