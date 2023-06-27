#! /bin/bash
# author: Shill
################ CNVCaller for genome data ##############

# Set up the file name(obtain the absolute paths), software                                             
CNVReferenceDB="/home/sll/miniconda3/CNVcaller/bin/CNVReferenceDB.pl"                  #change as you want
genomicfa="/home/sll/genome-cattle/ARS-UCD1.2/GCF_002263795.1_ARS-UCD1.2_genomic.fna"    #Reference genome fa file, change as you want
winsize=1000

# Create a window file for the genome (you can use it directly later)
perl $CNVReferenceDB $genomicfa -w $winsize
