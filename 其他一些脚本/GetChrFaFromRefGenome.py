#! /usr/bin/env python
# -*- coding: utf-8 -*-
"""
Created on  07 08 11:21:25  2023

@Author: Lulu Shi

@Mails: crazzy_rabbit@163.com
"""
import click

@click.command()
@click.option('-r', '--ref_fa', type=click.File('r'), help='reference genome fa file', required=True)
@click.option('-C', '--getchr', type=str, help='要提取的chr, such "NC_040252.1"', required=True)
@click.option('-c', '--getchrs', type=str, help='要提取的chr的下一个chr, 如 "NC_040253.1"', required=True)
@click.option('-o', '--out', type=click.File('w'), help='输出文件名称', required=True)
def main(ref_fa, getchr, getchrs, out):
    """
    从参考基因组fa文件中提取某条染色体的fa文件
    """
    for line in ref_fa:
        if line.startswith('>' + getchr):
            out.write(line)
        elif not line.startswith('>'):
            out.write(line)
        elif line.startswith('>' + getchrs):
            break


if __name__ == '__main__':
    main()
