library(tidyverse)
library(showtext)
library(grid)
library(cowplot)

font_add_google("Outfit","Outfit")

showtext_auto()

df1 <- readr::read_csv("~/GitHub/TidyTuesday/ChartChallenge2022/death-rates-from-energy-production-per-twh.csv")

#clean column names 
df1 <- janitor::clean_names(df1)

names(df1) <- c("entity","code","year","deaths_per_twh")

mypalette <- c("#C319B1","#0B5D28","#005B40","#984F19","#62466F",
               "#0B5D28","#005B40","#C319B1","#984F19","#62466F")

plot1 = ggplot(df1,aes(x = reorder(entity,deaths_per_twh), y = deaths_per_twh, fill = factor(entity)))+
  geom_bar(stat = "identity")+
  geom_text(aes(label = deaths_per_twh),hjust = -0.2,size = 13.5)+
  coord_flip()+
  xlab(" ") + ylab(" ")+
  labs(title = "Death rates from energy production per TWh",
       subtitle = "Death rates are measured based on deaths from accidents and air pollution per terawatt-hour (TWh).",
       caption = "Source: Markandya & Wilkinson (2007); Sovacool et al. (2016); Our World in Data|#30DayChartChallenge Day 24, theme day Financial Times|viz:Susan Gichuki@swarau")+
  scale_fill_manual(values=mypalette)+
  theme(legend.position = "none",
        plot.background = element_rect(fill = "#FFF0E6"),
        panel.background = element_rect(fill = "#FFF0E6"),
        plot.title = element_text(family = "Outfit",size = 52),
        plot.subtitle = element_text(family = "Outfit",size = 36),
        axis.text = element_text(family = "Outfit",size = 36),
        axis.title = element_text(family = "Outfit",size = 36),
        plot.caption = element_text(size = 30),
        panel.grid = element_line(colour = "grey", linetype = "dashed"),
        panel.grid.major.x = element_blank(),
        panel.grid.major.y = element_blank())

# black box
rect <- rectGrob(
  x = unit(0.75, "in"),
  y = unit(1, "npc"),
  width = unit(1, "in"),
  height = unit(0.05, "in"),
  hjust = 0, vjust = 1,
  gp = gpar(col = "black", fill = "black", alpha = 1)
)

ggdraw(plot1) +
  draw_grob(rect)


#Save the plot as a PNG file  
ggsave(file = "Day24plot.png",width = 297,height = 210,units = c("mm"),dpi = 300)

