library(tidyverse)
library(janitor)
library(ggrepel)

#load data - Day 6, data from Our World In Data(OWID)
proteinsources <- read.csv(file = "~/GitHub/TidyTuesday/ChartChallenge2022/per-capita-sources-of-protein.csv")

proteinsources<-janitor::clean_names(proteinsources)

df1 <- proteinsources %>%
  filter(entity %in% c("United States","France","Spain","United Kingdom","China","Brazil","Japan","South Africa","India","Bangladesh","Kenya","Nigeria"))%>%
  filter(year == "2017")

names(df1)<-c("entity","code","year","plant_protein","meat","eggs","dairy","fish_and_seafood")

df1_long <- df1 %>%
  pivot_longer(df1, 
               cols = c("plant_protein","meat","eggs","dairy","fish_and_seafood"),
               names_to = "food", 
               values_to = "grams_per_capita") #c("plant_protein","meat","eggs","dairy","fish and seafood"))

df1_long$food <- as.factor(df1_long$food)

proteinplot = ggplot(df1_long, aes(x = reorder(entity,grams_per_capita), y = grams_per_capita,fill = food,label = grams_per_capita)) +
  geom_bar(stat = "identity")+
  xlab(" ") + ylab(" ") +
  coord_flip()+
  labs(title = "Per capita sources of protein, 2017",
       subtitle = "Daily protein sources are measured as the average supply of protein, in grams per capita per day.",
       caption = "#30daychartchallenge,Day 6|Data: Our World in Data|viz:Susan Gichuki,@swarau")+
  theme(plot.title = element_text(size = 28, face = "bold"),
        plot.caption = element_text(size = 16),
        legend.position = "top",
        legend.title = element_blank(),
        panel.grid.major.x = element_blank(),
        panel.grid.minor.y = element_line(color = "grey"),
        panel.background = element_rect(fill = "white"),
        axis.line.y.left = element_line(color = "grey"),
        axis.text = element_text(size = 16),)+
  geom_text_repel(position = position_stack(), size = 4)
  
#Save the plot as a PNG file  
ggsave(proteinplot, file = "proteinplot.png",width = 297,height = 210,units = c("mm"),dpi = 300)

