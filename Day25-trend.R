library(tidyverse)
library(scales)
library(lubridate)
library(showtext)

font_add_google(name = "Rubik", family = "Rubik")
font_add_google(name = "Outfit", family = "Outfit")

showtext_auto()


#load data 
embauche <- read.csv(file = "~/GitHub/TidyTuesday/ChartChallenge2022/dpae-mensuelles-france-entiere.csv",sep = ";")

#clean column names
embauche <- janitor::clean_names(embauche)

#rename columns where clean_names did not work, we use column index here, 
# first column is index 1
embauche <- embauche %>% rename(annee = 1,
                                duree_de_contrat = 4)

#convert to factor
embauche$nature_de_contrat <- as.factor(embauche$nature_de_contrat)
embauche$dernier_jour_du_mois <- as.factor(embauche$dernier_jour_du_mois)

#calculate total contracts by date and type of contract
df1 <- embauche %>%
  group_by(dernier_jour_du_mois,nature_de_contrat,annee) %>%
  summarise(dpae_cvs)

#convert the date,month,year column into a date type
df1$dernier_jour_du_mois <-as.Date(df1$dernier_jour_du_mois,format = '%Y-%m-%d')

#df1 %>%
  #mutate(label = if_else(annee == max(annee),as.character(nature_de_contrat),NA_character_))%>%
embauchefrance = ggplot(df1, mapping = aes(x = dernier_jour_du_mois, y = dpae_cvs, color = nature_de_contrat)) +
  geom_line(lwd = 1.0)+
  xlab(" ") + ylab("DPAE(cvs)")+
  labs(title = "Déclarations préalables à l'embauche mensuelles de plus d'un mois, France entière",
       subtitle = "Chiffres corrigés des variations saisonnières(cvs)",
       caption = "#30DayChartChallenge-Day 25-trend|Data: URSSAF| viz: Susan Gichuki@swarau")+
  scale_y_continuous(labels = comma)+
  scale_color_manual(values=c("#00A1F1","#96416B"))+
  geom_vline(xintercept = as.numeric(ymd("2020-03-17")), linetype="dashed", 
             color = "#B1ADAD", size=2.0)+
  annotate("text", x = as.Date("2016-07-30"),y = 110000,label = "Début de confinement", size = 24,color = "#364E77",fontface = "bold")+
  annotate("text", x = as.Date("2002-12-31"),y = 385000,label = "CDD de plus d'un mois",color ="#00A1F1",size = 24)+
  geom_segment(x = as.Date("2000-02-29"), y = 324000, xend = as.Date("2003-12-31"), yend = 383000, arrow = arrow(length = unit(2, "mm")),color = "black")+ #curvature +ve value produces left hand curve;-ve value produces right hand curve
  annotate("text", x = as.Date("2000-01-31"),y = 225000,label = "CDI",color = "#96416B",size = 24)+
  theme(legend.position = "none",
        panel.background = element_rect(fill = "#E6F4F1"),
        plot.background = element_rect(fill = "#E6F4F1"),
        plot.title = element_text(family = "Rubik",size = 54,fontface = "bold"),
        plot.subtitle = element_text(family = "Outfit",size = 54),
        plot.caption = element_text(family = "Outfit",size = 42),
        axis.text = element_text(family = "Outfit",size = 42),
        axis.title = element_text(family = "Outfit",size = 42))

#Save the plot as a PNG file  
ggsave(embauchefrance, file = "embauchefrance.png",width = 297,height = 210,units = c("mm"),dpi = 300)
