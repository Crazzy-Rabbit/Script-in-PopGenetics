#! /bin/bash 
####################### Creat Dup file to CNVCaller #############
# Run this program in the directory that cotain the reference genome 
# 400 in this script is windowsize that you want to set in dup file, change as you want in step 1 and 3

# KmerGeneratepy="/home/sll/miniconda3/CNVcaller/bin/0.1.Kmer_Generate.py"                   
# genomicfa="/home/sll/software/snpEff/data/genomes/RedDeerv1.1.fa"                                       
# sawriter="/home/sll/software/blasr/alignment/bin/sawritermc"                                
# blasr="/home/sll/miniconda3/bin/blasr"                                                                       
# KmerLinkpy="/home/sll/miniconda3/CNVcaller/bin/0.2.Kmer_Link.py"                            
# python="/home/sll/miniconda3/bin/python3.9"
# winsize=1000



# 1 Split genome into short kmer sequences
/home/sll/miniconda3/bin/python3.9 /home/sll/miniconda3/CNVcaller/bin/0.1.Kmer_Generate.py /home/sll/software/snpEff/data/genomes/RedDeerv1.1.fa 1000 kmer.fa


# 2 Align the kmer FASTA (from step 1) to reference genome using blasr.
# 1) creat .sa file use sawriter
/home/sll/software/blasr/alignment/bin/sawritermc genomic.fa.sa /home/sll/software/snpEff/data/genomes/RedDeerv1.1.fa
# 2) blasr 
/home/sll/miniconda3/bin/blasr kmer.fa /home/sll/software/snpEff/data/genomes/RedDeerv1.1.fa   --sa genomic.fa.sa \
                            --out kmer.aln -m 5 --noSplitSubreads --minMatch 15 --maxMatch 20 \
                            --advanceHalf --advanceExactMatches 10 --fastMaxInterval \
                            --fastSDP --aggressiveIntervalCut --bestn 10

# 3 Generate duplicated window record file
/home/sll/miniconda3/bin/python3.9 /home/sll/miniconda3/CNVcaller/bin/0.2.Kmer_Link.py kmer.aln 1000 Deer-refenenceDB.1000.link





