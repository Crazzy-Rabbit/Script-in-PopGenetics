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

def LoadIntroAllele(Input,Output):
    '''
    #Chr    Pos     Segment A1      A14     A23     A25     A6      A7      A8      AJ1     AL1
    1       132729  23      N|N     N|N     N|N     N|N     N|N     N|N     N|N     N|N     N|N
    1       134001  23      N|N     N|N     N|N     N|N     N|N     N|N     N|N     N|N     N|N
    #Chr    Pos     Segment A1      A14     A23     A25     A6      A7      A8      AJ1     AL1
    2       132729  23      N|N     N|N     N|N     N|N     N|N     N|N     N|N     N|N     N|N
    2       134001  23      N|N     N|N     N|N     N|N     N|N     N|N     N|N     N|N     N|N
    '''
    Dict = {}
    Chr = set()
    Header = False
    for line in Input:
        line = line.strip().split()
        if line[0] == '#Chr':
            if not Header:
                Name = '\t'.join(line[3:])
                Output.write(f'#Chr\tStart\tEnd\tIntroNum\t{Name}\n')
            Header = True
            continue
        Chr.add(line[0])
        HapNum = (len(line)-3) * 2
        IntroStat = [int(line[1])]
        for i in range(3,len(line)):
            Intro = line[i].split('|')
            IntroStat.extend(Intro)
        Dict.setdefault(line[0],[]).append(IntroStat)
    return Dict,Chr,HapNum
def ReturnSlideWindowIndex(start,end,step,LastIndex,DictList):
    List = []
    index = LastIndex
    try:
        for i in range(LastIndex,end):
            if DictList[i][0] <= start + step:
                List.append(DictList[i])
                index = i+1
            elif DictList[i][0] <= end:
                List.append(DictList[i])
            else:
                break
        return List,index,True
    except IndexError:
        return List,index,False
def Calculate_Windowed(WinSnpList,StartIndex,HapNum):
    List = [0 for _ in range(HapNum)]
    for snp in WinSnpList:
        for i in range(len(snp)-1):
            if snp[i+1] == 'Y': List[i] += 1
    Tmp = []
    for i in range(0,len(List),2):
        Tmp.append(f'{List[i]}|{List[i+1]}')
    if len(WinSnpList) == 0 and StartIndex != 0:
        StartIndex -= 1
    return '\t'.join(Tmp),StartIndex

@click.command()
@click.option('-i','--input',type=click.File('r'),help='The input file',required=True)
@click.option('-w','--window',help='Window size',type=int,default=100000)
@click.option('-s','--step',help='Step Size',type=int,default=10000)
@click.option('-o','--output',type=click.File('w'),help='The output file')
def main(input,output,window,step):
    IntroDict,ChrSet,HapNum = LoadIntroAllele(input,output)
    print('IntroAllele File Loaded!')
    logging.info(f'IntroAllele File Loaded!')
    for CHR in ChrSet:
        end = window
        start = 0
        StartIndex = 0
        NotEnd = True
        while NotEnd :
            WinSnpList,StartIndex,NotEnd = ReturnSlideWindowIndex(start,end,step,StartIndex,IntroDict[CHR])
            Count,StartIndex = Calculate_Windowed(WinSnpList,StartIndex,HapNum)
            output.write(f'{CHR}\t{start}\t{end}\t{len(WinSnpList)}\t{Count}\n')
            start += step
            end += step
if __name__ == '__main__':
    main()
