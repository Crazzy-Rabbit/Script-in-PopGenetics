#! /bin/bash

if [[ $# -ne 1 ]]; then
  echo "command: bash $0 <K, 最大的那个K>"
  exit 1
fi

K=$1

for i in {1..20};
do
  grep "CV" ${i}.run/log*.out | awk '{print $3, $4}' | cut -c 4,7-20 > ${i}run.cv_out.txt
done

paste *cv_out.txt > all.cv_out
