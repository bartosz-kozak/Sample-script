library(adegenet)
library(phangorn)

setwd("./R/Sample_data/")

wyniki<-read.csv("Wyniki1.csv", row.names = 1)

wyniki_gi<-df2genind(wyniki, ploidy = 2, ncode = 1, type = "codom")
# oblicza dystans Nei 79
dystans<-dist.gene(wyniki_gi@tab, method="pairwise")
# tworzy drzewo upgma
tree_upgma<-upgma(dystans)
# funkcja do bootstrapu
boot_fun<-function(df){upgma(dist.gene(df, method = "pairwise"))}
boot<-boot.phylo(tree_upgma, wyniki_gi@tab, boot_fun)
plot.phylo(tree_upgma, cex=0.4)
nodelabels(boot, frame = "n", cex=0.8)
picfunc<-function(x){
  
  picval<-c()
  a <- sum(sum(x=="AA")*2, sum(x=="AT"), sum(x=="AG"), sum(x=="AC"), sum(x=="TA"), sum(x=="GA"), sum(x=="CA"))
  t <- sum(sum(x=="TA"), sum(x=="TT")*2, sum(x=="TG"), sum(x=="TC"), sum(x=="AT"), sum(x=="GT"), sum(x=="CT"))
  g <- sum(sum(x=="GA"), sum(x=="GT"), sum(x=="GG")*2, sum(x=="GC"), sum(x=="AG"), sum(x=="TG"), sum(x=="CG"))
  c <- sum(sum(x=="CA"), sum(x=="CT"), sum(x=="CG"), sum(x=="CC")*2, sum(x=="AC"), sum(x=="TC"), sum(x=="GC"))
  s<-sum(a,t,g,c)
  
  freqa<-(a/s)^2
  freqt<-(t/s)^2
  freqc<-(g/s)^2
  freqg<-(c/s)^2
  
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
# tworzy plik z nazwami markerów o wartościach PIC większych od zadanej wartości
pic_val_03<-pic_val[pic_val>0.3]
markery<-names(pic_val_03)
# zapisuje nazwy markerów do pliku tekstowego
lapply(markery, write, file="marker_name_pic.txt", append=TRUE)

podsum<-summary(wyniki_gi)