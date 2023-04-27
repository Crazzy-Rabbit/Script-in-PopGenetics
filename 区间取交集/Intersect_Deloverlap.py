# -*- coding: utf-8 -*-
#! /usr/bin/env python
"""
Created on  04 27 16:55:07  2023
@Author : Lulu Shi
@Mails : crazzy_rabbit@163.com
"""
import csv
import click


def read_intervals(file):
    """
    bedtools intersect的代替版本，对两个区间文件文件取交集并去除重叠区间。
    从指定文件读取区间，要求文件中每一行是一个区间（必须含有3个整数字段：chr start end）
    :param file: 区间文件对象
    :return: 包含所有区间的元组列表，元组格式：(chrom, start, end)
    """
    intervals = []
    reader = csv.reader(file, delimiter='\t')
    for line_num, fields in enumerate(reader, start=1):
        try:
            chrom, start_str, end_str, *_ = fields  # 将多余的字段赋值给变量 _，表示不使用这些字段的值
            start, end = int(start_str), int(end_str)
            if start <= 0 or end <= 0:
                raise ValueError('Line {}: 区间起始或结束位置不能小于1'.format(line_num))
            intervals.append((chrom, start, end))
        except ValueError as e:
            click.echo('错误: {} - {}'.format(file.name, e))
    return intervals

def merge_sorted_intervals(intervals1, intervals2):
    """
    将两个已排好序的区间列表中的重叠部分合并成一个区间列表。
    :param intervals1: 第一个区间列表，元组格式：(chrom, start, end)
    :param intervals2: 第二个区间列表，元组格式：(chrom, start, end)
    :return: 合并后的区间列表
    """
    results = []
    i, j = 0, 0
    while i < len(intervals1) and j < len(intervals2):
        interval1 = intervals1[i]
        interval2 = intervals2[j]

        # intervals1 和 intervals2 没有交集
        if interval1[0] < interval2[0] or (interval1[0] == interval2[0] and interval1[2] < interval2[1]):
            i += 1
        elif interval2[0] < interval1[0] or (interval1[0] == interval2[0] and interval2[2] < interval1[1]):
            j += 1
        # intervals1 和 intervals2 有交集
        else:
            start = max(interval1[1], interval2[1])
            end = min(interval1[2], interval2[2])
            results.append((interval1[0], start, end))

            # 判断区间的结束位置，更新指针
            if interval1[2] < interval2[2]:
                i += 1
            elif interval2[2] < interval1[2]:
                j += 1
            else:
                i += 1
                j += 1

    # 合并重叠的区间
    non_overlapping = [results[0]] if len(results) > 0 else []
    for interval in results[1:]:
        last_interval = non_overlapping[-1]
        if (interval[0] != last_interval[0]) or (interval[1] > last_interval[2]):
            non_overlapping.append(interval)
        else:
            last_interval = (last_interval[0], last_interval[1], max(last_interval[2], interval[2]))
            non_overlapping[-1] = last_interval
    return non_overlapping


def write_intervals(intervals, file_path):
    """
    将区间写入到指定文件中。每一行为一个区间（格式：chrom start end）
    :param intervals: 元组列表，格式：(chrom, start, end)
    :param file_path: 输出文件路径
    """
    with open(file_path, 'w', newline='\n') as out_file:
        writer = csv.writer(out_file, delimiter='\t')
        for interval in intervals:
            writer.writerow(interval)


@click.command()
@click.option('--file1', '-f1', type=click.File('r'), required=True,
              help='第一个区间文件，chr start end三列的tab分隔文件，不需要表头')
@click.option('--file2', '-f2', type=click.File('r'), required=True,
              help='第二个区间文件，chr start end三列的tab分隔文件，不需要表头')
@click.option('--out', '-o', type=click.Path(writable=True, dir_okay=False), required=True, help='输出文件路径')
def merge_intervals(file1, file2, out):
    """
    合并两个区间文件中的重叠部分，并将结果写入输出文件。
    :param file1: 第一个区间文件，chr start end三列的tab分隔文件，不需要表头
    :param file2: 第二个区间文件，chr start end三列的tab分隔文件，不需要表头
    :param out: 输出文件路径
    """
    # 读取两个输入文件中的区间
    intervals1 = read_intervals(file1)
    intervals2 = read_intervals(file2)

    # 将区间按照序列号和起始位置进行排序
    intervals1.sort()
    intervals2.sort()

    # 检查输入文件是否为空文件
    if not (intervals1 and intervals2):
        click.echo('输入文件为空！')
        return

    # 合并区间并写入结果
    results = merge_sorted_intervals(intervals1, intervals2)
    write_intervals(results, out)


if __name__ == '__main__':
    merge_intervals()
