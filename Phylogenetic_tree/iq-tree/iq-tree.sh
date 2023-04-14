#####转成map ped
plink --allow-extra-chr --chr-set 27 -bfile ld.QC.xll_noinclude0.recode-502502-geno02-maf03 \
                        --recode \
                        --out ld.QC.xll_noinclude0.recode-502502-geno02-maf03  

#####转成fa
python ped2fa.py ld.QC.xll_noinclude0.recode-502502-geno02-maf03.ped ld.QC.xll_noinclude0.recode-502502-geno02-maf03.fa &
     # 打开fa文件修改个体ID，当然也可以不改

#####过滤I成N
sed -i "s/I/N/g" ld.QC.xll_noinclude0.recode-502502-geno02-maf03.fa

#####Iqtree（构建进化树）
/home/software/iqtree-1.6.12-Linux/bin/iqtree -s ld.QC.75_xiugai_noinclude0-502502-geno02-maf03.fa 
                                              -m TEST \
                                              -st DNA \
                                              -bb 1000 \
                                              -nt AUTO
#####itol画树（网页搜索）
# 用bionj文件
