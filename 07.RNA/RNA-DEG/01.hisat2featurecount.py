#! usr/bin/python
##################################
### python methon for muti process
### fastp filter
### hisat2 align 
### samtools sort and index
### featurecount stat reads count
### mutiqc stat information
### max process = 4
##################################
import os
import subprocess
# muti process
from concurrent.futures import ThreadPoolExecutor

# set dir that save sam and bam file
##################################    
genomefa = "/home/ysq/20221108-deer-depth/20231007-deer-sift-data/reddeer-ref-mCerEla1.1/GCF_910594005.1_mCerEla1.1_genomic"
genomegtf = "/home/ysq/20221108-deer-depth/20231007-deer-sift-data/reddeer-ref-mCerEla1.1/GCF_910594005.1_mCerEla1.1_genomic.gtf"
##################################

def process_sample(sample):
    fq1_file = os.path.join(fq_dir, f"{sample}_1.filter.fq.gz")
    fq2_file = os.path.join(fq_dir, f"{sample}_2.filter.fq.gz")
    sam_file = os.path.join(sam_dir, f"{sample}.hismap.sam")
    bam_file = os.path.join(bam_dir, f"{sample}_sort.bam")
    index_file = os.path.join(bam_dir, f"{sample}_sort.bam.index")

    # if there are fq1_file and fq2_file
    if os.path.isfile(fq1_file) and os.path.isfile(fq2_file):
        # align use hisat2
        subprocess.run([hisat2, "-p", "8", "-x", genomefa, "-1", fq1_file, "-2", fq2_file, "-S", sam_file])
        # sort sam file
        subprocess.run([samtools, "sort", "-@", "8", "-O", "bam", "-o", bam_file, sam_file])
        # index bam file
        subprocess.run([samtools, "index", bam_file, index_file]) 
    else:
        print("Please provide the filter.fq.gz file")
        
def filter_sample(sample):
    f1_file = os.path.join(fq_dir, f"{sample}_1.clean.fq.gz")
    f2_file = os.path.join(fq_dir, f"{sample}_2.clean.fq.gz")
    fq1_file = os.path.join(fq_dir, f"{sample}_1.filter.fq.gz")
    fq2_file = os.path.join(fq_dir, f"{sample}_2.filter.fq.gz")
    html = os.path.join(fq_dir, f"{sample}.fastp.html")

    if os.path.isfile(f1_file) and os.path.isfile(f2_file):
        subprocess.run([fastp, "-i", f1, "-I", f2, "-g", "-q", "15", "-n", "5", "-l", "150", "-u", "50", "-o", fq1, "-O", fq2, "-h", html])

    else:
        print("Please provide the clean.fq.gz file")

# samples = [id for id in os.listdir(sam_dir) if id.startswith("ML")]
# samples = subprocess.check_output("ls ML*/ML* | cut -d/ -f1 | uniq", shell=True).decode().splitlines()
samples = [id.split(".")[0] for id in os.listdir(sam_dir) if id.startswith("ML")]

os.makedirs("/hismap/sam/")
sam_dir = "/home/sll/5t_wgs_20230814_bam/20231118-deer-rna-seq/hismap/sam"
bam_dir = "/home/sll/5t_wgs_20230814_bam/20231118-deer-rna-seq/hismap" 
fq_dir = f"/home/sll/5t_wgs_20230814_bam/20231118-deer-rna-seq/{sample}"
# set max processes and run
MAX_PROCESSES = 4
with ThreadPoolExecutor(max_workers=MAX_PROCESSES) as executor:
    executor.map(filter_sample, samples) 

with ThreadPoolExecutor(max_workers=MAX_PROCESSES) as executor:
    executor.map(process_sample, samples) 

# run featurecount and multiQC after all file index
os.system("mkdir /home/sll/5t_wgs_20230814_bam/20231118-deer-rna-seq/hismap/counts")
os.system(f"featureCounts -p -t exon -g gene_id -M -T 8 -a $genomegtf -o ./hismap/counts/all.featurecounts.txt *_sort.bam")
os.system(f"multiqc ./hismap/counts/all.featurecounts.txt.summary -o  ./hismap/counts/all.counts.summary")
