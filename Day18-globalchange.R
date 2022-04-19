library(tidyverse)
library(janitor)
library(MetBrewer)
library(ggrepel)
library(patchwork)

#load data 
toxicscanada <- read.csv(file = "~/GitHub/TidyTuesday/ChartChallenge2022/emissions-harmful-substances-air.csv",skip = 2)
globalhg <- read.csv(file ="~/GitHub/TidyTuesday/ChartChallenge2022/world-hg-g-emissions.csv", sep = ";")

#clean the column names of both data frames 
globalhg <- janitor::clean_names(globalhg)
toxicscanada <- janitor::clean_names(toxicscanada)

names(toxicscanada) <- c("year","mercury","lead","cadmium")

# remove rows in r by row number
toxicscanada <- toxicscanada[-c(31:34),]

toxicscanada_long <- toxicscanada %>%
  pivot_longer(toxicscanada,
               cols = c("mercury","lead","cadmium"),
               names_to = "toxics")

toxicscanada_long$toxics <- as.factor(toxicscanada_long$toxics)

toxicscanada_long$year <- as.numeric(toxicscanada_long$year)


toxicsinfo <- str_wrap("Toxic metals can travel long distances in the air, be inhaled, or settle on the ground and in water. There, they can enter the food web and build up in the tissues of living organisms. Exposure to these substances, even in small amounts, can be hazardous to both humans and wildlife.",width = 90)

canadatoxicsplot = toxicscanada_long %>%
mutate(label = if_else(year == max(year),as.character(toxics),NA_character_))%>%
ggplot(mapping = aes(x = year, y = value, color = toxics)) + 
  geom_point(size = 3)+
  geom_line(lwd = 1.3) +
  geom_text_repel(aes(label = label),xlim = c(2021.5, NA))+
  coord_cartesian(clip = "off")+
  scale_x_continuous(expand = c(0, 0),limits = c(1990, 2023.5))+
  scale_color_manual(values=met.brewer("VanGogh2", 3))+
  xlab(" ")+ ylab("percentage")+
  geom_hline(yintercept = 0)+
  annotate("text", x = 2010, y = 11,label = toxicsinfo,lineheight = 0.7,size = 4)+
  labs(title = "Percentage change in air toxics in Canada (1990 - 2020)",
       subtitle = "Evolution of lead,mercury, and cadmium levels")+
  theme(legend.position = "none",   #remove legend because the size will cause an error, fig not generated
        plot.background = element_rect(fill ="#EFEBF5"),
        panel.background = element_rect(fill = "#EFEBF5"),
        axis.text = element_text(size = 16),
        plot.title = element_text(size = 20),
        plot.subtitle = element_text(size = 18),
        axis.title = element_text(size = 18))

#Save the plot as a PNG file  
ggsave(canadatoxicsplot, file = "canadatoxicsplot.png",width = 297,height = 210,units = c("mm"),dpi = 300)


globalhg_long <- globalhg %>%
  pivot_longer(globalhg,
               cols = c("agriculture","buildings","power_industry","transport","waste","other_industrial_combustion","other"),
               names_to = "sector")

#calculate percentages for each sector contributing to emissions
data <- globalhg_long  %>%
  group_by(category, sector) %>%
  summarise(n = sum(value)) %>%
  mutate(percentage = n / sum(n))

#Plot
globalhgplot = ggplot(data, aes(x=category, y=percentage, fill=sector)) + 
  geom_area(alpha=0.6 , size=0.5, colour="black")+
  scale_fill_manual(values=met.brewer("VanGogh2", 8))+ #the chosen palette is color-blind friendly
  xlab(" ")+
  labs(title = "Where do mercury(Hg) emissions come from?", 
       subtitle = "Percent contribution to global Hg emissions by sector(1970-2010)",
       caption = "#30DayChartChallenge|Day 19-global change|Data: Open data Canada|viz:Susan Gichuki@swarau")+
       theme(plot.background = element_rect(fill ="#EFEBF5"),
        panel.background = element_rect(fill = "#EFEBF5"),
        legend.background = element_rect(fill = "#EFEBF5"),
        axis.text = element_text(size = 16),
        plot.title = element_text(size = 20),
        plot.subtitle = element_text(size = 18),
        plot.caption = element_text(size = 14),
        plot.caption.position = "plot",
        axis.title = element_text(size = 18))

patchwork = canadatoxicsplot/globalhgplot 

#Save the plot as a PNG file  
ggsave(patchwork, file = "globaltoxics.png",width = 297,height = 210,units = c("mm"),dpi = 300)


