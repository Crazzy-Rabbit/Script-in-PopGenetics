#!/usr/bin/env Rscript

# 使用/home/sll/miniconda3/envs/python3.7/lib/R/bin/Rscript --help看说明文档
suppressPackageStartupMessages(library("GenomicRanges"))
suppressPackageStartupMessages(library("optparse"))
##=============================================================================
## function
split_windows <- function(data, window_size = 100000, step_size = 50000){
    windows <- data.frame()
    for (i in 1:nrow(data)){
        chr <- as.character(data$chr[i])
        starts <- seq(from = 1,
                      to = (data$length[i] - window_size),
                      by = step_size)
        ends <- as.integer(starts + window_size - 1)
        regions <- data.frame(chr = chr, start=starts, end=ends)
        windows <- rbind(windows, regions)
    }

    return(windows)
}

read_ibd <- function(file, ind, origin_format=TRUE, genome_info=NA, input_format = "beagle"){
    ibd <- read.table(file = file, stringsAsFactors = F, sep = "\t",
                      col.names = c("id1","hap1","id2","hap2",
                                    "chr","start","end","score"),
                      colClasses = c("character","integer","character", "integer",
                                     "character","integer", "integer", "double"))
    
    # filter individuals
    ibd <- ibd[which((ibd$id1 %in% ind & ibd$id2 %in% ind)),]
    
    if(origin_format){
        return(ibd)
    }
    
    chroms <- names(table(ibd$chr))
    ibd_gr <- makeGRangesFromDataFrame(df = ibd, keep.extra.columns = T, ignore.strand = T)
    ibd_cov <- coverage(ibd_gr)
    genome_cov <- data.frame()
    for (chr in chroms){
        region_len <- runLength(ibd_cov[[chr]])
        region_cov <- runValue(ibd_cov[[chr]])
        region_end <- cumsum(region_len)
        region_start <- region_end - region_len + 1
        genome_cov <- rbind(genome_cov, data.frame(chr=chr,
                                                   start=region_start,
                                                   end=region_end,
                                                   coverage=region_cov))
    }
    
    return(genome_cov)
}

sum_coverage <- function(coverage, start, end){
    if(length(coverage) == 0){
        freq <- 0
    }else{
        freq <- sum((width(coverage) * coverage$coverage)) / sum(width(coverage))
        
    }
    
    return(freq)
}

calculate_ribd <- function(x, y, nx, ny, no, regions){
    regions <- makeGRangesFromDataFrame(regions)
    rx <- makeGRangesFromDataFrame(df = x, keep.extra.columns = T)
    ry <- makeGRangesFromDataFrame(df = y, keep.extra.columns = T)
    ribd <- vector(mode = "double", length = length(regions))
    for (i in 1:length(regions)){
        region <- regions[i]
        irx <- queryHits(findOverlaps(rx, region, ignore.strand=T))
        iry <- queryHits(findOverlaps(ry, region, ignore.strand=T))
        frx <- sum_coverage(rx[irx], start = start(region), end = end(region))
        fry <- sum_coverage(ry[iry], start = start(region), end = end(region))
        ribd[i] <- frx / (nx * no * 4) - fry / (nx * ny * 4)
    }
    
    regions$ribd <- ribd
    return(regions)
}


##=============================================================================
## parse options
parser <- OptionParser(add_help_option = T)
parser <- add_option(parser, c("-v", "--verbose"), action="store_true",
                     default=TRUE, help="Print extra output [default]")
parser <- add_option(parser, c("-q", "--quietly"), action="store_false",
                     dest="verbose", help="Print little output")
parser <- add_option(parser, c("-i", "--ibd-file"), type="character", dest = "ibd_file",
                     help="the IBD file that contains three poputions")
parser <- add_option(parser, c("-f", "--ibd-format"), type="character", dest = "ibd_format",
                     help="set format of input file [default %default]", default = "beagle")
parser <- add_option(parser, c("-x", "--xlist"), type="character", dest = "xids",
                     help="ID list of introgressive population with outgroup")
parser <- add_option(parser, c("-y", "--ylist"), type="character", dest = "yids",
                     help="ID list of sister population of x")
parser <- add_option(parser, c("-z", "--zlist"), type="character", dest = "oids",
                     help="ID list of outgroup")
parser <- add_option(parser, c("-o", "--out-file"), type="character", dest = "out_file", default = "out",
                     help="set the name of output file [default %default]")
parser <- add_option(parser, c("-w", "--window-size"), type="integer", default=20000, 
                     help="specify the window size [default %default]",
                     metavar="number", dest = "ws")
parser <- add_option(parser, c("-s", "--step-size"), type="integer", default=10000, 
                     help="specify the window size [default %default]",
                     metavar="number", dest = "ss")
opt <- parse_args(parser)
ibd_file <- opt$ibd_file
ibd_format <- opt$ibd_format
out_file <- opt$out_file
window_size <- opt$ws
step_size <- opt$ss
xids_file <- opt$xids
yids_file <- opt$yids
oids_file <- opt$oids

xids <- scan(xids_file, what = character())
yids <- scan(yids_file, what = character())
oids <- scan(oids_file, what = character())

nyids <- length(yids)
nxids <- length(xids)
noids <- length(oids)

ibdxy <- read_ibd(file = ibd_file, ind = c(xids, yids), origin_format = F)
ibdxo <- read_ibd(file = ibd_file, ind = c(xids, oids), origin_format = F)
chr_len <- max(c(ibdxy$end, ibdxo$end))
chr_ids <- unique(ibdxy$chr)
chr_info <- data.frame(chr = chr_ids, length = chr_len)
windows <- split_windows(data = chr_info, window_size = window_size, step_size = step_size)

ribd <- calculate_ribd(x = ibdxo, y= ibdxy, ny = nyids, nx = nxids, no = noids, regions = windows)

ribd <- as.data.frame(ribd)
write.table(x = ribd, file = paste(out_file, ".ribd.tsv", sep = ""), 
            quote = F, sep = "\t", col.names = F)

pdf(file = paste(out_file, ".ribd.pdf", sep = ""), width = 12, height = 6, onefile = T)
plot(x = ribd$start/1000000, y = ribd$ribd, type = "h", 
     xlab = paste(chr_ids, " (Mb)", sep = ""), ylab = "rIBD")
dev.off()
