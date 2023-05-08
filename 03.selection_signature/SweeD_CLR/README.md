## 这个方法比自己制作grid文件最终得到的窗口整齐，怒推

### 01.SweeD.sh  计算SweeD，只用提供VCF=$1 Chr=$2 Pop=$3 Out=$4， pop为一列的个体ID
它是将其分为远小于你的窗口大小的区间计算CLR，最终取这些区间的最大值
### 02.MergeResults.sh  合并染色体结果
### 03.GetWinCLRFromSweeD.py 获得滑窗及步长的SweeD结果
