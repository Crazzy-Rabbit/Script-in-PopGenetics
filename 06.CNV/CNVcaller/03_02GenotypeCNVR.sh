#! /bin/bash
## genotype for CNVR

Genotypepy="/home/sll/miniconda3/CNVcaller/Genotype.py"                                  #change as you want
python="/home/sll/miniconda3/bin/python3.9"

# Genotype determination
$python $Genotypepy --cnvfile mergeCNVR --outprefix genotypeCNVR --nproc 8
