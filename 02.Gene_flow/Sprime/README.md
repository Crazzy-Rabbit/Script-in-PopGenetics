#### Sprime 推断渗入片段
##### 01.sprime推断
```
java -jar sprime.jar gt=$phased.vcf.gz outgroup=$outgroup_ID map=$chr.map out=$out maxfreq=0.01 mu=4.32e-9 minscore=150000 chrom=$chr:$start-$end excludesamples=$exclude_ID

# map 含有genetic distance的map文件
# chrom=[chrom]:[start]‑[end] limits the output to a chromosome interval where [chrom] is the CHROM identifier in the input VCF file, and [start] and [end] are the start and end positions. An entire chromosome, the beginning of a chromosome, or the end of a chromosome may be specified with chrom=[chrom], chrom=[chrom]:‑[end], and chrom=[chrom]:[start]‑ respectively. If the chrom parameter is used, the input VCF file must still contain all autosomes so that the global variant density can be accurately estimated.
# maxfreq=[nonnegative number ≤ 1.0] specifies the maximum frequency of an introgressed variant in the outgroup (default: maxfreq=0.01), Variants with outgroup frequency less than or equal to maxfreq are ignored.
# minscore=[nonnegative number] specifies the minimum score of an introgressed segment (default: minscore=1.0e5).
# mu=[positive number] specifies the genomewide mutation rate per base pair per meiosis (default: mu=1.2e-8).
# excludesamples=[file] specifies a file containing samples to be excluded from the analysis (one sample identifier per line).
# excludemarkers=[file] specifies a file containing markers to be excluded from the analysis (one marker per line). Each line of the file can be a marker identifier from a VCF record’s ID field or a genomic coordinate expressed as CHROM:POS.
```
输出文件
```
    CHROM   POS     ID      REF     ALT     SEGMENT ALLELE  SCORE
    9       6624    .       C       T       12      1       2710303
    9       6821    .       A       G       12      1       2710303
    9       6936    .       G       A       12      1       2710303
```
##### 02.Reconstructe Intro Allele
```
python 01.ReconstructeIntroAllele.py -f $out -v $phased.vcf -S sample.list -o new.intro
```
输出文件格式
```
#Chr    Pos     Segment A1      A14     A23     A25     A6      A7
29      152644  2       Y|Y     N|Y     N|Y     Y|Y     N|Y     N|Y
29      153287  2       Y|Y     N|Y     N|Y     N|Y     N|Y     N|Y
29      153595  2       Y|Y     N|Y     N|Y     N|Y     N|Y     N|Y
```
##### 03.Stat Individual Segment
```
python 02.StatIndividualSegment.py -i new.intro -o ind_segment
```
##### 03.Stat Introgression Length
```
python 03.StatIntrogressionLen.py -i ind_segment -n number -o int_len

# -n 指定连续的渗入片段包含的渗入SNP数量。default 50 
```
##### 03.Stat Introgression By Window
```
python 04.StatIntrogressionByWindow.py -i ind_segment -w 100000 -s 10000 -o int_lenByWin
```
输出文件格式
```
    #Chr    Start   End     IntroNum        A1      A14     A23     A25     A6
    4       0       100000  0               0|0     0|0     0|0     0|0     0|0
    4       10000   110000  40              30|0     0|0     0|0     0|0     0|0
```
##### 04.Identity Intro Window
```
python 05.IdentityIntroWindow.py -i int_lenByWin -n 10 -r 0.8 -o int_win

# -n the min number of introgression var, default=10
# -r the min ratio of introgression var, default=0.8
```
