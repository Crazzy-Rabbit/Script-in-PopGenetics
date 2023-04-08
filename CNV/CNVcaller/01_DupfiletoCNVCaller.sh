#! /bin/bash 
####################### Creat Dup file to CNVCaller #############
# Run this program in the directory that cotain the reference genome 
# 400 in this script is windowsize that you want to set in dup file, change as you want in step 1 and 3


# Set up the file name(obtain the absolute paths), software and winsize 
KmerGeneratepy="/home/sll/miniconda3/CNVcaller/bin/0.1.Kmer_Generate.py"                      #change as you want
genomicfa="/home/sll/software/snpEff/data/genomes/RedDeerv1.1.fa"                                           #change as you want
sawriter="/home/sll/software/blasr/alignment/bin/sawritermc"                                  #change as you want
blasr="/home/sll/miniconda3/bin/blasr"                                                                         #change as you want
KmerLinkpy="/home/sll/miniconda3/CNVcaller/bin/0.2.Kmer_Link.py"                              #change as you want

python="/home/sll/miniconda3/bin/python3.9"
winsize=1000



# 1 Split genome into short kmer sequences
$python $KmerGeneratepy $genomicfa $winsize kmer.fa


# 2 Align the kmer FASTA (from step 1) to reference genome using blasr.
# 1) creat .sa file use sawriter
$sawriter genomic.fa.sa $genomicfa
# 2) blasr 
$blasr kmer.fa $genomicfa   --sa genomic.fa.sa \
                            --out kmer.aln -m 5 --noSplitSubreads --minMatch 15 --maxMatch 20 \
                            --advanceHalf --advanceExactMatches 10 --fastMaxInterval \
                            --fastSDP --aggressiveIntervalCut --bestn 10

# 3 Generate duplicated window record file
$python $KmerLinkpy kmer.aln $winsize refenenceDB.${winsize}.link






