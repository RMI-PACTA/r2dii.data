library(readr)
library(tidyverse)


load(paste0(getwd(),"/data/sector_classifications.rda"))


isic_classification <- read_csv("data-raw/isic_classification.csv")%>%
  mutate(sector=ifelse(sector=="automotive", "ldv", sector))
# Source for ISIC classification: https://unstats.un.org/unsd/publication/seriesm/seriesm_4rev4e.pdf


isic_classification_auto<- isic_classification%>%
  filter(sector=="ldv")%>%
  mutate(sector="hdv")

isic_classification<-isic_classification%>%
  rbind(isic_classification_auto)

isic_classification%>%
  write.csv("data-raw/isic_classification.csv")

naics_classification <- read_csv("data-raw/naics_classification.csv")%>%
  mutate(sector=ifelse(naics_title=="automobile manufacturing", "ldv", sector))%>%
  mutate(sector=ifelse(naics_title=="light truck and utility vehicle manufacturing", "ldv", sector))%>%
  mutate(sector=ifelse(naics_title=="heavy duty truck manufacturing", "hdv", sector))

naics_classification_auto <-naics_classification %>%
  filter(naics_title %in% c("automobile manufacturing","light truck and utility vehicle manufacturing"))%>%
  mutate(sector="hdv")

naics_classification <-naics_classification %>%
  rbind(naics_classification_auto)

write.csv(naics_classification, "data-raw/naics_classification.csv")

#  list of NACE code: https://ec.europa.eu/competition/mergers/cases/index/nace_all.html
nace_classification <- read_csv("data-raw/nace_classification.csv")%>%
  mutate(sector="ldv")

nace_classification_auto<-nace_classification%>%
  mutate(sector="hdv")

nace_classification<-nace_classification%>%
  rbind(nace_classification_auto)

write.csv(nace_classification, "data-raw/nace_classification.csv")


gics_classification <- read_csv("data-raw/gics_classification.csv")%>%
  mutate(sector=ifelse(sector=="automotive", "ldv", sector))%>%
  mutate(sector=ifelse(description=="construction machinery & heavy trucks", "hdv", sector))

gics_classification_auto<-gics_classification%>%
  filter(sector=="ldv")%>%
  mutate(sector="hdv")

gics_classification<-gics_classification%>%
  rbind(gics_classification_auto)

write.csv(gics_classification, "data-raw/gics_classification.csv")

psic_classification <- read_csv("data-raw/psic_classification.csv")%>%
  mutate(sector=ifelse(sector=="automotive", "ldv", sector))%>%
  mutate(sector=ifelse(original_code=="Freight transport operation, by road, n.e.c.", "hdv", sector))%>%
  mutate(sector=ifelse(original_code=="Freight truck operation", "hdv", sector))%>%
  mutate(sector=ifelse(original_code=="Freight terminal facilities for trucking companies", "hdv", sector))


psic_classification_auto<-psic_classification%>%
  filter(sector=="ldv")%>%
  mutate(sector="hdv")

psic_classification<-psic_classification%>%
  rbind(psic_classification_auto)

write.csv(psic_classification, "data-raw/psic_classification.csv")

#sic has not categories that would only suits to hdv

sic_classification <- read_csv("data-raw/sic_classification.csv")%>%
  mutate(sector=ifelse(sector=="automotive", "ldv", sector))

sic_classification_auto<-sic_classification%>%
  filter(sector=="ldv")%>%
  mutate(sector="hdv")


sic_classification<-sic_classification%>%
  rbind(sic_classification_auto)


write.csv(sic_classification, "data-raw/isic_classification.csv")

# where this classification come from?
cnb_classification <- read_csv("data-raw/cnb_classification.csv")

cnb_classification_auto<-cnb_classification%>%
  filter(sector=="ldv")%>%
  mutate(sector="hdv")


cnb_classification<-cnb_classification%>%
  rbind(cnb_classification_auto)

write.csv(cnb_classification, "data-raw/cnb_classification.csv")


cnb_classification<-cnb_classification%>%
  select("sector","borderline","code")%>%
  mutate(code_system="CNB")

gics_classification<-gics_classification%>%
  select("sector","borderline","code")%>%
  mutate(code_system="GICS")

isic_classification<-isic_classification%>%
  select("sector","borderline","code")%>%
  mutate(code_system="ISIC")

nace_classification<-nace_classification%>%
  select("sector","borderline","code")%>%
  mutate(code_system="NACE")

naics_classification<-naics_classification%>%
  select("sector","borderline","code")%>%
  mutate(code_system="NAICS")

psic_classification<-psic_classification%>%
  select("sector","borderline","code")%>%
  mutate(code_system="PSIC")

sector_classification<-rbind(cnb_classification, gics_classification, isic_classification, nace_classification, naics_classification, psic_classification)%>%
  saveRDS("data/sector_classifications.rda")

