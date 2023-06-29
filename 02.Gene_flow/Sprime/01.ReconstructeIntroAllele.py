# -*- coding: utf-8 -*-
#! /usr/bin/env python3
"""
Created on Sun Apr 15 17:56:47 2018
@Mail: minnglee@163.com
@Author: Ming Li
"""

import sys,os,logging
import click
import gzip

logging.basicConfig(filename=os.path.basename(__file__).replace('.py','.log'),
                    format='%(asctime)s: %(name)s: %(levelname)s: %(message)s',level=logging.DEBUG,filemode='w')
logging.info(f"The command line is:\n\tpython3 {' '.join(sys.argv)}")

def LoadIntrogressionFragment(File):
    '''
    CHROM   POS     ID      REF     ALT     SEGMENT ALLELE  SCORE
    9       6624    .       C       T       12      1       2710303
    9       6821    .       A       G       12      1       2710303
    9       6936    .       G       A       12      1       2710303
    '''
    SegmentDict = {}
    for line in File:
        if line.startswith('CHROM'): continue
        line = line.strip().split()
        SegmentDict[f'{line[0]}-{line[1]}'] = [line[5],line[6]]
    return SegmentDict
def LoadSample(File):
    Dict = {}
    for line in File:
        line = line.strip()
        Dict[line] = None
    return Dict
def HandleHeader(line,SampleFile,output):
    SampleDict = LoadSample(SampleFile)
    SampleIndex = []
    output.write('#Chr\tPos\tSegment')
    line = line.strip().split()
    for i in range(4,len(line)):
        if line[i] in SampleDict:
            SampleIndex.append(line.index(line[i]))
            output.write('\t{0}'.format(line[i]))
    output.write('\n')
    return SampleIndex
@click.command()
@click.option('-f','--fragment',help='Tne introgression fragment file',type=click.File('r'),required=True)
@click.option('-v','--vcf',help='Tne VCF file',type=str,required=True)
@click.option('-S','--Sample',help='Sample List file',type=click.File('r'),required=True)
@click.option('-o','--Output',help='Output file',type=click.File('w'),required=True)
def main(fragment,vcf,sample,output):
    '''
    Standard VCF Format
    '''
    SegmentDict = LoadIntrogressionFragment(fragment)
    
    INPUT = os.popen(f'less {vcf}')
    for line in INPUT:
        line = line.strip()
        if line.startswith('##'): continue
        if line.startswith('#CHROM'):
            SampleIndex = HandleHeader(line,sample,output)
            continue
        else:
            line = line.strip().split()
            Index = f'{line[0]}-{line[1]}'
            if Index not in SegmentDict: continue
            if SegmentDict[Index][1] == '0':
                output.write('{0}\t{1}\t{2}'.format(line[0],line[1],SegmentDict[Index][0]))
                for i in SampleIndex:
                    if line[i] == '0|0':
                        output.write('\tY|Y')
                    elif line[i] == '0|1':
                        output.write('\tY|N')
                    elif line[i] == '1|0':
                        output.write('\tN|Y')
                    elif line[i] == '1|1':
                        output.write('\tN|N')
                output.write('\n')
            elif SegmentDict[Index][1] == '1':
                output.write('{0}\t{1}\t{2}'.format(line[0],line[1],SegmentDict[Index][0]))
                for i in SampleIndex:
                    if line[i] == '0|0':
                        output.write('\tN|N')
                    elif line[i] == '0|1':
                        output.write('\tN|Y')
                    elif line[i] == '1|0':
                        output.write('\tY|N')
                    elif line[i] == '1|1':
                        output.write('\tY|Y')
                output.write('\n')
if __name__=='__main__':
    main()
