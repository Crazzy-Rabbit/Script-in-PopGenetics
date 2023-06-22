#! /bin/bash

########################################################
# 进行geno maf 及 LD过滤，有默认参数
# 输入文件可以为vcf，也可以为bed等plink二进制文件，全名
# 需要指定物种的染色体条数，用于Plink中的all extra chr
# 对重测序数据SNP ID那列为'.',进行填充，因为会影响LD过滤的点
# 输出结果前缀为QC.67_admix-geno005-maf003-ld502502，其中
# QC.67_admix-geno005-maf003为设置的out，因此，如果ld过滤条件
# 不是50 25 02 则记得修改结果文件名称，免得记错过滤条件
# @Author: Lulu Shi
# @Email: crazzy_rabbit@163.com
########################################################
function usage() {
    echo "Usage: bash $0 --file <file> --chr <chr> --geno <geno> --maf <maf> --win <winsize> --step <step> --rr <R2> --out <outprefix>"
    echo "required options"
      echo "-f|--file        vcf file or bed or bim or fam file（全名）"
      echo "-c|--chr         num of chr"
      echo "-g|--geno        geno，default 0.05"
      echo "-m|--maf         maf，default 0.03"
      echo "-w|--win         winsize，单位为Kb，default 50"
      echo "-s|--step        stepsize，单位为Kb，default 25"
      echo "-r|--rr          R2阈值， default 0.2"
      echo "-o|--out         QC后输出文件前缀,如QC.geno005-maf003"
      exit 1;
}

# Set default values:
file=""
chr=""
geno="0.05"
maf="0.03"
win="50"
step="25"
rr="0.2"
out=""

while [[ $# -gt 0 ]];
do
  case "$1" in
    -|--file )
        file=$2 ; shift 2 ;;
    -c|--chr )
        chr=$2 ; shift 2 ;;
    -g|--geno )
        geno=$2 ; shift 2 ;;
    -m|--maf )
        maf=$2 ; shift 2 ;;
    -w|--win )
        win=$2 ; shift 2 ;;
    -s|--step )
        step=$2 ; shift 2 ;;
    -r|--rr )
        rr=$2 ; shift 2 ;;
    -o|--out )
        out=$2 ; shift 2 ;;
    *) echo "Unknown option: $1" >&2
       usage ;;
  esac
done 

if [ -z "$file" ] || [ -z "$chr" ] || [ -z "$out" ]; then
    echo "OPtion --file and --chr --out must be specified." >$2
    usage
fi


# use 'cut' split filename, specify prefix after geno and maf
pre=$(echo $file | cut -d "." -f -1)

# Check if the input file is vcf file, if it is, convert the format
if [[ "${file##*.}" = "vcf" ]]; then
  plink --allow-extra-chr --chr-set $chr -vcf $file --make-bed --double-id --out $pre
fi

function main() {
# geno and maf filter
plink --allow-extra-chr --chr-set $chr -bfile $pre --geno $geno --maf $maf --make-bed --out $out

# LD filter
# convert to map ped
plink --allow-extra-chr --chr-set $chr -bfile $out --recode --out $out
# Fill the second column of map file
awk -F '\t' '{print $1"\t"$1":"$4"\t"$3"\t"$4}' $out.map > $out.correction.map
# change the name of the generated map file to the original map file
rm $out.map
mv $out.correction.map $out.map
# convert to bed bim fam
plink --allow-extra-chr --chr-set $chr --file $out --make-bed --out $out

# do LD filter
plink --allow-extra-chr --chr-set $chr -bfile $out  --indep-pairwise $win $step $rr --out $out-ld502502
plink --allow-extra-chr --chr-set $chr -bfile $out --extract $out-ld502502.prune.in --make-bed --out $out-ld502502
}
main
