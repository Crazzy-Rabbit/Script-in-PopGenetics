usage() {
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
OPT=`getopt -o v:1:2:w:s:n:o: --long vcf:,pop1:,pop2:,win:,step:,navr:,out: -- "$@"`
if [ $? != 0 ]; then usage; exit 1; fi
eval set -- "OPTS"
while [[ $# -gt 0 ]]
do
  key="$1"
  case "$key" in
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
       shift     
       ;;
  esac
done

vcftools --vcf $vcf --window-pi $win --window-pi-step $step --keep ${pop1}.txt --out $pop1
vcftools --vcf $vcf --window-pi $win --window-pi-step $step --keep ${pop2}.txt --out $pop2

source /home/sll/miniconda3/bin/activate
python ln_ratio.py --group1 ${pop1}.windowed.pi --group2 ${pop2}.windowed.pi --nvars $nvar --outprefix $out
