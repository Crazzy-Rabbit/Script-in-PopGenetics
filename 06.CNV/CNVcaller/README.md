#### CNVcaller的循环流程
#### 请注意，其中提供的文件等建议均提供绝对路径
##### 01.使用参考基因组生成dup.link窗口文件
```
bash 01_DupfiletoCNVCaller.sh
```
##### 02.计算绝对拷贝数
```
bash 02_01Cal-absoluteCNV.sh
```
##### 03.群体水平对CNVR进行genotype的确定
```
bash 02_02CNVR2Genotype.sh
```
