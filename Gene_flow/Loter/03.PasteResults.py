# -*- coding: utf-8 -*-
#!/usr/bin/env python3
'''
Created on Sat Aug  4 20:18:09 CST 2018
@Mail: minnglee@163.com
@Author: Ming Li
'''

import sys,os,logging,click
import math

logging.basicConfig(filename='{0}.log'.format(os.path.basename(__file__).replace('.py','')),
                    format='%(asctime)s: %(name)s: %(levelname)s: %(message)s',level=logging.DEBUG,filemode='w')
logging.info(f"The command line is:\n\tpython3 {' '.join(sys.argv)}")

@click.command()
@click.option('--chr',type=click.File('r'),help='The chr length file',required=True)
@click.option('-i','--input',type=str,help='The path of input file',required=True)
@click.option('-w','--window',type=int,help='The window size',default=20000000)
@click.option('-s','--step',type=int,help='The step size',default=0)
@click.option('-o','--output',type=str,help='The output file path',required=True)
@click.option('-q','--queue',type=click.Choice(['cpu6130','jynodequeue','jyqueue','mem128queue','denovoqueue']),help='The job queue',default='jynodequeue')
@click.option('-c','--corenum',type=int,help='The core number of job',default=4)
@click.option('-m','--memory',type=int,help='The memory of job (Gb)',default=20)
def main(chr,input,window,step,output,queue,corenum,memory):
    '''
    input file:
    1       275406953
    2       248966461
    '''
    if output[-1] == '/' : output = output[:-1]
    if input[-1] == '/' : input = input[:-1]
    for line in chr :
        line = line.strip().split()
        Chr = line[0]
        FileList = []
        Postfix = '.admixture.txt'    #按实际情况更改
        
        Num = math.floor(int(line[1])/window)
        Start,End = 1,window
        for i in range(1,Num + 1):
            if int(line[1]) - End <= window * 0.5:
                End = int(line[1])
                File = f'{input}/{Chr}:{Start}-{End}{Postfix}'
                FileList.append(File)
                continue
            File = f'{input}/{Chr}:{Start}-{End}{Postfix}'
            FileList.append(File)
            Start = 1 + window * i
            End = window * (i+1)
        if End != int(line[1]):
            End = int(line[1])
            File = f'{input}/{Chr}:{Start}-{End}{Postfix}'
            FileList.append(File)
        Command = f"paste -d ' ' {' '.join(FileList)} > {output}/{Chr}{Postfix}"
#        print(f'"{Command}"')
#'''
        os.system(f'jsub -R "rusage[res=1]span[hosts=1]" \
                     -q {queue} \
                     -n {corenum} \
                     -M {memory*1000000} \
                     -o {output}/{Chr}.o \
                     -e {output}/{Chr}.e \
                     -J Paste.{Chr} \
                     "{Command}"')
#'''
if __name__ == '__main__':
    main()
