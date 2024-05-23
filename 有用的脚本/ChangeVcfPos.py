#!/usr/bin/env python
# -*- encoding: utf-8 -*-
'''
@File    :   ChangeVcfPos.py
@Time    :   2024/05/23 08:52:12
@Author  :   Lulu Shi 
@Mails   :   crazzy_rabbit@163.com
@link    :   https://github.com/Crazzy-Rabbit
'''

import gzip
import click

def replace(line, pos):
    tline = line.split('\t')
    tline[1] = pos.strip()
    tline[7] = '.'
    return '\t'.join(tline)

@click.command()
@click.option('--invcf', help="vcf.gz file you want to change pos")
@click.option('--poslist', help='the pos file you want to change as, if not supposed, it will code begin 1', default=None)
@click.option('--outvcf', help='the output vcf.gz file')
def main(invcf, poslist, outvcf):
    flag = True
    if poslist:
        with gzip.open(invcf, 'rb') as f1, open(poslist) as f2, gzip.open(outvcf, 'wb') as f3:
            while flag:
                line = f1.readline().decode()
                if line[0] == '#':
                    f3.write(line.encode())
                else:
                    flag = False
                    pos = f2.readline().strip()
                    outstring = replace(line, pos)
                    f3.write(outstring.encode())
            # while only work as line start as # or the first line not start as #
            for line, pos in zip(f1, f2):
                outstring = replace(line.decode(), pos)
                f3.write(outstring.encode())

    else:
        pos = 1
        with gzip.open(invcf, 'rb') as f1, gzip.open(outvcf, 'wb') as f3:
            while flag:
                line = f1.readline().decode()
                if line[0] == '#':
                    f3.write(line.encode())
                else:
                    flag = False
                    outstring = replace(line, str(pos))
                    f3.write(outstring.encode())

            for line in f1:
                pos += 1
                outstring = replace(line.decode(), str(pos))
                f3.write(outstring.encode())

if __name__ == "__main__":
    main()
