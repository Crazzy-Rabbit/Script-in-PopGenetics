# -*- coding: utf-8 -*-
#!/usr/bin/env python3
'''
Created on Wed Sep 26 16:04:45 CST 2018
@Mail: minnglee@163.com
@Author: Ming Li
'''
#将合并后的分染色体 SweeD 结果取每个窗口的最大值
import sys,os,logging,click

logging.basicConfig(filename='{0}.log'.format(os.path.basename(__file__).replace('.py','')),
                    format='%(asctime)s: %(name)s: %(levelname)s: %(message)s',level=logging.DEBUG,filemode='w')
logging.info(f"The command line is:\n\tpython3 {' '.join(sys.argv)}")

def LoadCLR(File):
    '''
    //1
    Position        Likelihood      Alpha
    1673.0000       2.289699e-08    1.200000e+03
    //2
    Position        Likelihood      Alpha
    1673.0000       2.289699e-08    1.200000e+03
    '''
    Dict = {}
    ChrSet = set()
    next(File)
    for line in File:
        if line.startswith('\n'): continue
        if line.startswith('//'):
            Chr = line.strip()[2:]
            ChrSet.add(Chr)
            continue
        if line.startswith('Position'):continue
        line = line.strip().split()
#        print(line[0],float(line[1]))
        Dict.setdefault(Chr,[]).append([float(line[0]),float(line[1])])
    return Dict,ChrSet
def SlideWindow(start,end,step,Index,InList):
    SubList = []
    for i in range(Index,len(InList)):
        if InList[i][0] <= start + step:
            SubList.append(InList[i][1])
            Index = i+1
        elif InList[i][0] <= end: SubList.append(InList[i][1])
        else: return SubList,Index,True
    return SubList,Index,False
def CalculateWindow(List):
    SnpNum = len(List)
    if SnpNum == 0: return 0,0
    else:
        MaxCLR = max(List)
        return SnpNum,MaxCLR
@click.command()
@click.option('-i','--input',type=click.File('r'),help='The input file',required=True)
@click.option('-w','--window',help='Slide Window Size',type=int,default=50000)
@click.option('-s','--step',help='Step Size',type=int,default=50000)
@click.option('-o','--output',type=click.File('w'),help='The output file',required=True)
def main(input,window,step,output):
    output.write('CHR\tSTART\tEND\tSnpNum\tCLR\n')
    CLRDict,ChrSet = LoadCLR(input)
    for CHR in ChrSet:
        start,end = 0,window
        Index = 0
        NotEnd = True
        while NotEnd :
            WinSnpList,Index,NotEnd = SlideWindow(start,end,step,Index,CLRDict[CHR])
            SnpNum,Hp = CalculateWindow(WinSnpList)
            output.write(f'{CHR}\t{start}\t{end}\t{SnpNum}\t{Hp}\n')
            start += step
            end += step
if __name__ == '__main__':
    main()
