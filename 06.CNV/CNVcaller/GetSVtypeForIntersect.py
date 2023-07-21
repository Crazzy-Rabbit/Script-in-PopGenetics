#! /usr/bin/env python
# -*- coding: utf-8 -*-
"""
Created on  07 21 09:50:04  2023

@Author: Lulu Shi

@Mails: crazzy_rabbit@163.com
"""
import os
import sys
import click
import logging

logging.basicConfig(filename='{0}.log'.format(os.path.basename(__file__).replace('.py', '')),
                    format='%(asctime)s: %(name)s: %(levelname)s: %(message)s', level=logging.DEBUG,filemode='w')
logging.info(f"The command is:\n\tpython3 {' '.join(sys.argv)}")

@click.command()
@click.option('--vcffile', type=click.File('r'), help='CNVcaller 结束后的vcf文件', required=True)
# @click.option('--tsvfile', type=str, help='CNVcaller 结束后的tsv文件', required=True)
@click.option('--out', type=click.File('w'), help='输出文件名', required=True)
def main(vcffile, tsvfile, out):
    """
    CNVcaller结束后的vcf文件中提取svtype，用于矫正， 然后输出以下结果文件
    
    #CHROM  START   END     SVTYPE
    NC_006853.1     1001    15500   <DUP>
    NC_037328.1     1001    26000   <DEL>
    NC_037328.1     27001   30000   <DUP>
    """
    header = ("#CHROM\tSTART\tEND\tSVTYPE\n")

    out.write(header)
    for line in vcffile:
        if line.startswith('#'):
            continue
        else:
            colnum = line.strip().split('\t')
            info = colnum[7].split(':')
            svtype = info[1].split('=')[1]

        Chr = colnum[0]
        start = colnum[2].split(':')[1].split('-')[0]
        end = colnum[2].split(':')[1].split('-')[1]

        svtype_with = f"<{svtype}>" # 改成<DUP>，加上<>的输出形式，方便后续矫正
        out.write(Chr + '\t' + start + '\t' + end + '\t' + svtype_with + '\n')

if __name__ == '__main__':
    main()
