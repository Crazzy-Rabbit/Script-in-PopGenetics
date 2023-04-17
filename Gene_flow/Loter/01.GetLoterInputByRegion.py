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

def Submit(queue,corenum,memory,Output,ShellName):
    os.system(f'jsub -R "rusage[res=1]span[hosts=1]" \
                     -q {queue} \
                     -n {corenum} \
                     -M {memory*1000000} \
                     -o {Output}/{ShellName}.o \
                     -e {Output}/{ShellName}.e \
                     -J {ShellName} \
                     bash {Output}/{ShellName}.sh')
def RenewRegion(Region,step):
    Region = Region.replace(':','-').split('-')
    if int(Region[1]) <= step: Start = Region[1]
    else: Start = int(Region[1]) - step
    End = int(Region[2])
    return f'{Region[0]}:{Start}-{End}'
def GetShell(queue,corenum,memory,output,Region,File,step):
    Region = RenewRegion(Region,step)
    Shell = open(f'{Region}.sh', 'w')
    Shell.write(f'#/bin/bash\n')
    Shell.write(f'for pop in DOM MOU URI AGL BIG THIN\n') # 修改群体ID，也就是你poplist的前缀名
    Shell.write(f'do\n')
    Shell.write(f'bcftools view {File} -S ~/05.Sheep/03.WorldSheep/03.Group/$pop.list -r {Region} -O z -o {Region}.$pop.vcf.gz\n') # 修改poplist路径
    Shell.write(f'done\n')
    awk = "awk '{print $1,$2,$2/1000000}' OFS='\\t'"
    Shell.write(f"bcftools query -f '%CHROM\\t%POS\\n' {Region}.Dom.vcf.gz |{awk} > {Region}.map\n") # 修改gz文件中的Dom为上述pop中的任意一个的名字
    os.system(f'chmod 755 {output}/{Region}.sh')
    Submit(queue,corenum,memory,output,Region)
@click.command()
@click.option('--chr',type=click.File('r'),help='The chr length file',required=True)
@click.option('-v','--vcf',type=str,help='The path of input vcf file',required=True)
#@click.option('-l','--sample',type=str,help='The file of sample list',required=True)
@click.option('-w','--window',type=int,help='The window size',default=20000000)
@click.option('-s','--step',type=int,help='The step size',default=0)
@click.option('-o','--output',type=str,help='The output file path',required=True)
@click.option('-q','--queue',type=click.Choice(['cpu6130','jynodequeue','jyqueue','mem128queue','denovoqueue']),help='The job queue',default='jynodequeue')
@click.option('-c','--corenum',type=int,help='The core number of job',default=4)
@click.option('-m','--memory',type=int,help='The memory of job (Gb)',default=20)
def main(chr,vcf,window,step,output,queue,corenum,memory):
    '''
    input file:
    1       275406953
    2       248966461
    '''
    if output[-1] == '/' : output = output[:-1]
    if vcf[-1] == '/' : vcf = vcf[:-1]
    for line in chr :
        line = line.strip().split()
        Chr = line[0]
        File = f'{vcf}/Sheep.{Chr}.GATK.flt2.imp.phase.noBBS.vcf.gz'    #按实际情况更改，改为你总的那个vcf文件
        
        Num = math.floor(int(line[1])/window)
        Start,End = 1,window
        for i in range(1,Num + 1):
            if int(line[1]) - End <= window * 0.5:
                End = int(line[1])
                Region = f'{Chr}:{Start}-{End}'
                GetShell(queue,corenum,memory,output,Region,File,step)
                continue
            Region = f'{Chr}:{Start}-{End}'
            GetShell(queue,corenum,memory,output,Region,File,step)
            Start = 1 + window * i
            End = window * (i+1)
        if End != int(line[1]):
            End = int(line[1])
            Region = f'{Chr}:{Start}-{End}'
            GetShell(queue,corenum,memory,output,Region,File,step)
if __name__ == '__main__':
    main()
