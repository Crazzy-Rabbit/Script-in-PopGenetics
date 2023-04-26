#! /bin/bash
#################### Hard filter for SNP ######################

# Set up the file name, software
GATK="/home/software/gatk-4.1.4.0/gatk"                #change as you want
bcftools="/home/sll/miniconda3/bin/bcftools"           #change as you want

function usage() {
    echo "Usage: bash $0 --vcf <vcf.gz file> --out <outprefix>"
    echo "对SNP进行硬过滤及去除多等位基因"
    echo "最后会输出.snps.filter.pass.2allell.vcf文件"
    echo "required options"
      echo "-v|--vcf         做完基因分型的vcf.gz文件"
      echo "-o|--out         输出文件前缀"
      exit 1;
}

while [[ $# -gt 0 ]]
do
  case "$1" in
    -v|--vcf )
        vcf=$2 ; shift2 ;;
    -o|--out )
        out=$2 ; shift2 ;;
    *) echo "输入的参数不对的喔！" >&2
       usage
       shift
       ;;
  esac
done

if [ -z $vcf ] || [ -z $out ]; then 
    echo "关键参数没输喔！" >&2
    usage
fi

function main() {
## get SNP
$GATK SelectVariants  --select-type  SNP  \
                      -V $vcf  \
                      -O ${out}.snps.vcf.gz

## filter SNP
$GATK VariantFiltration -V ${out}.snps.vcf.gz \
                        --filter-expression "QD < 2.0 || FS > 60.0 || MQ < 40.0 || SOR > 3.0 || MQRankSum < -12.5 || ReadPosRankSum < -8.0" \
                        --filter-name "SNP_FILTER" \
                        -O ${out}.snps.filter.vcf.gz

# index
$bcftools index -t ${out}.snps.filter.vcf.gz

## get pass 
$GATK  SelectVariants -V ${out}.snps.filter.vcf.gz \
                      -O ${out}.snps.filter.pass.vcf.gz \
                      -select "vc.isNotFiltered()"

# delect muitl allells
$bcftools view -m 2 -M 2 \
               --type "snps"  ${out}.snps.filter.pass.vcf.gz \
               -Ov -o ${out}.snps.filter.pass.2allell.vcf
}
main
