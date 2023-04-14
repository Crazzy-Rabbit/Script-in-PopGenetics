gatk="/home/software/gatk-4.1.4.0/gatk"
fa="/home/sheep-reference/GCF_002742125.1_Oar_rambouillet_v1.0_genomic.fna"

 ls *markdup.bam | cut -d"." -f 1 | sort -u  | while read id;
do

# 3. SplitNCigarReads：将落在外显子上的reads分离出来
 ## 取出N错误碱基，去除内含子区域的reads。这一步太慢了，占用整个流程一半以上运行时间
  $gatk SplitNCigarReads -R $fa \
                         -I ${id}.sorted.addhead.markdup.bam \
                         -O ${id}.sorted.addhead.markdup.split.bam


  # 4. HaplotypeCaller
  $gatk HaplotypeCaller -R $fa \
                        --output-mode EMIT_ALL_CONFIDENT_SITES -ERC GVCF \
                        --dont-use-soft-clipped-bases \
                        -stand-call-conf 20 \
                        --max-mnp-distance 0 \                         # 合并过程报错，可能是因为产生了MNP，用这个不让他产生
                        -I ${id}.sorted.addhead.markdup.split.bam \
                        -O ${id}.gvcf.gz
done