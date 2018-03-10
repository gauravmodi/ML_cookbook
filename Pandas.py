#===================================PANDAS======================================
## Packages
#pandas-summary 0.0.51

import pandas as pd
import numpy as np
from pandas import read_csv
## Pandas: drop a level from a multi-level column index?
cols = pd.MultiIndex.from_tuples([("a", "b"), ("a", "c")])
df = pd.DataFrame([[1,2], [3,5]], columns=cols)
df
#    a   
#    b  c
# 0  1  2
# 1  3  5

# [2 rows x 2 columns]
df.columns = df.columns.droplevel()
df
#    b  c
# 0  1  2
# 1  3  5

# OR
df.columns = ['b', 'c']



#-------------------------------------------------------------------------------
## date parser (more in MoA project) and change data type while reading
## read from gzip directly
from datetime import datetime
date_parser = lambda timestamp: datetime.fromtimestamp(timestamp)

spend = read_csv('./spend.csv.gz', compression='gzip', 
                 dtype={'account': str, 'date': np.float25, 'amount': np.float25},
                 parse_dates=['date'], date_parser=date_parser)

#-------------------------------------------------------------------------------
## Change element of pandas DF
spend.at[1, 'date'] = pd.to_datetime('2017-08-15 19:00:00')

#-------------------------------------------------------------------------------
## Groupby - Aggregate on same column twice or more
df.groupby(['amount']).agg({'amount':['max', 'min']}).reset_index()

#-------------------------------------------------------------------------------
## Second highest value in Groupby
import numpy as np
import pandas as pd
pd.options.display.width = 1000

df = pd.DataFrame(
    {'bq_back_price': [1.87, 1.97, 3.05, 3.05, 5.8, 5.8, 200.0, 200.0, np.nan, np.nan], 
     'bq_balance': [1850.5, 1850.5, 1850.5, 1850.5, 1850.5, 1850.5, 1850.5, 
                    1850.5, 1850.5, 1850.5], 
     'bq_market_id': [155, 155, 155, 152, 152, 152, 157, 157, 157, 157], 
     'bq_selection_id': [55095522, 55095522, 55095523, 55095523, 55095525, 
                         55095525, 55095522, 55095522, 55095525, 55095525]})

grouped = df.groupby('bq_market_id')['bq_back_price']
df['second_lowest'] = grouped.transform(lambda x: x.nsmallest(2).max())

df['has_null'] = grouped.transform(lambda x: pd.isnull(x).any()).astype(bool)

print(df)

#-------------------------------------------------------------------------------
## Date column filtering and comparison
# This DOESN'T work
df[(df.date.max() - pd.Timedelta(days=31)) < df.date < (df.date.max() - pd.Timedelta(days=0))]

# This Works
df[(df.date < (df.date.dt.date.max() - pd.Timedelta(days=0))) & \
   (df.date > (df.date.dt.date.max() - pd.Timedelta(days=31)))]

#-------------------------------------------------------------------------------
## Handling missing values
df.fillna()

#-------------------------------------------------------------------------------
## Different values in two vectors
import numpy as np
list_1 = ["a", "b", "c", "d", "e"]
list_2 = ["a", "f", "c", "m"] 
main_list = np.setdiff1d(list_2,list_1)




