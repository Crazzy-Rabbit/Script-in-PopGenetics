#! /bin/bash
# iHS
vcftools="/home/sll/miniconda3/bin/vcftools"
selscan="/home/software/selscan/bin/linux/selscan"
norm="/home/software/selscan/bin/linux/norm"

function usage() {
    echo "从beagle 一直到最后标准化合并染色体，然后排序的过程"
    echo "Usage: bash $0 --vcf <vcf> --win <winsize> --step <stepsize> --thread <thread> --out <outprefix>"
    echo "required options"
      echo "-v|--vcf     bgvcf file after beagle"
      echo "-w|--win     winsize in iHS, default 50000"
      echo "-s|--step    step in iHS, default 50000"
      echo "-T|--thread  thread for selscan, default 10"
      echo "-c|--chr     最大染色体号，决定vcf文件分成多少个染色体文件"
      echo "-o|--out     输出文件前缀"
      exit 1;
 }
 
 vcf=""
 win="50000"
 step="50000"
 thread="10"
 chr=""
 out=""
 
 while [[ $# -gt 0 ]]
 do 
   case "$1" in 
     -v|--vcf )
       vcf=$2 ; shift 2 ;;
     -w|--win )
       win=$2 ; shift 2 ;;
     -s|--step )
       step=$2 ; shift 2 ;;
     -T|--thread )
       thread=$2 ; shift 2 ;;
     -c|--chr )
       chr=$2 ; shift 2 ;;
     -o|--out )
       out=$2 ; shift 2 ;;
     *) echo "输入参数不对哦！"
        usage
        shift
        ;;
    esac
done

if [ -z $vcf ] || [ -z $out ]; then 
    echo "检查这些参数是否指定 --vcf --out ！" >&2
    usage
fi

function main() {
mkdir iHS.progress
for ((i=1; i<=$chr; i++));
do 
# calculate map distance
$vcftools --gzvcf $vcf --recode --recode-INFO-all --chr ${i} -out ./iHS.progress/${vcf}.chr${i}
$vcftools --vcf ./iHS.progress/${vcf}.chr${i}.recode.vcf --plink --out ./iHS.progress/chr${i}.MT          
awk 'BEGIN{OFS=" "} {print 1,".",$4/1000000,$4}' ./iHS.progress/chr${i}.MT.map > ./iHS.progress/chr${i}.MT.map.distance
done 

cd iHS.progress
for ((i=1; i<=$chr; i++));
do
# iHS
$selscan --ihs --vcf ${vcf}.chr${i}.recode.vcf --map chr${i}.MT.map.distance --threads $thread --out  Chr${i}
# add win and norm 
$norm --ihs --files  Chr${i}.ihs.out  --bp-win --winsize $win
# add win and step
python ../iHS_Win_step.py --file Chr${i}.ihs.out.100bins.norm --chr $i --window $win --step $step
done

cat {1.."$chr"}.iHS > ../${output}.XPEHH
}
main
