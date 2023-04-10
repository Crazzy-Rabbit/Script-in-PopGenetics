#! /bin/bash
# author: Shill
################ CNVCaller for genome data ##############
# Run this program in your bam file directory
# The format of the bam file should be .sorted.addhead.markdup.bam
# 800 in step 1 should change same as your Dup file window size
# 鹿基因组： /home/sll/software/snpEff/data/genomes/RedDeerv1.1.fa
# 牛基因组： /home/sll/genome-cattle/ARS-UCD1.2/GCF_002263795.1_ARS-UCD1.2_genomic.fna
# 鹿1000K窗口link文件： /home/sll/genome-red_deer/CNVCaller-Duplink/RedDeerv1.1_1000.link
# 牛1000K窗口link文件：/home/sll/genome-cattle/CNVCaller-Duplink/ARS-UCD1.2_1000.link

# Set up the file name(obtain the absolute paths), software                                             
CNVReferenceDBpl="/home/sll/miniconda3/CNVcaller/bin/CNVReferenceDB.pl"                  #change as you want
IndividualProcesssh="/home/sll/miniconda3/CNVcaller/Individual.Process.sh"               #change as you want
genomicfa="/home/sll/genome-cattle/ARS-UCD1.2/GCF_002263795.1_ARS-UCD1.2_genomic.fna"    #Reference genome fa file, change as you want
Winsizelink="/home/sll/miniconda3/CNVcaller/Btau5.0.1_800_link"                          #dup file that you have created use blasr, change as you want

winsize=1000
echo "CNVReferenceDB.pl:    $CNVReferenceDBpl";
echo "genomic.fna:    $genomicfna";
echo "Individual.Process.sh:    $IndividualProcesssh";
echo "winsize_link:    $Winsizelink";
echo "Winsize:    $winsize"

# Create a window file for the genome (you can use it directly later)
perl $CNVReferenceDBpl $genomicfa -w $winsize

# Calculate the absolute copy number  of each window
ls *markdup.bam|cut -d"." -f 1 | sort -u | while read id;
do
    bash $IndividualProcesssh -b `pwd`/${id}.sorted.addhead.markdup.bam -h $id -d $Winsizelink -s none;
done    
