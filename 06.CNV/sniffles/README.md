#### sniffles: SV calling for a population 
##### 1.Obtain calls for each of the samples
```
~/sniffles -m my_sample.bam -v my_sample.vcf
```
##### 2.Merge all the vcf files across all samples
```
ls *.vcf > vcf_files_raw_calls.txt

SURVIVOR merge vcf_files_raw_calls.txt 1000 1 1 -1 -1 -1 merged_SURVIVOR_1kbpdist_typesave.vcf
```
##### 3.genotyping each VCF (force calling)
```
~/sniffles -m sample.bam -v sample_gt.vcf --genotype -n -1 --Ivcf merged_SURVIVOR_1kbpdist_typesave.vcf

ls *sample_gt.vcf > vcf_files_gt_calls.txt
SURVIVOR merge vcf_files_gt_calls.txt 1000 -1 1 -1 -1 -1 merged_gt_SURVIVOR_1kbpdist_typesave.vcf
```
