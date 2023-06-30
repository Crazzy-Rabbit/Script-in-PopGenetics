#### 计算iHS
一气呵成
```
export chr=$chr
export outprefix=$out

bash iHS.sh --vcf filename.beagle.vcf.gz --win 50000 --step 50000 --chr $chr --thread 10 --out $outprefix
```
分步计算
```
通过常规方式计算得到$chr.ihs.out.100bins.norm和$chr.ihs.out.100bins.norm.50kb.windows文件
使用python 脚本对$chr.ihs.out.100bins.norm文件取窗口区间内的norm iHS的绝对值的平均值，可设置步长

export i=$chr
export win=$win
export step=$step

python iHS_Win_step.py --file Chr${i}.ihs.out.100bins.norm --chr $i --window $win --step $step
```
