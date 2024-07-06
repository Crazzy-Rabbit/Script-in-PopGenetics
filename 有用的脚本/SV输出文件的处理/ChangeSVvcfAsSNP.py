#!/usr/bin/env python
# -*- encoding: utf-8 -*-
'''
@File    :   ChangeSVvcfAsSNP.py
@Time    :   2024/05/28 08:57:27
@Author  :   Lulu Shi 
@Mails   :   crazzy_rabbit@163.com
@link    :   https://github.com/Crazzy-Rabbit
'''

import click

@click.command()
@click.option('--invcf', type=click.File('r'), help='vcf file you want change', required=True)
@click.option('--outvcf', type=click.File('w'), help='output vcf file you changed', required=True)
def main(invcf, outvcf):
    """
    将SV的vcf文件改成和SNP相似的形式，可用于分析与SNP的连锁或方便下游一些基于SNP软件的分析
    """
    for line in invcf:
        if line.startswith("#"):
            outvcf.write(line)
        else:
            temp_list = line.strip().split('\t')
            new_list = [None]*len(temp_list)

            new_list[0] = temp_list[0]
            new_list[1] = temp_list[1]
            new_list[2] = temp_list[0] + '_' + temp_list[1] + '_SV'       # id 改成有chr_pos_SV的形式
            new_list[3] = "A"                                             # ref 替换为单碱基
            new_list[4] = "T"                                             # alt 替换为单碱基
            new_list[5] = temp_list[5]
            new_list[6] = temp_list[6]
            new_list[7] = "."                                             # 去除INFO列内容
            new_list[8] = "GT"
            
            new_list[9:] = ['./.' if j.count(".") > 0 else j for j in [i[0:3] for i in temp_list[9:]]]
            outvcf.write("%s\n"%('\t'.join(new_list)))

if __name__ == '__main__':
    main() 
