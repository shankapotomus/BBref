library(htmltab)
library(sqldf)
library(plyr)

stats0 <- ""
draftbank0 <- ""

for (i in 2007:2017){
  
  
  url <- paste0("http://www.basketball-reference.com/leagues/NBA_",i, "_advanced.html")
  stats <- htmltab(doc = url, which = 1, header = 1, stringsasfactors = FALSE)
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
                      "OWS",
                      "DWS",
                      "WS",
                      "WS48",
                      "OBPM",
                      "DBPM",
                      "BPM",
                      "VORP",
                      "Year")

fixedstats <- sqldf("SELECT Rank, Player, Pos, Age, Tm, G, MP, PER, TSp, ThreePAr, FTr, ORBp, DRBp, TRBp, ASTp, STLp, BLKp, TOVp, 
USGp, OWS, DWS, WS, WS48, OBPM, DBPM, BPM, VORP, Year FROM stats0 WHERE player != 'Player'")

fixedstats <- fixedstats[-1,]


for (i in 1990:2016){
  
  
  url2 <- paste0("http://www.basketball-reference.com/draft/NBA_",i,".html")
  draftbank <- htmltab(doc = url2, which = 1, header = 1, stringsasfactors = FALSE)
  draftbank$year <- i
  
  draftbank0 <- rbind(draftbank0,draftbank)
  
  
}

colnames(draftbank0) <- c("Pick", "Pick2","Tm",	"Player",	"College","Years", "G",	"MP",	"PTS","TRB",	"AST",	"FGp",	"ThreeP",	"FT",	"MPg", "PPG",	"RPG",	"APG",	"WS",	"WS48",	"BPM", "VORP", "DraftYear")

draftbankfinal <- sqldf("SELECT Player,	College, DraftYear FROM draftbank0 WHERE G != 'Totals'")

draftbankfinal <- draftbank0[-1,]

df <- merge(x = fixedstats, y = draftbankfinal, by = "Player", all.x = TRUE)
df2 <- df[c(1,3:5,8,22,28,50)]

colnames(df2) <- c("Player", "Pos", "Age", "Team", "PER", "WS","Year", "Draft_Year")

df2$Year <- as.numeric(df2$Year)
df2$Draft_Year <- as.numeric(df2$Draft_Year)

df2$Years_Pro <- df2$Year - df2$Draft_Year

