import pandas as pd

#load the data
data = pd.read_csv("userReviews.csv", sep=";")
print(data.head())

#
#












#
subset = data[data.movieName == 'iron-man' ]

#
recommendations = pd.DataFrame(columns=data.columns.tolist()+['rel_inc','abs_inc'])

#
for idx, Author in subset.iterrows():
    #print(Author)
    #
    author = Author[['Author']].iloc[0]
    ranking = Author[['Metascore_w']].iloc[0]
    #
    #
    #
    #
    filter1 = (data.Author==author)
    filter2 = (data.Metascore_w>ranking)
    
    #
    possible_recommendations = data[filter1 & filter2]
    
    #print(possible_recommendations.head())
    
    possible_recommendations.loc[:,'rel_inc'] = possible_recommendations.Metascore_w/ranking
    possible_recommendations.loc[:,'abs_inc'] = possible_recommendations.Metascore_w - ranking
    
    
