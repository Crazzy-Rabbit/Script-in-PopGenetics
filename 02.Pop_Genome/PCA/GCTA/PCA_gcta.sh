#! /bin/bash
# PCA
gcta="/home/software/gcta_1.92.3beta3/gcta64"
function usage() {
    echo "GCTA软件做PCA分析，输入文件为bed、bim、fam文件前缀，数字染色体"
    echo "Usage: bash $0 --bfile <bfile> --autosome <chrosome> --pca <pc> --out <outperfix>"
    echo "required options"
      echo "-b|--bfile     bfile文件前缀"
      echo "-a|--autosome  常染色体数量，默认为 29"
      echo "-p|--pca       计算的pc个数， 默认为 4"
      echo "-o|--out       输出文件前缀"
    exit 1;
}

bfile=""
autosome="29"
pca="4"
out=""

while [[ $# -gt 0 ]]
do 
  case "$1" in
    -b|--bfile )
      bfile=$2 ; shift 2 ;;
    -a|--autosome )
      autosome=$2 ; shift 2 ;;
    -p|--pca )
      pca=$2 ; shift 2 ;;
    -o|--out )
      out=$2 ; shift 2 ;;
    *) echo "没有这个参数！" >&2
      usage
      shift
      ;;
  esac
done

if [ -z $bfile ] || [ -z $out ]; then 
    echo "输入和输出文件未指定！" >&2
    usage
fi

function main() {
## make germ
$gcta --bfile $bfile \
      --make-grm --autosome-num $autosome \
      --out ${out}.gcta
                                       
## PCA
$gcta --grm ${out}.gcta \
      --pca $pca \
      --out ${out}.gcta.out
}
main
