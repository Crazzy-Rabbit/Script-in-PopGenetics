#!/usr/bin/env python
# -*- encoding: utf-8 -*-
'''
@File    :   RandomVcfSite2NA.py
@Time    :   2024/05/29 08:52:20
@Author  :   Lulu Shi 
@Mails   :   crazzy_rabbit@163.com
@link    :   https://github.com/Crazzy-Rabbit
'''

import click
import random

@click.command()
@click.option('--invcf', type=click.File('r'), help="vcf file you want to random chang genotype as NA")
@click.option('--outvcf', type=click.File('w'), help="out vcf file which changed genotype as NA")
@click.option('--sites', type=click.File('w'), help="the file name of SNP site which changed genotype as NA")
def main(invcf, outvcf, sites):
    """
    随机把位点替换成缺失
    """
    row = 0
    col = 0

    for line in invcf:
        if line.startswith("#"):
            outvcf.write(line)
        else:
            row += 1
            temp_list = line.strip().split('\t')
            
            # 每个位点被选中的概率是10%
            if random.random() <= 0.1:
                new_list = []
                for i in range(0, len(temp_list)):
                    if i < 9:
                        new_list.append(temp_list[i])
                    
                    # 每个样本被选中的概率是20%
                    elif i >= 9 and random.random() <= 0.2:
                        new_list.append("./.")
                        GT = temp_list[i][0:3]

                        sites.write("%d\t%d\t%s\n"%(row, i+1, GT))
                    else:
                        new_list.append(temp_list[i])
                
                outvcf.write('%s\n'%("\t".join(new_list)))
            
            else:
                outvcf.write('%s\n'%("\t".join(temp_list)))


if __name__ == '__main__':
    main()
