#!/usr/bin/env python
# -*- encoding: utf-8 -*-
'''
@File    :   ChangeINDELvcfAsSNP.py
@Time    :   2024/05/28 09:32:41
@Author  :   Lulu Shi 
@Mails   :   crazzy_rabbit@163.com
@link    :   https://github.com/Crazzy-Rabbit
'''

import click

@click.command()
@click.option('--infile', type=click.File('r'), help="")
@click.option('--outfile', type=click.File('w'), help="")
def main(infile, outfile):
    for line in infile:
        if line.startswith("#"):
            outfile.write(line)
        else:
            temp_list = line.strip().split('\t')

            if len(temp_list[3]) == len(temp_list[4]):
                temp_list[2] = temp_list[0] + "_" + temp_list[1] + "_SNP"
            # 替换 INDEL 的 ref 和 alt
            else:
                temp_list[2] = temp_list[0] + "_" + temp_list[1] + "_INDEL"
                temp_list[3] = "A"
                temp_list[4] = "T"
            outfile.write("%s\n"%('\t'.join(temp_list)))

if __name__ == '__main__':
    main()
