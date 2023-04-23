#! /bin/bash
# 进行QC和LD过滤的命令行
usage() {
    echo "Usage: bash $0 --bfile <bfile> --chr <chr> --geno <geno> --maf <maf> --win <winsize> --step <step> --rr <R2>"
    echo "required options"
      echo "-b|--bfile       二进制plink格式文件的前缀"
      echo "-c|--chr         物种染色体条数"
      echo "-g|--geno        缺失率大于这个值的过滤，一般为0.05或0.1"
      echo "-m|--maf         最小等位基因频率小于这个值的过滤，一般为0.03"
      echo "-w|--win         窗口大小，单位为Kb"
      echo "-s|--step        步长大小，单位为Kb"
      echo "-r|--rr          R2阈值"
      exit 1;
}

# 解析命令行参数
OPT=`getopt -o b:c:g:m:w:s:r: --long bfile:,chr:,geno:,maf:,win:,step:,rr: -- "$@"`
if [ $? != 0 ]; then usage; exit 1; fi
eval set -- "OPTS"
while [[ $# -gt 0 ]]
do
  key="$1"
  case "$key" in
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
     *) echo "Option error!";
       usage
       shift     
       ;;
  esac
done

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
      --indep-pairwise $win $step $r \
      --out QC.ld.${bfile}-502502

plink --allow-extra-chr --chr-set $chr \
      -bfile QC.${bfile} \
      --extract QC.ld.${bfile}-502502.prune.in \
      --make-bed \
      --out QC.ld.${bfile}-502502
