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
    SegmentPosDict = {}
    SegmentAlleleDict = {}
    Header = False
    for line in Input:
        line = line.strip().split()
        if line[0] == '#Chr':
            if not Header:
                Name = '\t'.join(line[3:])
                Output.write(f'#Chr\tSegment\tIntro\tStart\tEnd\tIntroNum\t{Name}\n')
            Header = True
            IndividualNum = len(line) - 3
            continue
        Segment = f'{line[0]}-{line[2]}'
        SegmentPosDict.setdefault(Segment,[]).append(int(line[1]))
        for i in range(3,len(line)):
            Allele = line[i].split('|')
            SegmentAlleleDict.setdefault(Segment,[[] for _ in range(IndividualNum * 2)])[(i-3)*2].append(Allele[0])
            SegmentAlleleDict.setdefault(Segment,[[] for _ in range(IndividualNum * 2)])[(i-3)*2+1].append(Allele[1])
    return SegmentPosDict, SegmentAlleleDict, IndividualNum
@click.command()
@click.option('-i','--input',type=click.File('r'),help='The input file')
@click.option('-n','--number',help='The min number of continue introgressive variation',type=int,default=50)
@click.option('-o','--output',type=click.File('w'),help='The output file')
def main(input,output,number):
    GenomeLen = 2800000000
    TotalIntroLen = 0
    SegmentPosDict, SegmentAlleleDict, IndividualNum = LoadIntroAllele(input,output)
    print('IntroAllele File Loaded!')
    logging.info(f'IntroAllele File Loaded!')
    for Segment in SegmentAlleleDict:
#        print(Segment)
        pos = SegmentPosDict[Segment]
        IntroAlleleNumList = []
        for Hap in SegmentAlleleDict[Segment]:
            IntroAlleleNum = 0
            ValidIntroAlleleNum = 0
            for i in range(len(Hap)):
                if Hap[i] == 'Y':
                    IntroAlleleNum += 1
                elif IntroAlleleNum > number:
                    TotalIntroLen += (pos[i-1] - pos[i-1-number])
                    ValidIntroAlleleNum += IntroAlleleNum
                    IntroAlleleNum = 0
                else:
                    IntroAlleleNum = 0
            if IntroAlleleNum > number:
                TotalIntroLen += (pos[i-1] - pos[i-1-number])
                ValidIntroAlleleNum += IntroAlleleNum
            IntroAlleleNumList.append(ValidIntroAlleleNum)
        CHR,SEG = Segment.split('-')
        if sum(IntroAlleleNumList): Intro = 'Y'
        else: Intro = 'N'
        Tmp = []
        for i in range(0,len(IntroAlleleNumList),2):
            Tmp.append(f'{IntroAlleleNumList[i]}|{IntroAlleleNumList[i+1]}')
        ValidIntroAllele = '\t'.join(Tmp)
        output.write(f"{CHR}\t{SEG}\t{Intro}\t{pos[0]}\t{pos[-1]}\t{len(pos)}\t{ValidIntroAllele}\n")
    logging.info(f'The average length: {TotalIntroLen/(IndividualNum*2)}')
    print(f'The average length: {TotalIntroLen/(IndividualNum*2)}')
    logging.info(f'The average ratio of genome: {TotalIntroLen/(IndividualNum*2)/GenomeLen}')
    print(f'The average ratio of genome: {TotalIntroLen/(IndividualNum*2)/GenomeLen}')
if __name__ == '__main__':
    main()
