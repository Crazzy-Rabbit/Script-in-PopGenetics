#### CNVcaller的循环流程
#### 请注意，其中提供的文件等建议均提供绝对路径
#### 01 和 02 步的 win 大小需一致
#### 02步的窗口文件可以一直用，若物种不变
##### 01.使用参考基因组生成dup.link窗口文件
```
bash 01_DupfiletoCNVCaller.sh
```
##### 02.计算窗口文件
```
bash 02_01Cal-winfile.sh
```
##### 03.计算每个个体绝对拷贝数
```
bash 02_02Cal_absoluteCN.sh
```
##### 04.群体水平对CNVR进行genotype的确定
```
bash 03_CNVR2Genotype.sh
```
