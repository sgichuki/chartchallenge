# -*- coding: utf-8 -*-
"""
Created on Wed Apr 20 14:29:05 2022

@author: warau
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


#define seaborn background colors
sns.set(rc={'axes.facecolor':'#E6F4F1', 'figure.facecolor':'#A1D9E1'})


#set ci(Confidence Interval to None, other wise it appears by default)
sns.lineplot('year','food_price_volatility_index',ci = None, data = df1)

#data is already in long format so no need to 'melt' or reformat it
plot1 = sns.lineplot('year','food_price_volatility_index', hue = 'country',data = df1)

#put the labels for the X and Y axis
plot1.set(xlabel = " ", ylabel = "food price volatility index")

#put the plot title 
plot1.set_title("Domestic food price volatility index (2000 to 2014)")


#place legend outside top right corner of plot
plot1.legend(bbox_to_anchor=(1.02, 1), loc='upper left', borderaxespad=0)









