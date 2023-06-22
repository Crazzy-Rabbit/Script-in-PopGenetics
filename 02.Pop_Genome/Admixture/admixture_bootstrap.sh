# /bin/bash

if [ $# -ne 3 ]; then
  echo "error.. need args"
  echo "command: bash $0 <mK, 最大的K值, 默认从2开始> <nseed, 1-100内随机数的数量，推荐20> <bed file, bed文件,要绝对路径>"
  exit 1
fi

nK=$1
nseed=$2
bed=$3
base_dir="`pwd`/admixture"   # 存储输出结果的基本目录

mkdir -p $base_dir

# 生成20个随机数
for r in $(seq 1 $nseed); 
do 
  curr_dir="${base_dir}/${r}.run"
  mkdir -p $curr_dir && cd $curr_dir
  
  for K in $(seq 2 $nK); 
  do
    seed=`shuf -i 1-100 -n 1`
    /home/software/admixture_linux-1.3.0/admixture -s $seed --cv $bed $K -j20 | tee ${curr_dir}/log${K}.out
  done;
done
