# -*- coding: utf-8 -*-
#!/usr/bin/env python3
'''
Created on Mon Sep  3 15:48:34 CST 2018
@Mail: minnglee@163.com
@Author: Ming Li
'''

import sys,os,logging,click

logging.basicConfig(filename='{0}.log'.format(os.path.basename(__file__).replace('.py','')),
                    format='%(asctime)s: %(name)s: %(levelname)s: %(message)s',level=logging.DEBUG,filemode='w')
logging.info(f"The command line is:\n\tpython3 {' '.join(sys.argv)}")

@click.command()
@click.option('-i','--input',type=str,help='The path of input file',required=True)
@click.option('-s','--source',type=str,help='The name of source population',multiple=True,required=True)
@click.option('-t','--target',type=str,help='The name of target population',required=True)
@click.option('-o','--output',type=str,help='The output file',required=True)
@click.option('-q','--queue',type=click.Choice(['cpu6130','jynodequeue','jyqueue','mem128queue','denovoqueue']),help='The job queue',default='jynodequeue')
@click.option('-c','--corenum',type=int,help='The core number of job',default=16)
@click.option('-m','--memory',type=int,help='The memory of job (Gb)',default=85)
def main(input,source,target,output,queue,corenum,memory):
    if input[-1] == '/' : input = input[:-1]
    if output[-1] == '/' : output = output[:-1]
    if not os.path.exists(f'{output}/shell'): os.system(f'mkdir {output}/shell')
    os.system(f'ls {input}/*.map|sed s#{input}##g|sed s#/##g|sed s#.map##g > {output}/Region.list')
    INPUT = open(f'{output}/Region.list')
    for line in INPUT:
        line = line.strip()
        print(line)
        Script = open(f'{output}/shell/{line}.py','w')
        Script.write('''# -*- coding: utf-8 -*-
#!/usr/bin/env python3
import numpy as np
import allel
import loter.locanc.local_ancestry as lc    # 得安装了loter才能调用这个模块，最好用conda 安装
#import matplotlib.pyplot as plt
def vcf2npy(vcfpath):
    callset = allel.read_vcf(vcfpath)
    haplotypes_1 = callset['calldata/GT'][:,:,0]
    haplotypes_2 = callset['calldata/GT'][:,:,1]
    
    m, n = haplotypes_1.shape
    mat_haplo = np.empty((2*n, m))
    mat_haplo[::2] = haplotypes_1.T
    mat_haplo[1::2] = haplotypes_2.T
    
    return mat_haplo.astype(np.uint8)\n\n''')
        SourceHapList = []
        for pop in source:
            Script.write(f'{pop}_hap = vcf2npy("{input}/{line}.{pop}.vcf.gz")\n')
            SourceHapList.append(f'{pop}_hap')
        Script.write(f'{target}_hap = vcf2npy("{input}/{line}.{target}.vcf.gz")\n\n')
        SourceHap = ', '.join(SourceHapList)
        Script.write(f'res_impute, res_no_impute = lc.loter_local_ancestry([{SourceHap}], {target}_hap)\n\n')
        Script.write(f'np.savetxt("{line}.admixture.txt", res_no_impute[0], fmt="%i")\n')
        Script.write(f'np.savetxt("{line}.admixture-bootstrap.txt", res_no_impute[1], fmt="%i")\n')
        Script.write(f'np.savetxt("{line}.admixture-gen.txt", res_impute, fmt="%i")\n')
#    print(source)
#    print(target)
#    '''
    ###### submit
        os.system(f'jsub -R "rusage[res=1]span[hosts=1]" \
                     -q {queue} \
                     -n {corenum} \
                     -M {memory*1000000} \
                     -o {output}/shell/{line}.o \
                     -e {output}/shell/{line}.e \
                     -J Loter.{line} \
                     python3 {output}/shell/{line}.py')
#'''
if __name__ == '__main__':
    main()
