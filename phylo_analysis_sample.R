library(adegenet)
library(phangorn)

setwd("~/Bioinformatyka/KASP_SNP/")

wyniki<-read.csv("Wyniki.csv", row.names = 1)

wyniki_gi<-df2genind(wyniki, ploidy = 2, ncode = 1)

dystans<-dist.binary(wyniki_gi@tab, method=5)

tree_upgma<-upgma(dystans)

boot_fun<-function(df){upgma(dist.binary(df, method = 5))}
boot<-boot.phylo(tree_upgma, wyniki_gi@tab, boot_fun)
plot.phylo(tree_upgma)
nodelabels(boot, frame = "n", cex=0.8)

picfunc<-function(x){
  
  picval<-c()
  
  s<-sum(sum(x=="A"), sum(x=="T"), sum(x=="C"), sum(x=="G"))
  
  freqa<-(sum(x=="A")/s)^2
  freqt<-(sum(x=="T")/s)^2
  freqc<-(sum(x=="C")/s)^2
  freqg<-(sum(x=="G")/s)^2
  
  h<-1-(sum(freqa, freqt, freqc, freqg))
  pic<-h-sum((2*freqa*freqc), (2*freqa*freqt), (2*freqa*freqg), (2*freqc*freqt), (2*freqc*freqg), (2*freqt*freqg))
  picval<-cbind(picval,c(h,pic))
  
  return(picval)
}

vals<-sapply(X=wyniki, picfunc)
pic_val<-vals[2,]
het_val<-vals[1,]
hist(pic_val)
hist(het_val)

pic_val_03<-pic_val[pic_val>0.3]
markery<-names(pic_val_03)

apply(markery, write, file="marker_name_pic.txt", append=TRUE)

podsum<-summary(wyniki_gi)