#! /usr/bin/env python
# -*- coding: utf-8 -*-
"""
Created on  12 14 11:00:44  2023

@Author: Lulu Shi

@Mails: crazzy_rabbit@163.com
"""
import os
import sys
import click
import logging

logging.basicConfig(filename=os.path.basename(__file__).replace('.py','.log'),
                   format='%(asctime)s: %(name)s: %(levelname)s: %(message)s',level=logging.DEBUG,filemode='w')
logging.info(f"The command line is:\n\tpython3 {' '.join(sys.argv)}")

def tratefam(famfile, treefile):
    # trate fam file
    for line in famfile:
        iD = line.split()[1]
        treefile.write('#' + iD + '\n')
    treefile.write('\n')
def tratedis(distancefile):
    # trate distancec file
    dis = [line.strip().split()[11] for line in distancefile]
    del dis[0]
    newdis = [round(1 - float(Value), 6) for Value in dis]
    newdis2 = [str(line) for line in newdis]
    return newdis2
@click.command()
@click.option('-d','--distancefile',type=click.File('r'), help='The genome distance file', required=True)
@click.option('-f','--famfile', type=click.File('r'), help='The fam file or id file--2 cols ', required=True)
@click.option('-n','--num',type=int, help='The individuals number of your pop', required=True)
@click.option('-t','--treefile',type=click.File('w'), help='out tree metrix file for mega', required=True)
def main(famfile, distancefile, num, treefile):
    """请注意，输出文件后缀需设为.meg，如： -t tree.meg\n
    -f 接受fam 文件或两列的id文件，第二列可设置为品种ID（各样本不能一样）\n
    id文件顺序需与fam文件一致
    """
    treefile.write(f"#mega\n!Title: Genetic distance data from {num} individuals;\n!Format DataType=distance DataFormat=UpperRight NTaxa={num};\n!Description\n No. of Taxa : {num}\n Gaps/Missing data : Pairwise Deletion\n Codon Positions : 1st+2nd+3nd+Noncoding\n Distance method : Nucleotide: Tamura-Nei  [Pairwise distances]\n d : Estimate\n;\n\n")
    tratefam(famfile, treefile)
    dis2 = tratedis(distancefile, treefile)

    # generate .meg file
    startn = 0; endn = num - 1; tmpn = 1
    for i in range(0, num-1):
        treefile.write('     ' * tmpn)
        for j in range(startn, endn):
            if j >= i:
                treefile.write(dis2[j] + '  ')
        treefile.write('\n')
        tmpn += 1; startn = endn; endn += num - (i+2)
if __name__ == '__main__':
    main()