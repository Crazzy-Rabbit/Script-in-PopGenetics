## 1、run phaser
```
python ~/software/phaser/phaser.py --vcf NA06986.vcf.gz --bam NA06986.2.M_111215_4.bam --paired_end 1 --mapq 255 --baseq 10 --sample NA06986 --blacklist hg19_hla.bed --haplo_count_blacklist hg19_haplo_count_blacklist.bed --threads 4 --o phaser_test_case
#######################################################################
–vcf NA06986.vcf.gz – VCF containing genotype calls for the sample.
–bam NA06986.2.M_111215_4.bam – BAM containing RNA-seq reads.
–paired_end 1 – specifying that the reads come from a paired end experiment.
–mapq 255 – minimum mapping quality of reads to use for phasing and ASE. This should be set to a value that will ensure reads are uniquely mapped. When STAR is used this number is 255, however it will differ based on the aligner.
–baseq 10 – minimum base quality at the heterozygous SNP for a read to be used.
–sample NA06986 – name of the sample in the VCF file.
–blacklist hg19_hla.bed – list of sites to blacklist from phasing. The file we are providing contains all HLA genes.
–haplo_count_blacklist hg19_haplo_count_blacklist.bed – list of sites to blacklist when generating allelic counts. These are sites that we have previously identified as having mapping bias, so excluding them will improve results.
–threads 4 – number of threads to use.
–o phaser_test_case – output file prefix.
#######################################################################
```
## 2、Generate haplotype expression quantifications
```
python ~/software/phaser/phaser_gene_ae/phaser_gene_ae.py --haplotypic_counts phaser_test_case.haplotypic_counts.txt --features gencode.v19.GRCh37.genes.bed --o phaser_test_case_gene_ae.txt

#######################################################################
–haplotypic_counts phaser_test_case.haplotypic_counts.txt – this is one of the output files from phASER. It contains read counts for all haplotype blocks as well as individual SNPs and their phasing relative to one another.
–gencode.v19.GRCh37.genes.bed– contains the coordinates for all the genes we would like to calculate haplotypic expression for. It is very important that the chromosome naming be consistent between this file, the VCF and the BAM.
–o phaser_test_case_gene_ae.txt – name of output file.
–no_gw_phase 0 – this option can be turned on (by setting to 1) if the input VCF that was used was not previously phased. If you can, I highly suggest phasing the input VCF using e.g. population phasing as previously mentioned, however in some cases this may not be possible. For example,  if you are working with a model organism and lack trio data.
#######################################################################
```
## 3、each column in the output file
```
contig – Gene chromosome.
start – Gene start (0 based).
stop – Gene stop (0 based).
name – Gene name.
aCount – Total allelic count for haplotype A.
bCount – Total allelic count for haplotype B.
totalCount – Total allelic coverage of this feature (aCount + bCount).
log2_aFC – Effect size for the allelic imbalance reported as allelic fold change (log2(aCount/bCount)) defined in our paper.
n_variants – Number of variants with allelic data in this feature.
variants – List of variants with allelic data in this feature (contig_position_ref_alt).
```

