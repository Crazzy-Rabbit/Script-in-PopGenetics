#! /bin/bash
# 进行QC和LD过滤的命令行
#! /bin/bash
# 进行QC和LD过滤的命令行
function usage() {
    echo "Usage: bash $0 --bfile <bfile> --chr <chr> --geno <geno> --maf <maf> --win <winsize> --step <step> --rr <R2>"
    echo "required options"
      echo "-b|--bfile       二进制plink格式文件的前缀"
      echo "-c|--chr         物种染色体条数"
      echo "-g|--geno        缺失率大于这个值的过滤，默认为0.05"
      echo "-m|--maf         maf小于这个值的过滤，默认为0.03"
      echo "-w|--win         窗口大小，单位为Kb，默认为50"
      echo "-s|--step        步长大小，单位为Kb，默认为25"
      echo "-r|--rr          R2阈值， 默认为0.2"
      exit 1;
}

# Set default values:
bfile=""
chr=""
geno="0.05"
maf="0.03"
win="50"
step="25"
rr="0.2"

# 解析命令行参数
while [[ $# -gt 0 ]];
do
  case "$1" in
    -b|--bfile )
        bfile=$2 ; shift 2 ;;
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
    *) echo "Unknown option: $1" >&2
       usage ;;
  esac
done 

if [ -z "$bfile" ] || [ -z "$chr" ]; then
    echo "OPtion --bfile and --chr must be specified." >$2
    usage
fi

function main () {
# 过滤geno和maf
plink --allow-extra-chr --chr-set $chr \
      -bfile $bfile \
      --geno $geno --maf $maf \
      --make-bed --out QC.${bfile}

# 过滤LD
# 转为map、ped格式
plink --allow-extra-chr --chr-set $chr \
      -bfile QC.$bfile \
      --recode \
      --out QC.${bfile}
# 填充map文件第二列，
awk -F '\t' '{print $1"\t"$1":"$4"\t"$3"\t"$4}' QC.${bfile}.map > QC.${bfile}.correction.map

# 删除原来的map文件, 将生成的map文件改为原来的map文件名称
rm QC.${bfile}.map

mv QC.${bfile}.correction.map QC.${bfile}.map

#转为二进制格式
plink --allow-extra-chr --chr-set $chr \
      --file QC.${bfile} \
      --make-bed \
      --out QC.${bfile}
#进行LD过滤
plink --allow-extra-chr --chr-set $chr \
      -bfile QC.${bfile}  \
      --indep-pairwise $win $step $rr \
      --out QC.ld.${bfile}-502502

plink --allow-extra-chr --chr-set $chr \
      -bfile QC.${bfile} \
      --extract QC.ld.${bfile}-502502.prune.in \
      --make-bed \
      --out QC.ld.${bfile}-502502
}
main
