#! /bin/bash

function usage() {
    echo "Usage: bash $0 --vcf <vcf> --pop1 <pop1> --pop2 <pop2> --win <winsize> --step <step> --navr <navrs> --out <outprefix>"
    echo "required options"
      echo "-v|--vcf       vcf file"
      echo "-1|--pop1      群体1 txt文本文件前缀，一行一个ID"
      echo "-2|--pop2      群体2 txt文本文件前缀，一行一个ID"
      echo "-w|--win       窗口大小"
      echo "-s|--step      步长大小"
      echo "-n|--navr      窗口内SNP数小于它则删除窗口，默认为20"
      echo "-o|--out       输出文件前缀"
      exit 1;
}

vcf=""
pop1=""
pop2=""
win="50000"
step="25000"
navr="20"
out=""

while [[ $# -gt 0 ]]
do
  case "$1" in
    -v|--vcf )
        vcf=$2 ; shift 2 ;;
    -1|--pop1 )
        pop1=$2 ; shift 2 ;;
    -2|--pop2 )
        pop2=$2 ; shift 2 ;;
    -w|--win )
        win=$2 ; shift 2 ;;
    -s|--step )
        step=$2 ; shift 2 ;;
    -n|--navr )
        navr=$2 ; shift 2 ;;
    -o|--out )
        out=$2 ; shift 2 ;;
    *) echo "Option error!";
       usage    
       ;;
  esac
done

if [ -z $vcf ] || [ -z $pop1 ] || [ -z $pop2 ] || [ -z $out]; then
    echo "Option --vcf and --pop1 and --pop2 and --out not specified" >&2
    usage
fi

vcftools --vcf $vcf --window-pi $win --window-pi-step $step --keep ${pop1}.txt --out $pop1
vcftools --vcf $vcf --window-pi $win --window-pi-step $step --keep ${pop2}.txt --out $pop2

source /home/sll/miniconda3/bin/activate
python ln_ratio.py --group1 ${pop1}.windowed.pi --group2 ${pop2}.windowed.pi --nvars $navr --outprefix $out
