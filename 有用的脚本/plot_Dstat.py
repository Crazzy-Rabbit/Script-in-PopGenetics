#!/usr/bin/env python
# -*- encoding: utf-8 -*-
'''
@File    :   plot_Dstat.py
@Time    :   2024/05/23 16:37:54
@Author  :   Lulu Shi 
@Mails   :   crazzy_rabbit@163.com
@link    :   https://github.com/Crazzy-Rabbit
'''

import click
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt


def plot(df, d_col, z_col, label_col, outfile):
    fig, ax = plt.subplots(1,2, figsize=(8, 5.5), sharey=True)

    ypos = np.arange(0, df.shape[0])
    labels = df[label_col].values

    ax[0].errorbar(y = ypos,
                   x = df[label_col].values,
                   xerr = df[d_col].values / df[z_col].values,
                   fmt = 'o',
                   color = 'grey')
    
    ax[0].vlines(0, -0.5, ypos[-1] + 0.5, linestyles = 'dashed', lw = 0.8)
    ax[0].set_ylim(-0.5, ypos[-1] + 0.5)
    ax[0].set_xlabel('$\t{D}$ statistics', fontsize = 15)
    ax[0].set_yticks(ypos)
    ax[0].set_yticklabels(labels)
    ax[0].spines['right'].set_visible(False)
    ax[0].spines['top'].set_visible(False)


    ax[1].errorbar(x = df[z_col].values,
                   y = ypos,
                   fmt = 'o',
                   ecolor = 'black',
                   elinewidth = 1,
                   markerfacecolor = 'k',
                   markeredgecolor = 'black',
                   markersize = 7.5,
                   markeredgewidth = 0,
                   alpha = 1)
    
    ax[1].vlines(-2, -0.5, ypos[-1] + 0.5, linestyles = 'dashed', lw = 0.8)
    ax[1].vlines(2, -0.5, ypos[-1] + 0.5, linestyles = 'dashed', lw = 0.8)
    ax[1].set_xlabel('Z values', fontsize = 15)
    plt.xticks([-15, -10, -5, -2, 0, 5], ['-15', '-10', '-5', '-2', '0', '5'])
    ax[1].spines['right'].set_visible(False)
    ax[1].spines['top'].set_visible(False)
    fig.suptitle('')
    plt.subplots_adjust(left = 0.25)
    plt.savefig(outfile)


@click.command()
@click.option('--infile', help='input file, split with tab')
@click.option('--d-col', help='colname of D value')
@click.option('--z-col', help='colname of Z value')
@click.option('--label-col', help='colname of label')
@click.option('--outfile', help='output file, such as test.png')
def main(infile, d_col, z_col, label_col, outfile):
    """
    \b
    D statistics 散点图
    """
    df = pd.read_csv(infile, sep = '\t', header = True)
    df = df[::-1]
    plot(df, d_col, z_col, label_col, outfile)

if __name__ == '__main__':
    main()
