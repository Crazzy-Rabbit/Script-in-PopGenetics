#### CNVcaller的循环流程
#### 请注意，其中提供的文件等建议均提供绝对路径
#### 01 和 02 步的 win 大小需一致
#### 01 的link文件和 02的窗口文件可以一直用，若物种不变
##### 01.使用参考基因组生成dup.link窗口文件
```
bash 01_DupfiletoCNVCaller.sh
```
##### 02.计算窗口文件
```
bash 02_01CalWinFile.sh
```
##### 03.计算每个个体绝对拷贝数
```
bash 02_02CalAbsoluteCN.sh
```
##### 04.群体水平定义CNVR边界
```
bash 03_01DeterminCNVR.sh
```
##### 05.CNVR的genotype
```
bash 03_02GenotypeCNVR.sh
```
