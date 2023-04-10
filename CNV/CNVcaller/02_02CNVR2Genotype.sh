# Set up the file name(obtain the absolute paths), software                                             

CNVDiscoverysh="/home/sll/miniconda3/CNVcaller/CNV.Discovery.sh"                         #change as you want
Genotypepy="/home/sll/miniconda3/CNVcaller/Genotype.py"                                  #change as you want
python="/home/sll/miniconda3/bin/python3.9"


cp referenceDB.${winsize} RD_normalized
cd RD_normalized
ls -R `pwd`/*sex_1 > list.txt
touch exclude_list

# Determin the CNV region
bash $CNVDiscoverysh -l `pwd`/list.txt -e `pwd`/exclude_list -f 0.1 -h 1 -r 0.1 -p primaryCNVR -m mergeCNVR

# Genotype determination
$python $Genotypepy --cnvfile mergeCNVR --outprefix genotypeCNVR --nproc 8
echo "Congratulation!CNVCaller has finished now!"
