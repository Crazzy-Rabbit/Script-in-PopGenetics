#! /bin/bash

if [[ $# -ne 1 ]]; then
  echo "command: bash $0 <K, 最大的那个K>"
  exit 1
fi

K=$1

for i in $(seq 2 $K);
do
  grep "CV" *run/log${i}.out | awk '{print $3,$4}' | cut -c 4,7-20 > ${i}cv_out.txt
done

paste *cv_out.txt > all.cv_out
