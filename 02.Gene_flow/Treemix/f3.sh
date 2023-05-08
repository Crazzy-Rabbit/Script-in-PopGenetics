# treemix中的threepop计算f3


threepop -i sample.treemix.in.gz -k 500 > 3pop

cat 3pop |grep -v Estimating |grep -v nsnp|tr ';' ' ' > 3pop.txt
