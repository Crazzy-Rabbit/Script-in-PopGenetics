### BEDTOOLS some useful command
##### 01. intersect option
The `intersect` command is the workhorse of the bedtools suite. It compares two or more `BED/BAM/VCF/GFF` files and identifies all the regions in the genome where the features in the two files overlap (that is, share at least one base pair in common).

![image](https://github.com/Crazzy-Rabbit/Script-in-Bio/assets/111029483/751d6863-f803-4384-98e5-8450453f1be8)
```
无参数直接输出overlap部分
-wa 输出有overlap的A文件的整个区间
-wb 输出有overlap的B文件的整个区间
-v  只输出A和B完全overlap的区间
-wo 输出overlap区间，只要有overlap就输出， 和不输入参数一样
-f  对于A文件，最小overlap的区间的比例，大于他保留，例如0.3
-F  对于B文件，最小overlap的区间的比例，大于他保留
-r  两个文件reciprocal的overlap比例，拷贝数矫正用这个
```
##### 02. merge option
Many datasets of genomic features have many individual features that overlap one another (e.g. aligments from a ChiP seq experiment). It is often useful to just cobine the overlapping into a single, contiguous interval. The bedtools merge command will do this for you.

![image](https://github.com/Crazzy-Rabbit/Script-in-Bio/assets/111029483/a8cb4ca8-0654-452b-84af-8fc502d118fd)

```
-d 指定两个要merge的区间之间的最大间隔大小（bp）
```
