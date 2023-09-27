## PLINK 1.9
PLINK 1.9 中一些有用的参数
###### 保留原始等位基因顺序，即不让Alt成为 `minor allele`
```
--keep-allele-order		Do not flip A1 to be the minor allele
```
###### 添加SNP ID
```
--set-missing-var-ids @:#  将PLINK文件SNP ID位置的.替换，方便后续分析
```
###### 将ATCG转换为1234形式
```
--allele1234		Convert (A,C,G,T) to (1,2,3,4)
--alleleACGT		Convert (1,2,3,4) to (A,C,G,T)
```
###### 过滤参数
```
--maf	{0.01}	  Minor allele frequency
--max-maf	{1}	  Maximum minor allele frequency
--geno	{0.1}	  Maximum per-SNP missing
--mind	{0.1}	  Maximum per-person missing
--hwe	{0.001}	  Hardy-Weinberg disequilibrium p-value (exact)
--hwe2	{0.001}	Hardy-Weinberg disequilibrium p-value (asymptotic)
--hwe-all		    HW filtering based on all founder individuals for binary trait (instead of just unaffecteds)
--me	{0.1} {0.1}	Mendel error rate thresholds (per SNP, per family)
--cell	{5}	    Minimum genotype cell count for --model
--min	{0}	      Minimum pi-hat for --genome output
--max	{1}	      Maximum pi-hat for --genome output
```
###### IBS distance
```
--genome		        Calculate IBS distances between all individuals
--cluster		        Perform clustering
--matrix		        Output IBS (similarity) matrix
--distance-matrix		Output 1-IBS (distance) matrix (IBD距离矩阵用这个)
```
###### ROH 和 近交系数
```
--het		                Individual inbreeding F / heterozygosity
--homozyg-kb	{kb}	    Identify runs of homozygosity (kb)
--homozyg-snp	{N SNPs}	Identify runs of homozygosity (# SNPs)
--homozyg-het	{N hets}	Allow for N hets in run of homozygosity
--homozyg-group		Group pools of overlapping segments
--homozyg-match	{0.95}	Identity threshold for allelic matching overlapping segments
--homozyg-verbose		    Display actual genotypes for each pool
```


