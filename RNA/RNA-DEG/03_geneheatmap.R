#######  表达矩阵探索,选取差异表达的基因做热图  deseq后的排序文件 ######
library(pheatmap)
res_padj <- read.table("diffexpr_padj_results.txt", quote = F,sep = '\t')

choose_gene=head(rownames(res_padj),50)  
choose_matrix=countdata.filter[choose_gene,]  #抽取差异表达显著的前50个基因
choose_matrix=t(scale(t(choose_matrix)))  #用t函数转置，scale函数标准化

png(filename = "DEG_pheatmap.png", width = 600, height = 1000)
pheatmap(choose_matrix)
dev.off()
