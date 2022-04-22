# -*- coding: utf-8 -*-
"""
Created on Thu Apr 21 14:11:00 2022

@author: sgichuki
"""

import pandas as pd 
import seaborn as sns
import matplotlib.pyplot as plt

 

alternativefuel = pd.read_excel(r'C:\Users\warau\Documents\GitHub\TidyTuesday\ChartChallenge2022\alternative_fuel_inventory.xlsx')

#remove rows with descriptive text at the bottom
# Delete some chosen rows by row numbers 13th to 27th, and the first column index 0:
alternativefuel.drop(alternativefuel.columns[[0]], axis = 1, inplace = True)
    
alternativefuel = alternativefuel.drop(alternativefuel.index[[0,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27]]) 

#rename columns 
alternativefuel.columns = ['fuel','2004','2005','2006','2007','2008','2009','2010','2011','2012','2013','2014','2015','2016','2017','2018','2019','2020']
#remove na values
alternativefuel = alternativefuel.dropna()

#subset dataframe to remove rows you don't need
alternativefuel = alternativefuel.loc[2:9]

#make list of colums you need - will be used in two instances below
yearlylist = alternativefuel.columns[1:16]

#use the list when reshaping the dataframe to long format from wide format 
alternativefuel_long = pd.melt(alternativefuel, id_vars = ['fuel'],value_vars = yearlylist)

alternativefuel_long.columns = ['fuel','year','vehicles']

plt.figure(figsize=(15, 8))
sns.barplot(x="year", 
            y="vehicles", 
            hue="fuel", 
            data=alternativefuel_long)

plt.ylabel("vehicles",size = 18)
plt.xlabel(" ", size = 18)
plt.title("Clean Cities Alternative Fuel Vehicle Inventory", size=20)
plt.savefig("alternativefuelvehicles.png")

#calculate percent change between columns. You need to set the first column as index
#because it contains characters
df_pctchange = alternativefuel.set_index('fuel').pct_change(axis=1)*100
df_pctchange['2004'] = df_pctchange['2004'].fillna(0)

#reset the fuel column to an index in the new dataframe
df_pctchange = df_pctchange.reset_index(level=0)

#subset the dataframe to include only those fuels you want 
df_pctchange = df_pctchange.iloc[[0,1,4,7]]

df_pctchange_long = pd.melt(df_pctchange, id_vars = ['fuel'],value_vars = yearlylist)


plt.figure(figsize=(15, 8))
sns.barplot(x="variable", 
             y="value", 
             hue="fuel", 
             data=df_pctchange_long)

df_pctchange_long.columns = ['fuel','year','percent change']

#Set the size of the plot you will create
plt.figure(figsize=(15, 8))

# Create a grid : initialize it - seaborn library used here 
g = sns.FacetGrid(df_pctchange_long, col='fuel', hue='fuel', col_wrap=2,)

# Add the line over the area with the plot function
g.map(plt.plot, 'year', 'percent change')
 
# Fill the area with fill_between
g = g.map(plt.bar, 'year', 'percent change', alpha=0.2).set_titles("{col_name} fuel")

# Control the title of each facet
g = g.set_titles("{col_name}")
g.set_xticklabels(rotation=45,fontweight='light',fontsize='x-large')

# Add a title for the whole plot
plt.subplots_adjust(top=0.87)
g = g.fig.suptitle('Change in green cities alternative fuels inventory',fontsize = 16.5)


# Save the graph
plt.savefig("alternativefuel_percentchange.png")




 

