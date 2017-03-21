library(htmltab)
library(sqldf)
library(plyr)

stats0 <- ""
draftbank0 <- ""

for (i in 2014:2017){
  
  
  url <- paste0("http://www.basketball-reference.com/leagues/NBA_",i, "_advanced.html")
  stats <- htmltab(doc = url, which = 1, header = 1)
  stats$year <- i
  
  stats0 <- rbind(stats0,stats)
  
  stats0[rowSums(is.na(stats0)) != ncol(stats0),]
  
}

colnames(stats0) <- c("Rank",
                      "Player",
                      "Pos",
                      "Age",
                      "Tm",
                      "G",
                      "MP",
                      "PER",
                      "TSp",
                      "ThreePAr",
                      "FTr",
                      "ORBp",
                      "DRBp",
                      "TRBp",
                      "ASTp",
                      "STLp",
                      "BLKp",
                      "TOVp",
                      "USGp",
                      "Null",
                      "OWS",
                      "DWS",
                      "WS",
                      "WS48",
                      "Null2",
                      "OBPM",
                      "DBPM",
                      "BPM",
                      "VORP",
                      "Year")

fixedstats <- sqldf("SELECT Rank, Player, Pos, Age, Tm, G, MP, PER, TSp, ThreePAr, FTr, ORBp, DRBp, TRBp, ASTp, STLp, BLKp, TOVp, 
USGp, OWS, DWS, WS, WS48, OBPM, DBPM, BPM, VORP, Year FROM stats0 WHERE player != 'Player'")

fixedstats <- fixedstats[-1,]


for (i in 2015:2016){
  
  
  url2 <- paste0("http://www.basketball-reference.com/draft/NBA_",i,".html")
  draftbank <- htmltab(doc = url2, which = 1, header = 1)
  draftbank$year <- i
  
  draftbank0 <- rbind(draftbank0,draftbank)
  
  
}

colnames(draftbank0) <- c("Tm",	"Player",	"College","G",	"MP",	"PTS","TRB",	"AST",	"FGp",	"ThreeP",	"FT",	"MPg", "PPG",	"RPG",	"APG",	"WS",	"WS48",	"BPM", "VORP", "DraftYear")

draftbankfinal <- sqldf("SELECT Player,	College, DraftYear FROM draftbank0 WHERE G != 'Totals'")

draftbankfinal <- draftbank0[-1,]
