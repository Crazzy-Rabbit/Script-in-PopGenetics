# -*- coding: utf-8 -*-
#! /usr/bin/env python3
"""
Created on Sun Apr 22 21:36:52 2018
@Mail: minnglee@163.com
@Author: Ming Li
"""

import sys,os,logging,click

logging.basicConfig(filename='{0}.log'.format(os.path.basename(__file__).replace('.py','')),
                    format='%(asctime)s: %(name)s: %(levelname)s: %(message)s',level=logging.DEBUG,filemode='w')
logging.info(f"The command line is:\n\tpython3 {' '.join(sys.argv)}")

def HandleHeader(line,output):
    output.write('#Chr\tSegment\tStart\tEnd\tTotalVar')
    line = line.strip().split()
    output.write('\t{0}\n'.format('\t'.join(line[3:])))
@click.command()
@click.option('-i','--Input',help='Input file',type=click.File('r'),required=True)
@click.option('-o','--Output',help='Output file',type=click.File('w'),required=True)
def main(input,output):
    '''
    #Chr    Pos     Segment A1      A14     A23     A25     A6      A7
    29      152644  2       Y|Y     N|Y     N|Y     Y|Y     N|Y     N|Y
    29      153287  2       Y|Y     N|Y     N|Y     N|Y     N|Y     N|Y
    29      153595  2       Y|Y     N|Y     N|Y     N|Y     N|Y     N|Y
    '''
    SegmentPosDict = {}
    IndSegmentVarDict = {}
    SegmentChr = {}
    for line in input:
        if line.startswith('#'):
            HandleHeader(line,output)
            continue
        line = line.strip().split()
        line[2] = int(line[2])
        SegmentChr[line[2]] = line[0]
        SegmentPosDict.setdefault(line[2],[]).append(int(line[1]))
        if line[2] not in IndSegmentVarDict: IndSegmentVarDict[line[2]] = [[0,0] for _ in range(len(line)-3)]
        for i in range(3,len(line)):
            Var = line[i].split('|')
            if Var[0] == 'Y': IndSegmentVarDict[line[2]][i-3][0] += 1
            if Var[1] == 'Y': IndSegmentVarDict[line[2]][i-3][1] += 1
    for i in range(max(SegmentChr.keys()) + 1):
        output.write(f'{SegmentChr[i]}\t{i}\t{min(SegmentPosDict[i])}\t{max(SegmentPosDict[i])}\t{len(SegmentPosDict[i])}')
        for j in range(len(line)-3):
            output.write(f'\t{IndSegmentVarDict[i][j][0]}|{IndSegmentVarDict[i][j][1]}')
        output.write('\n')
if __name__=='__main__':
    main()
