# 1、转为phy格式：
python /home/sll/software/vcf2phylip.py --input FASN.vcf.recode.vcf
# 2、建树：
raxmlHPC-PTHREADS-SSE3 -f a -m GTRGAMMA -p 12345 -x 12345 -# 100 -s FASN.min4.phy -n raxml -T 30
