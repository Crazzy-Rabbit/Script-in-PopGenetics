# -*- coding: utf-8 -*-
#! /usr/bin/env python3
"""
Created on Tue Apr 24 11:12:01 2018
@Mail: minnglee@163.com
@Author: Ming Li
"""

import sys,os,logging
import click

logging.basicConfig(filename='{0}.log'.format(os.path.basename(__file__).replace('.py','')),
                    format='%(asctime)s: %(name)s: %(levelname)s: %(message)s',level=logging.DEBUG,filemode='w')
logging.info(f"The command line is:\n\tpython3 {' '.join(sys.argv)}")

def CalRatio(line,ratio):
    IntroRatio = 0
    if line[3] == '0':
        return IntroRatio,'\t'.join(line[4:])
    Tmp = []
    IntroNum = 0
    for Ind in line[4:]:
        Hap = Ind.split('|')
        for i in range(2):
            HapRatio = round(int(Hap[i])/int(line[3]),2)
            if HapRatio > ratio : IntroNum += 1
            Tmp.append(HapRatio)
    IntroRatio = IntroNum/len(Tmp)
    Tmp2 = []
    for i in range(0,len(Tmp),2):
        Tmp2.append(f'{Tmp[i]}|{Tmp[i+1]}')
    return IntroRatio,'\t'.join(Tmp2)
@click.command()
@click.option('-i','--input',type=click.File('r'),help='The input file',required=True)
@click.option('-n','--number',help='the min number of introgression var',type=int,default=10)
@click.option('-r','--ratio',help='the min ratio of introgression var',type=float,default=0.8)
@click.option('-o','--output',type=click.File('w'),help='The output file')
def main(input,output,number,ratio):
    '''
    #Chr    Start   End     IntroNum        A1      A14     A23     A25     A6
    4       0       100000  0               0|0     0|0     0|0     0|0     0|0
    4       10000   110000  40              30|0     0|0     0|0     0|0     0|0
    '''
    Tab = '\t'
    for line in input:
        line = line.strip().split()
        if line[0] == '#Chr':
            output.write(f'{Tab.join(line[:4])}\tIfIntro\tIntroRatio\t{Tab.join(line[4:])}\n')
            continue
        IntroRatio,IndRatio = CalRatio(line,ratio)
        if int(line[3]) > number and IntroRatio > 0:
            output.write(f'{Tab.join(line[:4])}\tY\t{IntroRatio}\t{IndRatio}\n')
        else:
            output.write(f'{Tab.join(line[:4])}\tN\t{IntroRatio}\t{IndRatio}\n')
if __name__ == '__main__':
    main()
