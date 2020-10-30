import pandas as pd

#load the data from the csv file
data = pd.read_csv("userReviews.csv", sep=";")

#create the subset with the reviews for my movie 
subset = data[data.movieName == 'iron-man' ]

#create the dataframe for the relative and the absulute scores
recommendations = pd.DataFrame(columns=data.columns.tolist()+['rel_inc','abs_inc'])

#look for the users that gave a ranking to my movie
for idx, Author in subset.iterrows():
    
    #save all the authors and their ranking 
    author = Author[['Author']].iloc[0]
    ranking = Author[['Metascore_w']].iloc[0]
    
    #make a new dataframe that includes the movies that are ranked by the selected authors
    #and also have a higher ranking than my movie and also calculate the relative/absolute ranking increase 
    filter1 = (data.Author==author)
    filter2 = (data.Metascore_w>ranking)
    
    #get the possible recommendations and calculate the score 
    possible_recommendations = data[filter1 & filter2]
    
    possible_recommendations.loc[:,'rel_inc'] = possible_recommendations.Metascore_w/ranking
    possible_recommendations.loc[:,'abs_inc'] = possible_recommendations.Metascore_w - ranking
    
    #append to the recommendations dataframe 
    recommendations = recommendations.append(possible_recomendations)
    
    #sort the recommendations based on the relative score first and then the absolute score
    recommendations = recommendations.sort_values(['rel_inc','abs_inc'], ascending=False
    
    #remove the duplicates
    recommendations = recommendations.drop_duplicates(subset='movieName', keep="first")                                             
    
    #make the csv and print the first 50 recommendations                                           
    recommendations.head(50).to_csv("recommendationsBasedOnMetascorePython.csv", sep=";", index=False)
    Print(recommendations.head(50))
    Print(recommendations.shape)
                                                  
                                                 
    
    
    
