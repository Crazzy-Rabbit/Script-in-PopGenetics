#### lumpy对CNVcaller结果进行矫正的大致流程
##### 01、`smoove` 和 `CNVcaller`分别识别CNV，去除contig

##### 02、提取`smoove` 和 `CNVcaller`结果对应的`SVTYPE`及`pos`
```
smoove: /home/sll/script/smoove/05.GetCnvrFromSmooveResult.py
cnvcaller: /home/sll/script/CNVCaller/GetSVtypeForIntersect.py
```
##### 03、lumpy结果对`CNVcaller`结果的`DEL`进行矫正
```
grep "<DEL>" 来提取DEL及DUP类型
bedtools intersect -f 0.3 -F 0.3 -e 取两文件只要有一个的区间重叠率符合则保留
/home/sll/script/Del-overlap_interval.py 去除结果中的重叠区间
```
##### 04、cat合并DUP和矫正后的DEL
```
之后提取前三列，手动加上头文件 chr start end
```
##### 05、提取位置对应的`genotypeCNVR.tsv`文件内容
```
/home/sll/script/CNVCaller/GetCleanCNV.py
```
