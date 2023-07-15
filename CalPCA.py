#! /usr/bin/env python
# -*- coding: utf-8 -*-
"""
Created on  07 15 17:21:27  2023

@Author: Lulu Shi

@Mails: crazzy_rabbit@163.com
"""
import click
import pandas as pd
from sklearn.decomposition import PCA

def load_data(infile):
    df = pd.read_csv(infile, sep='\t', header=None)
    return df.values

def pca(x):
    pca = PCA(n_componets=10)
    pca.fit(x)
    components_ay = pca.transform(x)
    explained_variance_ratio = pca.explained_variance_ratio_
    return components_ay, explained_variance_ratio

@click.command()
@click.argument('infile')
@click.argument('outprefix')
def main(infile, outprefix):
    """
    输入文件为纯数字矩阵，tab分隔，每行一个个体， 每列一个特征
    """
    x = load_data(infile)
    pcs, ratios = pca(x)
    pd.DataFrame(pcs).to_csv(f'{outprefix}.pcs', sep='\t', header=None, index=False)
    ratios.tofile(f'{outprefix}.explained_variance_ratio', sep='\n')
    
if __name__ =='__main__':
    main()

