# -*- coding: utf-8 -*-
#! /usr/bin/env python
"""
Created on  04 27 15:35:18  2023
@Author : Lulu Shi
@Mails : crazzy_rabbit@163.com
"""

import click
@click.command()
@click.option('--input', '-i', type=click.File('r'), required=True, help='三列的tab分隔文件，不需要表头' )
@click.option('--out', '-o', type=click.File('w'), required=True, help='输出文件前缀')

def main(input, out):
    """
    去除我们取完交集之后单文件中区间的重复位置，最后得到的直接是无重叠的那种
    """
    intervals = []
    for line in input:
        chrom, start, end = line.strip().split('\t')
        intervals.append((chrom, int(start), int(end)))

    intervals.sort()
    non_overlapping = [intervals[0]]
    for interval in intervals[1:]:
        last_interval = non_overlapping[-1]
        if (interval[0] != last_interval[0]) or (interval[1] > last_interval[2]):
            non_overlapping.append(interval)
        else:
            last_interval = (last_interval[0], last_interval[1], max(last_interval[2], interval[2]))
            non_overlapping[-1] = last_interval

    for interval in non_overlapping:
        out.write('\t'.join(str(x) for x in interval) + '\n')


if __name__ == '__main__':
    main()
