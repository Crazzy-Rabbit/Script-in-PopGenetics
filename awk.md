### `awk`工具的一些用法
`awk`擅长于对文件按行操作，每次读取一行，然后进行相应的操作。

`awk`读取单个文件时的基本语法格式是
```
awk 'BEGIN{OFS=FS="\t"}{print $0, $1;}' filename
```
读取多个文件时的语法
```
awk 'BEGIN{OFS=FS="\t"}ARGIND==1{print $0, $1;}ARGIND==2{print $0;}' file1 file2
```
`awk`后面的命令部分是用引号括起来的，可以单引号，可以双引号，但注意不能与内部命令中用到的引号相同，否则会导致最相邻的引号视为一组，引发解释错误。**引号不可以嵌套**
     
> OFS: 文件输出时的列分隔符 (output field separtor)

> FS: 文件输入时的列分隔符 (field separtor)

>BEGIN: 设置初始参数，初始化变量

>END: 读完文件后做最终的处理

>其它{}：循环读取文件的每一行

>$0表示一行内容；$1, $2, … $NF表示第一列，第二列到最后一列。

>NF (number of fields)文件多少列；NR (number of rows) 文件读了多少行: FNR 当前文件读了多少行，常用于多文件操作时。

>a[$1]=1: 索引操作，类似于python中的字典，在ID map，统计中有很多应用。

#### awk基本常见操作
计算count文件Type列内容出现的次数
```
awk 'BEGIN{OFS=FS="\t"}{if(FNR>1) a[$2]+=1;}END {print "Type\tCount"; for(i in a) print i,a[i];}' count

也可以是
tail -n +2 count | cut -f 2 | sort | uniq -c | sed -e 's/^  *//' -e 's/  */\t/' 
```
awk数值操作
```
log2对数
awk 'BEGIN{OFS="\t";FS="\t"}{print log($0)/log(2)}' file

取整，四舍五入
awk 'BEGIN{OFS="\t";FS="\t"}{print int($1+0.5);}' file
```
字符串匹配
```
将第一列为1-9及XY的转为chr$1的形式，将为M开头的转为chrM形式
awk 'BEGIN{OFS=FS="\t"}{if($1~/^[0-9XY]/) $1="chr"$1; else if($1~/M.*/) gsub(/M.*/, "chrM", $1); print $0}' ens.bed 
```
