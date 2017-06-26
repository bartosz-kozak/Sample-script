if (!require("adegenet")) install.packages("adegenet")
if (!require("ape")) install.packages("ape")
if (!require("phangorn")) install.packages("phangorn")
if (!require("hierfstat")) install.packages("hierfstat")
if (!require("pegas")) install.packages("pegas")
if (!require("poppr")) install.packages("poppr")

library(adegenet)
library(ape)
library(phangorn)
library(hierfstat)
library(pegas)
library(poppr)

color<-rainbow(9)

setwd("./R/Sample_data/")

lupin_dane<-as.data.frame(read.table("Lupin_dane1.csv", header = TRUE, row.names = 1, sep = ","))
strata_info<-as.data.frame(read.table("Strata_info.csv", header = TRUE, sep = ","))
ss<- strata_info[,c(2,3,4,5,6)]
lupin_genind<-df2genind(lupin_dane, ploidy = 2, ncode = 3, type = "codom")
strata(lupin_genind)<- ss
nameStrata(lupin_genind)<- ~odmiana/pochodzenie/typ/DA/DA1
setPop(lupin_genind)<- ~DA1
grupy<-find.clusters(lupin_genind, max.n.clust = 40)
grupy1<-find.clusters(lupin_genind, max.n.clust = 40)
analiza1<-dapc(lupin_genind, pop(lupin_genind))

scatter(analiza1)

pop(lupin_genind)<-grupy$grp
lupin_genind@tab<- tab(lupin_genind, NA.method = "mean")
dystans<- nei.dist(lupin_genind)
drzewoUPGMA<-upgma(dystans)
boot_fun<-function(df){upgma(nei.dist(df))}
boot<-boot.phylo(drzewoUPGMA, lupin_genind@tab, boot_fun)
plot.phylo(drzewoUPGMA, cex = 0.5)
add.scale.bar(0,40,length = 0.05)
nodelabels(boot, frame = "n", cex=0.8)
t1<-as.integer(pop(lupin_genind))
myCol<-rainbow(9)[t1]
myColor<-c("black", myCol)
t2<- lupin_genind$strata$odmiana
names(myColor)<-c("node", t2)
myLabeles<-c(drzewoUPGMA$tip.label)
selColors<- myColor[match(myLabeles[drzewoUPGMA$edge[,2]], names(myColor), nomatch=1)]

plot.phylo(drzewoUPGMA, type = "fan", edge.color = selColors, cex = 0.5, tip.color = myCol)
legend(-0.6,-0.22, cex = 0.7, title="Legenda", legend=unique(pop(lupin_genind)), horiz=F, 
       pch=20, col=rainbow(12), bg="white", pt.cex=0.7, x.intersp=1, y.intersp=0.5)
lupin_genpop<-genind2genpop(lupin_genind)
dystnas_pop<-dist.genpop(lupin_genpop, method = 1, diag = T)
drzewo_popUPGMA<-upgma(dystnas_pop)
plot.phylo(drzewo_popUPGMA, tip.color = color)


hs<-Hs(lupin_genpop)

test_hs<-Hs.test(lupin_genind[pop=1], lupin_genind[pop=2], n.sim = 499)
plot(test_hs)

fstat(lupin_genind)
toto<-gstat.randtest(x=lupin_genind, nsim=999)
toto
toto<-genind2hierfstat(lupin_genind)
head(toto)
varcomp.glob(toto$pop, toto[,-1])
matFst<-pairwise.fst(lupin_genind)
toto<-hw.test(lupin_genind, B=1000)
div<-summary(lupin_genind)

barplot(div$Hexp-div$Hobs, main="Heterozigoty: expected-observed", ylab = "Hexp-Hobs")
plot(div$n.by.pop,div$pop.n.all, main="Allel numbers and simple size", type="n")
bartlett.test(list(div$Hobs, div$Hexp))
t.test(div$Hobs, div$Hexp, pair=T, var.equal = T, alternative = "less")
fstat(lupin_genind)
Gtest<-gstat.randtest(lupin_genind, nsim=999)
plot(Gtest)

div1<-locus_table(lupin_genind)

pca1<-dudi.pca(lupin_genind@tab, center = F, scale = F, scannf = FALSE, nf=4)
kolory<- rainbow(17)
s.class(pca1$li, pop(lupin_genind), col = kolory, sub = "PCA 1-2")
add.scatter.eig(pca1$eig, posi = "bottomright", 2,1,2)

poppr(lupin_genind)

P.tab<- mlg.table(lupin_genind)
info_table(lupin_genind, type = "missing", plot = T)

amovalupin<-poppr.amova(lupin_genind, hier = ~ pochodzenie)
lupingtest<-randtest(amovalupin, nrepet = 99)
plot(lupingtest)

freq <- makefreq(lupin_genind)

