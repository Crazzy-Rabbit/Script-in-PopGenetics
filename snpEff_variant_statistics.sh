#!/bin/bash

vcf="QC.sample126.chart.filter-geno005-maf003.NC.anno.vcf"

grep -v "#" $vcf | awk '{print $1"\t"$2"\t"$4"\t"$5}' > snpEff1
grep -v "#" $vcf | awk '{print $8}' |awk -F"ANN=" '{print $2}' | awk -F"|" '{print $2"\t"$3"\t"$11}' > snpEff2
paste -d "\t" snpEff1 snpEff2 > positive.snpEff
rm snpEff1 snpEff2

prime_UTR_variant3=`grep -o 3_prime_UTR_variant positive.snpEff | wc -l`
echo "3_prime_UTR_variant: $prime_UTR_variant3"

prime_UTR_premature_start_codon_gain_variant5=`grep -o 5_prime_UTR_premature_start_codon_gain_variant positive.snpEff | wc -l`
echo "5_prime_UTR_premature_start_codon_gain_variant: $prime_UTR_premature_start_codon_gain_variant5"

prime_UTR_variant5=`grep -o 5_prime_UTR_variant positive.snpEff | wc -l`
echo "5_prime_UTR_variant: $prime_UTR_variant5"

downstream_gene_variant=`grep -o downstream_gene_variant positive.snpEff | wc -l`
echo "downstream_gene_variant: $downstream_gene_variant"

initiator_codon_variant=`grep -o initiator_codon_variant positive.snpEff | wc -l`
echo "initiator_codon_variant: $initiator_codon_variant"

intergenic_region=`grep -o intergenic_region positive.snpEff | wc -l`
echo "intergenic_region: $intergenic_region"

intragenic_variant=`grep -o intragenic_variant positive.snpEff | wc -l`
echo "intragenic_variant: $intragenic_variant"

intron_variant=`grep -o intron_variant positive.snpEff | wc -l`
echo "intron_variant: $intron_variant"

missense_variant=`grep -o missense_variant positive.snpEff | wc -l`
echo "missense_variant: $missense_variant"

non_coding_transcript_exon_variant=`grep -o non_coding_transcript_exon_variant positive.snpEff | wc -l`
echo "non_coding_transcript_exon_variant: $non_coding_transcript_exon_variant"

splice_acceptor_variant=`grep -o splice_acceptor_variant positive.snpEff | wc -l`
echo "splice_acceptor_variant: $splice_acceptor_variant"

splice_donor_variant=`grep -o splice_donor_variant positive.snpEff | wc -l`
echo "splice_donor_variant: $splice_donor_variant"

splice_region_variant=`grep -o splice_region_variant positive.snpEff | wc -l`
echo "splice_region_variant: $splice_region_variant"

start_lost=`grep -o start_lost positive.snpEff | wc -l`
echo "start_lost: $start_lost"
start_retained_variant=`grep -o start_retained_variant positive.snpEff | wc -l`
echo "start_retained_variant: $start_retained_variant"

stop_gained=`grep -o stop_gained positive.snpEff | wc -l`
echo "stop_gained: $stop_gained"

stop_lost=`grep -o stop_lost positive.snpEff | wc -l`
echo "stop_lost: $stop_lost"

stop_retained_variant=`grep -o stop_retained_variant positive.snpEff | wc -l`
echo "stop_retained_variant: $stop_retained_variant"

synonymous_variant=`grep -o synonymous_variant positive.snpEff | wc -l`
echo "synonymous_variant: $synonymous_variant"

upstream_gene_variant=`grep -o upstream_gene_variant positive.snpEff | wc -l`
echo "upstream_gene_variant: $upstream_gene_variant"