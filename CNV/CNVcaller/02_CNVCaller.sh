#! /bin/bash
# author: Shill
################ CNVCaller for genome data ##############
# Run this program in your bam file directory
# The format of the bam file should be .sorted.addhead.markdup.bam
# 800 in step 1 should change same as your Dup file window size


# Set up the file name(obtain the absolute paths), software                                             
CNVReferenceDBpl="/home/sll/miniconda3/CNVcaller/bin/CNVReferenceDB.pl"                  #change as you want
IndividualProcesssh="/home/sll/miniconda3/CNVcaller/Individual.Process.sh"               #change as you want
CNVDiscoverysh="/home/sll/miniconda3/CNVcaller/CNV.Discovery.sh"                         #change as you want
Genotypepy="/home/sll/miniconda3/CNVcaller/Genotype.py"                                  #change as you want
genomicfna="/home/sll/genome-cattle/ARS-UCD1.2/GCF_002263795.1_ARS-UCD1.2_genomic.fna"   #Reference genome fa file, change as you want
Winsizelink="/home/sll/miniconda3/CNVcaller/Btau5.0.1_800_link"                          #dup file that you have created use blasr, change as you want
winsize=800

export PYTHONPATH="/home/sll/miniconda3/lib/python3.9/site-packages:$PYTHONPATH"          #Python3 path you set
echo "CNVReferenceDB.pl:    $CNVReferenceDB.pl";
echo "genomic.fna:    $genomic.fna";
echo "Individual.Process.sh:    $Individual.Process.sh";
echo "winsize_link:    $Btau5.0.1_800_link";
echo "CNV.Discovery.sh:    $CNV.Discovery.sh";
echo "Genotype.py:    $Genotype.py";
echo "Winsize:    $winsize"

# Create a window file for the genome (you can use it directly later)
perl $CNVReferenceDBpl $genomicfna -w $winsize

# Calculate the absolute copy number  of each window
bam=`ls *bam|cut -d"." -f 1 | sort -u`
for i in $bam;
do 
    bash $IndividualProcesssh -b `pwd`/${bam}.sorted.addhead.markdup.bam -h $bam -d $Winsizelink -s none;
done    

cp referenceDB.${winsize} RD_normalized
cd RD_normalized
ls -R `pwd`/*sex_1 > list.txt
touch exclude_list

# Determin the CNV region
bash $CNVDiscoverysh -l `pwd`/list.txt -e `pwd`/exclude_list -f 0.1 -h 1 -r 0.1 -p primaryCNVR -m mergeCNVR

# Genotype determination
python $Genotypepy --cnvfile mergeCNVR --outprefix genotypeCNVR --nproc 8
echo "Congratulation!CNVCaller has finished now!"
