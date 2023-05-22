#! /bin/bash

if [[ $# -ne 1 ]]; then
  echo "command: bash $0 <K, 最大的那个K>"
  exit 1
fi

K=$1

for i in $(seq 2 $K);
do
  grep -h CV *run/log${i}.out > ${i}cv_out.txt
done

paste *cv_out.txt > all.cv_out
