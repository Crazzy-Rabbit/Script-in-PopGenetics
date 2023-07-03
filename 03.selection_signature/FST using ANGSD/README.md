### ANGSD cal FST
##### 可看 Tajimas D using ANGSD

Two Populations real data
#### 一、this is with 2pops
##### 01.first calculate per pop saf for each populatoin
```
../angsd -b list1  -anc hg19ancNoChr.fa -out pop1 -dosaf 1 -gl 1
../angsd -b list2  -anc hg19ancNoChr.fa -out pop2 -dosaf 1 -gl 1
```

##### 02.calculate the 2dsfs prior
```
../misc/realSFS pop1.saf.idx pop2.saf.idx > pop1.pop2.ml
```
##### 03.prepare the fst for easy window analysis etc
```
../misc/realSFS fst index pop1.saf.idx pop2.saf.idx -sfs pop1.pop2.ml -fstout here
```
##### get the global estimate
```
../misc/realSFS fst stats here.fst.idx

-> FST.Unweight:0.069395 Fst.Weight:0.042349
```
##### 04.sliding window to cal fst
```
../misc/realSFS fst stats2 here.fst.idx -win 50000 -step 10000 > slidingwindow
```
#### 二、this is with 3pops
##### 01.first calculate per pop saf for each populatoin
```
./angsd -b list10  -anc hg19ancNoChr.fa -out pop1 -dosaf 1 -gl 1
./angsd -b list11  -anc hg19ancNoChr.fa -out pop2 -dosaf 1 -gl 1
./angsd -b list12  -anc hg19ancNoChr.fa -out pop3 -dosaf 1 -gl 1
```
##### 02.calculate all pairwise 2dsfs's
```
./misc/realSFS pop1.saf.idx pop2.saf.idx -P 24 >pop1.pop2.ml
./misc/realSFS pop1.saf.idx pop3.saf.idx -P 24 >pop1.pop3.ml
./misc/realSFS pop2.saf.idx pop3.saf.idx -P 24 >pop2.pop3.ml
```
##### 03.prepare the fst for easy analysis etc
```
./misc/realSFS fst index pop1.saf.idx pop2.saf.idx pop3.saf.idx -sfs pop1.pop2.ml -sfs pop1.pop3.ml -sfs pop2.pop3.ml -fstout here
```
##### get the global estimate
```
	-> Assuming idxname:here.fst.idx
	-> Assuming .fst.gz file: here.fst.gz
	-> FST.Unweight[nObs:1666245]:0.022063 Fst.Weight:0.034513
0.022063 0.034513
	-> FST.Unweight[nObs:1666245]:0.026867 Fst.Weight:0.031989
0.026867 0.031989
	-> FST.Unweight[nObs:1666245]:0.025324 Fst.Weight:0.021118
0.025324 0.021118
	-> pbs.pop1	0.023145
	-> pbs.pop2	0.005088
	-> pbs.pop3	0.009367
```
##### 04.sliding window to cal fst for 3 pop
```
../misc/realSFS fst stats2 here.fst.idx -win 50000 -step 10000 > slidingwindow
```
Sliding Window output
```
Second column is chromosome, third is center of window followed by
fst.unweight(pop1,pop2) fst.weight(pop1,pop2) fst.unweight(pop1,pop3) fst.weight(pop1,pop3) fst.unweight(pop2,pop3) fst.weight(pop2,pop3)

(9133,58895)(14010000,14059999)(14010000,14060000)	1	14035000	0.022099	0.016387	0.026686	0.027731	0.025311	0.047920	-0.002231	0.035045	0.030353
(19114,68881)(14020000,14069999)(14020000,14070000)	1	14045000	0.022096	0.019076	0.026777	0.024238	0.025290	0.052793	-0.005220	0.041969	0.029757
(28951,78655)(14030000,14079999)(14030000,14080000)	1	14055000	0.022043	0.021025	0.026915	0.023368	0.025342	0.056975	-0.006884	0.046840	0.030530
(38928,88632)(14040000,14089999)(14040000,14090000)	1	14065000	0.022083	0.016525	0.026846	0.029560	0.025345	0.053421	-0.004116	0.039898	0.034122
```
