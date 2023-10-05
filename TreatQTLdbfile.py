#! /usr/bin/env python
# -*- coding: utf-8 -*-
"""
Created on  09 25 10:38:58  2023

@Author: Lulu Shi

@Mails: crazzy_rabbit@163.com
"""
import click
@click.command()
@click.option('--QTLdb',type=click.File('r'),help='QTLdb bed file download from QTL database',required=True)
@click.option('--out',type=click.File('w'),help='Output file name',required=True)
def main(QTLdb,out):
    """
    将从QTL数据库下载下来的bed格式的文件换成下列格式，并调整有些位置

    Chr.X	741365	741369	Bovine respiratory disease susceptibility QTL (57587)
    Chr.X	1626461	1626465	Interval to first estrus after calving QTL (30110)
    Chr.X	1626461	1626465	Interval to first estrus after calving QTL (30331)
    """
    for line in QTLdb:
        if line.startswith('#'):
            continue
        elif line.startswith('Chr'):
            Chr = line.strip().split("\t")[0]
            tempStart = line.strip().split("\t")[1]
            tempEnd = line.strip().split("\t")[2]
            QTL = line.strip().split("\t")[3]
            if tempStart < tempEnd:
                out.write(f'{Chr}\t{tempStart}\t{tempEnd}\t{QTL}\n')
            elif tempStart > tempEnd:
                out.write(f'{Chr}\t{tempStart}\t{tempEnd}\t{QTL}\n')
            else:
                out.write(f'{Chr}\t{tempStart}\t{tempEnd}\t{QTL}\n')

if __name__ == '__main__':
    main()
