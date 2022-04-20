# -*- coding: utf-8 -*-
"""
Created on Wed Apr 20 14:29:05 2022

@author: sgichuki
"""

import matplotlib.pyplot as plt 
import numpy as np
import pandas as pd 
import seaborn as sns

df_foodpricevolatility = pd.read_csv(r'C:\Users\warau\Documents\GitHub\TidyTuesday\ChartChallenge2022\domestic-food-price-volatility-index.csv')

#rename all columns
df_foodpricevolatility.columns = ['country','code','year','food_price_volatility_index']


#create a list to use for filtering for the countries you want featured
filterlist = ['India','Canada','World','South Africa','Kenya','Germany','France','Brazil','Haiti','United States'] 

#use the isin function to filter based on the list 
df1 = df_foodpricevolatility[df_foodpricevolatility.country.isin(filterlist)]

#set the size of the plot 
sns.set(rc = {'figure.figsize':(15,8)})
sns.set(font_scale = 20)


#define seaborn background colors
sns.set(rc={'axes.facecolor':'#E6F4F1', 'figure.facecolor':'#A1D9E1'})


#set ci(Confidence Interval to None, other wise it appears by default)
sns.lineplot('year','food_price_volatility_index',ci = None, data = df1)

#data is already in long format so no need to 'melt' or reformat it
plot1 = sns.lineplot('year','food_price_volatility_index', hue = 'country',data = df1)

#put the labels for the X and Y axis
#plot1.set(xlabel = " ", ylabel = "food price volatility index")

#specify the labels and the font size for each
plot1.set_xlabel(" ", fontsize = 20)
plot1.set_ylabel("food price volatility index", fontsize = 20)

# Add suptitle above the title
plt.suptitle("Domestic food price volatility index (2000 to 2014)\n", fontsize=26,y = 1.02,color="#0059A9",style = "italic")
#put the plot title 
plot1.set_title("Domestic food price volatility index measures the variation (volatility) in domestic food prices over time -\nthis is measured as the weighted-average of a basket of commodities based on consumer or market prices.\nHigh values indicate a higher volatility (more variation) in food prices.",fontsize = 16)



#modify individual font size of elements
#place legend outside top right corner of plot
#plot1.legend(fontsize=18)
plot1.legend(bbox_to_anchor=(1.02, 1), loc='upper left', borderaxespad=0,fontsize = 18)
plot1.tick_params(axis='both', which='major', labelsize=16)









