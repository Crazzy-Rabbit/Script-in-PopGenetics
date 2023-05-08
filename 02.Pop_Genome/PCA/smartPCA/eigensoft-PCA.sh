#! /bin/bash

convertf="/home/sll/miniconda3/bin/convertf"
smartpca="/home/sll/miniconda3/bin/smartpca"

function usage() {
    echo "用eigensoft软件中的smartpca做pca分析，输入文件为map、ped文件前缀"
    echo "用法  bash $0 --file <plink> --pca <pca> --out <outprefix>"
    echo "required options!"
      echo "-F|--file     plink格式map、ped文件的前缀"
      echo "-p|--pca      pc数，默认为3"
      echo "-o|--out      输出文件前缀"
    exit 1;
}
file=""
pca="3"
out=""
while [[ $# -gt 0 ]]
do
  case "$1" in 
    -F|--file )
      file=$2; shift 2 ;;
    -p|--pca )
      pca=$2; shift 2 ;;
    -o|--out )
      out=$2; shift 2 ;;
    *) echo "unknow option!" >&2     
       usage
       shift
       ;;
  esac
done

if [ -z $file ] | [ -z $out ]; then
    echo "未输入参数" >&2
    usage
fi

function main() { 
# 转格式
cat > transfer.conf <<EOF
genotypename:    $file.ped
snpname:         $file.map # or example.map, either works
indivname:       $file.ped # or example.ped, either works
outputformat:    EIGENSTRAT
genotypeoutname: $out.eigenstratgeno
snpoutname:      $out.snp
indivoutname:    $out.ind
familynames:    NO
EOF

$convertf -p transfer.conf

# PCA
cat > runningpca.conf <<EOF
genotypename: $out.geno
snpname: $out.snp
indivname: $out.ind
evecoutname: $out.pca.evec
evaloutname: $out.eval
altnormstyle: NO
numoutlieriter:  0
nsnpldregress:   0
numoutevec: $pca
EOF

$smartpca -p runningpca.conf
}
main
