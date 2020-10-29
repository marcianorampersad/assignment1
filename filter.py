import pandas as pd

#data is dataframe
data = pd.read_csv('userReviews.csv',sep=';')

print(data.head())
print(data[:3])
print(data.movieName.iloc[1])

column_names = ['movieName', 'Metascore_w','Author', 'AuthorHref', 'Date', 'Summary', 'InteractionsYesCount', 'InteractionsTotalCount', 'InteractionsThumpUp', 'InteractionsThumpDown']
subset = pd.DataFrame(columns = column_names)

for movie in range(100):
    if data.movieName.iloc[movie] == 'beach-rats':
        row=data[movie:movie + 1]
        print(row)
        subset = subset.append(row) #edit
        
#edit
print(subset.head())