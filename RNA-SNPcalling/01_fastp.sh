ls *fastq.gz | cut -d"_" -f 1 |sort -u | while read id;
do 
  fastp -i ${id}_1.fastq.gz \
        -I ${id}_2.fastq.gz \
        -g -q 15 -n 5 -l 15 \
        -o ${id}_1.filter.fastq.gz \
        -O ${id}_2.filter.fastq.gz \
        -h ${id}.fastp.html
done
