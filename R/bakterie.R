if (!require("DECIPHER")) {
  source("https://bioconductor.org/biocLite.R")
  biocLite("DECIPHER")
}

if (!require("ade4")) install.packages("ade4")
if (!require("ape")) install.packages("ape")
if (!require("pegas")) install.packages("pegas")


library(DECIPHER)
library(ade4)
library(ape)
library(pegas)


setwd("./R/Sample_data/")

fas_bakterie <- "bakterie.fasta"
dna <- readDNAStringSet(fas_bakterie)
DNA <- AlignSeqs(dna)
DNA1 <- as.DNAbin(DNA)
DNA_dyst <- dist.dna(DNA1, model = "K80")
drzewo1 <- nj(DNA_dyst)
plot.phylo(drzewo1, main = "NJ Tree")
add.scale.bar(0,0)
boot_fun<-function(x){nj(dist.dna(x, model = "K80"))}
boot<-boot.phylo(drzewo1, as.matrix(DNA1), boot_fun)
nodelabels(boot, frame = "n", cex=0.8)
