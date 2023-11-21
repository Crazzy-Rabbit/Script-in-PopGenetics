# 
python ~/software/phaser/phaser.py --vcf NA06986.vcf.gz --bam NA06986.2.M_111215_4.bam --paired_end 1 --mapq 255 --baseq 10 --sample NA06986 --blacklist hg19_hla.bed --haplo_count_blacklist hg19_haplo_count_blacklist.bed --threads 4 --o phaser_test_case


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
