library(htmltab)

stats0 <- ""

for (i in 2014:2017){


url <- paste0("http://www.basketball-reference.com/leagues/NBA_",i, "_advanced.html")
stats <- htmltab(doc = url, which = 1, header = 1)

stats0 <- merge(stats0,stats)

}