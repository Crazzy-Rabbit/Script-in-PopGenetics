IndividualProcess="/home/sll/miniconda3/CNVcaller/Individual.Process.sh"               #change as you want
Winlink="/home/sll/genome-cattle/CNVCaller-Duplink/ARS_UCD1.2-refenenceDB.1000"        #dup file that you have created use blasr, change as you want

# Calculate the absolute copy number  of each window
ls *markdup.bam|cut -d"." -f 1 | sort -u | while read id;
do
    bash $IndividualProcess -b `pwd`/${id}.sorted.addhead.markdup.bam -h $id -d $Winlink -s none;
done 
