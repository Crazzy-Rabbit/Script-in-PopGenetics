#! /bin/bash 
####################### Creat Dup file to CNVCaller #############
# Run this program in the directory that cotain the reference genome 
# 400 in this script is windowsize that you want to set in dup file, change as you want in step 1 and 3


# Set up the file name(obtain the absolute paths), software
0.1.Kmer_Generate.py="/home/sll/miniconda3/CNVcaller/bin/0.1.Kmer_Generate.py"                #change as you want
genomic.fna="/home/sll/genome-cattle/ARS-UCD1.2/GCF_002263795.1_ARS-UCD1.2_genomic.fna"       #change as you want
sawritermc="/home/sll/software/blasr-master/alignment/bin/sawritermc"                         #change as you want
blasr="/home/sll/miniconda3/bin.blasr"                                                        #change as you want
0.2.Kmer_Link.py="/home/sll/miniconda3/CNVcaller/bin/0.2.Kmer_Link.py"                        #change as you want

# 1 Split genome into short kmer sequences
python 0.1.Kmer_Generate.py genomic.fna 400 kmer.fa

# <FAFILE>      Reference sequence in FASTA format
# <WINSIZE>     The size of the window to use for CNV calling
# <OUTFILE>     Output kmer file in FASTA format


# 2 Align the kmer FASTA (from step 1) to reference genome using blasr.

# 1) creat .sa file use sawriter
sawritermc genomic.fna.sa genomic.fna
# 2) blasr 
blasr kmer.fa genomic.fna --sa genomic.fna.sa \
                          --out kmer.aln -m 5 --noSplitSubreads --minMatch 15 --maxMatch 20 \
                          --advanceHalf --advanceExactMatches 10 --fastMaxInterval \
                          --fastSDP --aggressiveIntervalCut --bestn 10

# 3 Generate duplicated window record file

python 0.2.Kmer_Link.py kmer.aln 400 Bos_ARS1.2_window.link

# <BLASR>       blasr results (-m 5 format)
# <WINSIZE>     The size of the window to use for CNV calling
# <OUTFILE>     Output genome duplicated window record file





