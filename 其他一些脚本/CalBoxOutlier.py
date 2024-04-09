#! /usr/bin/env python
# -*- coding: utf-8 -*-
"""
Created on  07 15 16:54:14  2023

@Author: Lulu Shi

@Mails: crazzy_rabbit@163.com
"""
import click
import numpy as np
import pandas as pd


def cal_outlier(counts, x=3):
    Q1 = np.percentile(counts, 25)
    Q3 = np.percentile(counts, 75)
    IQR = Q3 - Q1
    upper_boundary = Q3 + IQR * x
    lower_boundary = Q1 - IQR * x
    return upper_boundary, lower_boundary

@click.command()
@click.option('--infile', help='input tsv file. use streams as input when set to -')
@click.option('--val-col', help='val column name')
@click.option('--k', help='k fold IQR', default=3, type=float)
def main(infile, val_col, k):
    if infile != '-':
        vals = pd.read_csv(infile, sep='\t', dtype={val_col: float}, usecols=val_col, squeeze=True).values
    else:
        vals = np.array([float(x.strip()) for x in click.get_text_stream('stdin')])
    upper_boundary, lower_boundary = cal_outlier(vals, k)
    print(f'upper_boundary: {upper_boundary}')
    print(f'lower_boundary: {lower_boundary}')

if __name__ == '__main__':
    main()