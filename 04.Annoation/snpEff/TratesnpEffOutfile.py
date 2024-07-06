#!/usr/bin/env python
# -*- encoding: utf-8 -*-
'''
@File    :   TratesnpEffOutfile.py
@Time    :   2024/05/29 09:20:14
@Author  :   Lulu Shi 
@Mails   :   crazzy_rabbit@163.com
@link    :   https://github.com/Crazzy-Rabbit
'''

import click

@click.command()
@click.option('--infile', type=click.File('r'), help="the out .anno.bed file that annotated by snpEff")
@click.option('--outfile', type=click.File('w'), help='out file name for you extract')
def main(infile, outfile):
    """
    用于对snpEff软件注释后的.anno.bed文件进行提取，\n
    提取后的每个变异占一行，方便查看对应的选择信号值与变异的关系
    """
    for line in infile:
        if line.startswith('#'):
            new_line = '\t'.join(line.split('|'))
            outfile.write('\t'.join(new_line.split(';')))

        else:
            parts = line.strip().split(';')
            if len(parts) >= 2:
                new_parts1 = '\t'.join(parts[1].split('|'))
                outfile.write(parts[0] + '\t' + new_parts1 + "\n")

                for content in parts[2:]:
                    new_content = '\t'.join(content.split('|'))
                    outfile.write(parts[0] + '\t' + new_content +'\n')

    print(f"处理完成，结果已保存")

if __name__ == '__main__':
    main()




