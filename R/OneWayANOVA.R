if (!require("agricolae")) install.packages("agricolae")

library(agricolae)

setwd("./R/Sample_data/")

dane <- read.table("2013_2015.csv", header = T, sep = ",", dec = ".")
dane1 <- stack(dane)
obiekt <- rep(dane$obiekt, 33)
dane1$obiekt <- obiekt
unique(dane1$ind)==colnames(dane)[2:34]


anova_fun <- function(df, cecha){
  df_subset <- subset(df, ind==cecha)
  dfsubset_m <- tapply(df_subset$values, df_subset$obiekt, mean, na.rm = TRUE)
  df_aov <- aov(df_subset$values~df_subset$obiek)
  print(summary(df_aov))
  nazwa <- paste("ANOVA", g, sep = "_")
  nazwa <- paste(nazwa,"txt", sep = ".")
  sciezka <- paste("ANOVA",nazwa, sep = "/")
  capture.output(summary(df_aov),file=sciezka)
  PH.aov.df_1 <- TukeyHSD(df_aov)
  PH.aov.df_2 <- HSD.test(df_aov, trt = 'df_subset$obiek', alpha = 0.05)
  PH.aov.df_2gr <- PH.aov.df_2$groups
  PH.aov.df_2gr <- PH.aov.df_2gr[order(PH.aov.df_2gr$trt),]
  colnazwy <- paste(c("trt", "means", "M"), cecha, sep = "_")
  means <- PH.aov.df_2gr$means
  M <- PH.aov.df_2gr$M
  colnazwy2 <- colnazwy[2]
  colnazwy3 <- colnazwy[3]
  anova_out[colnazwy2] <<- means
  anova_out[colnazwy3] <<- M
}

gg <- unique(dane1$ind)
anova_out <- data.frame(matrix(NA, nrow = 75))
for (g in gg){
  print(g)
  anova_fun(dane1, cecha = g)
}

dane1sub <- subset(dane1, ind==g)
dane1sub_aov <- aov(dane1sub$values~dane1sub$obiekt)
PH.aov.df_2 <- HSD.test(dane1sub_aov, trt = "dane1sub$obiek", alpha = 0.05)
e <- PH.aov.df_2$groups


ee <- e[order(e$trt),]
dd <- ee$trt
anova_out$matrix.NA..nrow...75.<- dd 
cc <- colnames(anova_out)
cc[1] <- "obiekt"
colnames(anova_out) <- cc

write.csv2(anova_out, "anova_out.csv")
