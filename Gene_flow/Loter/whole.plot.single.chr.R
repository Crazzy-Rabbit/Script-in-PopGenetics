#library(viridis)
library(RColorBrewer)
library(scales)
args<-commandArgs(TRUE)
FAI<-args[1]
AB<-args[2]
oup<-args[3]

fai<-read.table(FAI,stringsAsFactors=F,sep="\t")
ab<-read.table(AB,stringsAsFactors=F,sep="\t")



########round_loci
wid<-0.25
r<-1000000
z<-seq(0,2*pi,length=1000)
x<-sin(z)*r
y<-cos(z)*wid
###########plot
pdf(oup,w=12,h=9)
par(xaxs='i',yaxs='i',lend=2,mar=c(3,4,0.2,3))
plot(1:10,axes=F,xlab="Mb",ylab="Chromosome",xlim=c(-r,max(fai)),ylim=c(28.5,-1.5),type='n',xpd=NA)

for (chr in fai$V1){
##########chr.plot
	cfai<-fai[fai$V1==chr,]
	cab<-ab[ab$V1==chr,]
        head(cab)
	px<-c(cfai$V2,cfai$V2+x[1:500],0,0+x[501:1000],0)
	py<-c(chr+wid,chr+y[1:500],chr-wid,chr+y[501:1000],chr+wid)
	polygon(px,py,border='black',lwd=0.5,col=adjustcolor('grey',alpha.f=0.1),xpd=NA)
#########AB.plot
#        col1<-col_numeric(brewer.pal(11,'RdBu')[11:1],cab$V4)(cab$V4)
#        col1<-col_numeric(brewer.pal(11,'RdBu')[11:1],Data)(Data)
        col1<-col_numeric(brewer.pal(9,'YlGnBu')[8:1],cab$V4)(cab$V4)
#        color.palette=viridis
        rect(cab$V2,chr-wid,cab$V3,chr+wid,col=c(col1),lwd=0.0001,border=NA)
#         rect(cab$V2,chr-wid,cab$V3,chr+wid,col=viridis,lwd=0.0001,border=NA)
}
###########axis
axis(side = 2,at = c(1:27),labels = c(1:26,"X"),las=2,line=0.2)
axis(side = 1,at=pretty(par('usr')[1:2]),labels=pretty(par('usr')[1:2])/1000000,tcl=-0.25,line=-1.5)
mtext(1,text="Mb",xpd=NA)
###########AB_legend
#par(fig = c(0.4,0.7, 0.95, 0.98), new=TRUE,mar=c(0,0,0,0),mgp=c(0.8,0.3,0),tcl=-0.25,lend=2)
par(fig = c(0.5,0.8, 0.75, 0.78), new=TRUE,mar=c(0,0,0,0),mgp=c(0.8,0.3,0),tcl=-0.25,lend=2)
##这里开始对颜色开始赋值
ry1<-range(ab$V4)
yy1<-seq(from=ry1[1],to=ry1[2],len=as.integer(diff(ry1)*100))
#col1<-col_numeric(brewer.pal(11,'RdBu')[11:1],yy1)(yy1)
col1<-col_numeric(brewer.pal(9,'YlGnBu')[8:1],yy1)(yy1)
image(x=c(yy1),y=c(1,1.2),z=t(t(c(yy1))),col=c(col1),axes=F)
axis(1,cex.axis=0.7)
mtext(1,text="Introgression ratio",line=1,cex=0.8)
box(bty='o')
#################
dev.off()
