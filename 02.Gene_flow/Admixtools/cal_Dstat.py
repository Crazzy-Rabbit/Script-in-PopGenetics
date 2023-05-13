# -*- coding: utf-8 -*-
#! /usr/bin/env python
"""
Created on  05 13 17:13:52  2023
@Author: Lulu Shi
@Mails: crazzy_rabbit@163.com
"""
import pandas as pd
import click
import os

def  load_data(infile):
    df = pd.read_csv(infile, header=None,
                     delimiter="\t|\s+", engine='python')
    return df

@click.command()
@click.option('-p','--ped', type=str, help='plink格式ped文件前缀', requird=True)
@click.option('-s','--sample', type=str, help='样本ID文件，第一列为样品ID 第二列为群体ID', requird=True)
@click.option('-P','--popfile', type=str, help='提供A、B、C、D群体的pop文件，D可为外群，4列', requird=True)
@click.option('-o','--out', type=str, help='输出文件前缀', requird=True)
def main(ped, sample, popfile, out):
    """
    利用ENIGENSOFT软件的convertf模块将文件转换为Admixtools输入文件格式，再执行qpDstat
    """
    with open('transfer.conf', 'w') as par:
        conf_info = f"""genotypename:    {ped}.ped
    snpname:         {ped}.map # or example.map, either works
    indivname:       {ped}.ped # or example.ped, either works
    outputformat:    EIGENSTRAT
    genotypeoutname: {out}.eigenstratgeno
    snpoutname:      {out}.snp
    indivoutname:    {out}.ind
    familynames:    NO
        """
        par.write(conf_info)
    os.system(f'convertf -p transfer.conf')

    ind = load_data(f'{out}.ind')
    pop = load_data(sample)

    ind[2] = ind[0].map(pop.set_index(0)[1]).fillna(ind[0])
    ind.to_csv(f'{out}.ind', sep='\t',
               header=None, index=None)

    # convertf转换后的.snp及.ind文件前几列有空行，不确定会不会影响，所以用下面脚本读一下再输出
    snp = load_data(f'{out}.snp')
    snp.to_csv(f'{out}.snp', sep='\t',
               header=None, index=None)
    # 写Dstst输入文件
    with open('D.stat.par', 'w') as D:
        info = f"""genotypename:   {out}.eigenstratgeno
    snpname:        {out}.snp
    indivname:      {out}.ind
    popfilename:    {popfile}
    f4mode: NO  ##此选项为进行f4检验，默认是NO
        """
        D.write(info)
    os.system(f'qpDstat -p D.stat.par > {out}.Dstst')


if __name__ == '__main__':
    main()