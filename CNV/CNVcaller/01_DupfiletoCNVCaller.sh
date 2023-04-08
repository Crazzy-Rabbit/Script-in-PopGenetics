#! /bin/bash 
####################### Creat Dup file to CNVCaller #############
# Run this program in the directory that cotain the reference genome 
# 400 in this script is windowsize that you want to set in dup file, change as you want in step 1 and 3


# Set up the file name(obtain the absolute paths), software and winsize 
KmerGeneratepy="/home/sll/miniconda3/CNVcaller/bin/0.1.Kmer_Generate.py"                      #change as you want
genomicfa="/home/sll/genome-cattle/ARS-UCD1.2/GCF_002263795.1_ARS-UCD1.2_genomic.fna"         #change as you want
sawriter="/home/sll/software/blasr/alignment/SAWriter"                                        #change as you want
blasr="/home/sll/software/blasr/alignment/Blasr"                                              #change as you want
KmerLinkpy="/home/sll/miniconda3/CNVcaller/bin/0.2.Kmer_Link.py"                              #change as you want
species="Deer"                                                                                #change as you want
winsize=1000                                                                                  #change as you want
# 1 Split genome into short kmer sequences
python $KmerGeneratepy $genomicfna $winsize kmer.fa

# <FAFILE>      Reference sequence in FASTA format
# <WINSIZE>     The size of the window to use for CNV calling
# <OUTFILE>     Output kmer file in FASTA format

# 2 Align the kmer FASTA (from step 1) to reference genome using blasr.
# 1) creat .sa file use sawriter
$sawriter genomic.fna.sa $genomicfna
# 2) blasr 
$blasr kmer.fa $genomicfna --sa genomic.fna.sa \
                            --out kmer.aln -m 5 --noSplitSubreads --minMatch 15 --maxMatch 20 \
                            --advanceHalf --advanceExactMatches 10 --fastMaxInterval \
                            --fastSDP --aggressiveIntervalCut --bestn 10

# 3 Generate duplicated window record file
python $KmerLinkpy kmer.aln $winsize ${species}.refenenceDB.${winsize}.link

# <BLASR>       blasr results (-m 5 format)
# <WINSIZE>     The size of the window to use for CNV calling
# <OUTFILE>     Output genome duplicated window record file





