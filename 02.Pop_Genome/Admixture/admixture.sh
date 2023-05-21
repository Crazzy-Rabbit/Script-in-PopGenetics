# /bin/bash

if [ $# -ne 3 ]; then
  echo "error.. need args"
  echo "command: bash $0 <mK, 最大的K值, 默认从2开始> <nseed, 1-100内随机数的数量，推荐20> <bed file, bed文件>"
  exit 1
fi

nK=$1
nseed=$2
bed=$3

# 生成20个随机数
for i in $(seq 2 $nK); 
do 
  for j in $(shuf -i 1-100 -n $nseed); 
  do 
    echo $i $j;    
  done; 
done > seed.txt


# do admixture
cat seed.txt | while read line;
do
  para1=`echo $line | awk '{print $1}' `
  para2=`echo $line| awk '{print $2}' `

  export K=$para1
   export seed=$para2
  /home/software/admixture_linux-1.3.0/admixture -s $seed --cv $bed $K -j4 | tee log${K}.out
done