#! /usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on  07 19 14:17:47  2023

@Author: Lulu Shi

@Mails: crazzy_rabbit@163.com
"""
import os
import sys
import gzip
import click
import logging

logging.basicConfig(filename='{0}.log'.format(os.path.basename(__file__).replace('.py','')),
                    format='%(asctime)s: %(name)s: %(levelname)s: %(message)s', level=logging.DEBUG,filemode='w')
logging.info(f"The command is:\n\tpython3 {' '.join(sys.argv)}")

@click.command()
@click.option('--vcffile',type=click.Path(exists=True), help='Smoove genotype结束的vcf.gz文件', required=True)
@click.option('--outfile',type=click.File('w'), help='输出文件名前缀', required=True)
def main(vcffile, outfile):
    """
    将smoove结束后的vcf文件进行提取，只要DEL和DUP的，输出为

    #CHROM  START   END     SVTYPE     QUAL
    NC_057815.1  16661447  16662858  <DEL>   945.05
    NC_057815.1  16742578  16744445  <DEL>   77.65
    NC_057815.1  23690497  23691285  <DEL>   974.98

    用于对CNVcaller结果或是其他cnv软件结果的矫正,之后就用bedtools取交集咯
    """
    outfile.write("#CHROM\tSTART\tEND\tSVTYPE\tQUAL\n")
    with gzip.open(vcffile, 'rt') as vcf_gz:
        for line in vcf_gz:
            if line.startswith('#'):
                continue
            else:
                colnums = line.strip().split('\t')
                if colnums[4] != '<DEL>' and colnums[4] != '<DUP>':
                    continue
                else:
                    Info = colnums[7].split(';')
                    End = Info[2].split('=')[1]

                    colnums_subset = colnums[0:2] + colnums[4:6]
                    colnums_subset[1] += '\t' + End
                    outfile.write('\t'.join(colnums_subset) + '\n')

if __name__ == '__main__':
    main()
