#! /bin/bash
# @Author: Lulu Shi
# @Mails: crazzy_rabbit@163.com
# Calculate xpclr 

vcftools="/home/sll/miniconda3/bin/vcftools"
xpclr="/home/sll/miniconda3/bin/xpclr"

function usage() {
    echo "Usage: bash $0 --vcf <vcf> --ref <ref> --tag <tag> --win <winsize> --step <step> --out <outprefix>"
    echo "所有文件请都别加路径，放到你的工作目录运行"
    echo "required options"
      echo "-v|--vcf     vcf file"
      echo "-r|--ref     ref sample list per row per ID"
      echo "-t|--tag     tag sample list per row per ID"
      echo "-w|--win     winsize for xpclr, default 50000"
      echo "-s|--step    step size for xpclr, default 50000"
      echo "-c|--chr     最大的染色体号，这个决定你vcf文件分成几个（很最重要！！）"
      echo "-o|--out     输出文件前缀"
      exit 1;
}

vcf=""
ref=""
tag=""
win="50000"
step="50000"
chr=""
out=""

while [[ $# -gt 0 ]]
do
  case "$1" in
    -v|--vcf )
        vcf=$2 ; shift 2 ;;
    -r|--ref )
        ref=$2 ; shift 2 ;;
    -t|--tag )
        tag=$2 ; shift 2 ;;
    -w|--win )
        win=$2 ; shift 2 ;;
    -s|--step )
        step=$2 ; shift 2 ;;
    -c|--chr )
        chr=$2 ; shift 2 ;;
    -o|--out )
        out=$2 ; shift 2 ;;
    *) echo "输入参数不对哦!" ;
        usage
        shift
        ;;
  esac
done

if [ -z $vcf ] || [ -z $ref ] || [ -z $tag ] || [ -z $out ]; then
    echo "检查下这些参数指定没有 --vcf and --ref and --tag and --out ！" >&2
    usage
fi
        
function main {
mkdir XP-CLR.progress
for ((k=1; k<=$chr; k++));
do
$vcftools --vcf $vcf --recode --recode-INFO-all  --chr ${k} --out ./XP-CLR.progress/${out}.chr${k}        
#calculate map distance                
$vcftools --vcf ./XP-CLR.progress/${out}.chr${k}.recode.vcf --plink --out ./XP-CLR.progress/chr${k}.MT
awk 'BEGIN{OFS=" "} {print 1,".",$4/1000000,$4}' ./XP-CLR.progress/chr${k}.MT.map > ./XP-CLR.progress/chr${k}.MT.map.distance
done 

cd XP-CLR.progress
for ((k=1; k<=$chr; k++));
do
# xpclr
xpclr --out ./chr${k} --format vcf --input ${out}.chr${k}.recode.vcf --samplesA ../$ref --samplesB ../$tag --map chr${k}.MT.map.distance --chr ${k} --gdistkey None --phased --size $win --step $step
# merge
awk  '{print $2,$3,$4,$12,$13}'   chr${k} > Chr${k}.${out}
done

cat ./*.${out} > ../${out}.xpclr
}
main
