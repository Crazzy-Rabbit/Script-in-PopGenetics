# Clusterprofiler进行GO及KEGG富集分析
# 安装包
#####################################################
install.packages("BiocManager")
BiocManager::install(version = "3.13")
BiocManager::install("gprofiler2")
BiocManager::install("clusterProfiler")
BiocManager::install("AnnotationHub") 
#####################################################
# 注释库的安装
## 方法1  在线
library(AnnotationDbi)
library(AnnotationHub) 
hub = AnnotationHub() # 每次打开会检测是不是最新的数据库
hub$species[which(hub$species == "Ovis aries")]                                  # 寻找AnnotationHub中是否有目标物种的注释库
org <- hub[hub$rdataclass == "OrgDb",]                                           # 指定OrgDb数据库格式，而不是其他数据库格式
query(org, "Ovis aries")                                                         # 查找目标物种的数据库，找.sqlite文件对应的AH号
sheep.db <- hub[['AH6429']]                                                      # 下载注释库为sheep.db，注释库加载完成
columns(sheep.db)

## 方法2  本地
setwd("D:/生信/sheep.db")                                                        # 下载的数据库保存目录，加载对应目录
sheep.db <- AnnotationDbi::loadDb('org.Ovis_aries.eg.sqlite')                    # 在Bioconder下载物种对应的注释库.sqlite，加载完成
columns(sheep.db)

## 牛
setwd("D:/生信/cattle.db")
bos.db <- AnnotationDbi::loadDb('org.Bt.eg.db.sqlite')
columns(bos.db)
#####################################################

# 1 GO分析（上下调基因分开做，可用于BP,CC,MF分开画图）
library(clusterProfiler)
genes <- read.table('GENEID.txt', header = T, stringsAsFactors = FALSE,sep = '\t')# 读取基因列表文件中的基因名称，GENEID.txt为一行的无表头的基因ID

enrich.go <- enrichGO(gene = genes$V1,                                            # 基因列表文件中的基因名称
                      OrgDb = bos.db,                                             # 指定物种的基因数据库
                      keyType = 'SYMBOL',                                         # 指定给定的基因名称类型，例如这里以 SYMBOL 为例
                      ont = 'CC',                                                 # 可选 BP、MF、CC，也可以指定 ALL 同时计算 3 者
                      pAdjustMethod = 'BH',                                       # 指定 p 值校正方法
                      pvalueCutoff = 1,                                           # 指定 p 值阈值，不显著的值将不显示在结果中
                      qvalueCutoff = 1                                            # 指定 q 值阈值，不显著的值将不显示在结果中
                     )
                     
# 例如上述指定 ALL 同时计算 BP、MF、CC，这里将它们作个拆分后输出
BP <- enrich.go[enrich.go$ONTOLOGY=='BP', ]
CC <- enrich.go[enrich.go$ONTOLOGY=='CC', ]
MF <- enrich.go[enrich.go$ONTOLOGY=='MF', ]
write.table(as.data.frame(BP), 'HUgo.BP.txt', sep = '\t', row.names = FALSE, quote = FALSE)
write.table(as.data.frame(CC), 'HUgo.CC.txt', sep = '\t', row.names = FALSE, quote = FALSE)
write.table(as.data.frame(MF), 'HUgo.MF.txt', sep = '\t', row.names = FALSE, quote = FALSE)

# 2 GO分析（上下调一起做，可以看整体结果，并可选取其中的部分画图）
gene_down <- read.table('up_gene.txt', header = T, stringsAsFactors = FALSE,sep = '\t')
gene_up <- read.table('down_gene.txt', header = T, stringsAsFactors = FALSE,sep = '\t')

library(clusterProfiler)
deg.up.gene <- bitr(gene_up$x, fromType = "SYMBOL", toType = "ENTREZID", OrgDb = bos.db)$ENTREZID  # 转基因ID为ENTREZID 
deg.down.gene <- bitr(gene_down$x, fromType = "SYMBOL", toType = "ENTREZID", OrgDb = bos.db)$ENTREZID
deg.ei.ls <- list(up = deg.up.gene, down = deg.down.gene)                       # 将up 和 down基因合并到一个表格

library("org.Bt.eg.db")
GO.cmp <- compareCluster(deg.ei.ls,
                         fun = "enrichGO",
                         qvalueCutoff = 0.1, 
                         pvalueCutoff = 0.01,
                         pAdjustMethod = 'BH',
                         ont = 'BP',                                            # 可选 BP、MF、CC，也可以指定 ALL 同时计算 3 者，建议分开做输出，默认按照pvalue升序排列的
                         OrgDb = bos.db)
write.table(GO.cmp@compareClusterResult,'GO-up-down.txt',sep = '\t',quote = F)  # 结果写到本地GO-up-down.txt
#####################################################

# 5 KEGG, 上下调一起做（适合看上下调整体的结果，做那种上下调的条形图）
gene_down <- read.table('up_gene.txt', header = T, stringsAsFactors = FALSE,sep = '\t')
gene_up <- read.table('down_gene.txt', header = T, stringsAsFactors = FALSE,sep = '\t')
library(clusterProfiler)
deg.up.gene <- bitr(gene_up$x, fromType = "SYMBOL", toType = "ENTREZID", OrgDb = bos.db)$ENTREZID 
deg.down.gene <- bitr(gene_down$x, fromType = "SYMBOL", toType = "ENTREZID", OrgDb = bos.db)$ENTREZID

deg.ei.ls <- list(up = deg.up.gene, down = deg.down.gene)

search_kegg_organism("taurus", by="scientific_name")                      # 寻找对应动物的organism
library(clusterProfiler)
R.utils::setOption("clusterProfiler.download.method",'auto')              # 一定要用这个，不然报错别怪我哦
kegg.cmp <- compareCluster(deg.ei.ls,
                           fun = "enrichKEGG",
                           qvalueCutoff = 1, 
                           pvalueCutoff = 1,
                           pAdjustMethod = 'BH',
                           organism = "bta")                                                         

write.table(kegg.cmp@compareClusterResult,'kegg-up-down.txt',sep = '\t',quote = F)

# 6 kegg， 上下调分开做（适合画图）

library(clusterProfiler)
genes <- read.table('txt', header = T, stringsAsFactors = FALSE,sep = '\t')
covID <- bitr(genes$V1, fromType = "SYMBOL",
                   toType="ENTREZID",OrgDb= bos.db , drop = TRUE)         # 转换为entrezID，KEGG只识别这种ID，报错请检查自己输入的文件，对自己的代码有自信
write.table(covID,'ENTREZID-up.txt',sep = '\t',quote = F)                 # 写出去保存,也可以不保存，看个人需求

#每次打开R计算时，它会自动连接kegg官网获得最近的物种注释信息，因此数据库一定都是最新的
search_kegg_organism("taurus", by="scientific_name")                      # 寻找对应动物的organism

R.utils::setOption("clusterProfiler.download.method",'auto')
enrich_kegg <- enrichKEGG(gene = covID$ENTREZID,                          # 基因列表文件中的基因名
                          organism = 'bta',                               # 指定物种，牛为bta
                          keyType = 'kegg',                               # kegg富集
                          pAdjustMethod = 'BH',                           # 指定矫正方法
                          pvalueCutoff = 1,                               # 指定p值阈值，不显著的值将不显示在结果中
                          qvalueCutoff = 1)                               # 指定q值阈值，不显著的值将不显示在结果中

write.table(enrich_kegg@result,'kegg-down.txt',quote = F,sep = '\t')
#####################################################

