f#===================================PANDAS======================================
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

#-------------------------------------------------------------------------------
## Group by
# To count by a column(CityLocation)
x = df.groupby('CityLocation').size().index
y = df.groupby('CityLocation').size().values
#-------------------------------------------------------------------------------
# Same thing
x = df['CityLocation'].value_counts().index
y = df['CityLocation'].value_counts().values

#-------------------------------------------------------------------------------
# Aggregate by columns
df.groupby('CityLocation').agg({'Date': "count", 'AmountInUSD': 'sum'})

#-------------------------------------------------------------------------------

def add_datepart(df, fldname, drop=True):
    """add_datepart converts a column of df from a datetime64 to many columns containing
    the information from the date. This applies changes inplace.
    Parameters:
    -----------
    df: A pandas data frame. df gain several new columns.
    fldname: A string that is the name of the date column you wish to expand.
        If it is not a datetime64 series, it will be converted to one with pd.to_datetime.
    drop: If true then the original date column will be removed.
    Examples:
    ---------
    >>> df = pd.DataFrame({ 'A' : pd.to_datetime(['3/11/2000', '3/12/2000', '3/13/2000'], infer_datetime_format=False) })
    >>> df
        A
    0   2000-03-11
    1   2000-03-12
    2   2000-03-13
    >>> add_datepart(df, 'A')
    >>> df
        AYear AMonth AWeek ADay ADayofweek ADayofyear AIs_month_end AIs_month_start AIs_quarter_end AIs_quarter_start AIs_year_end AIs_year_start AElapsed
    0   2000  3      10    11   5          71         False         False           False           False             False        False          952732800
    1   2000  3      10    12   6          72         False         False           False           False             False        False          952819200
    2   2000  3      11    13   0          73         False         False           False           False             False        False          952905600
    """
    fld = df[fldname]
    if not np.issubdtype(fld.dtype, np.datetime64):
        df[fldname] = fld = pd.to_datetime(fld, infer_datetime_format=True)
    targ_pre = re.sub('[Dd]ate$', '', fldname)
    for n in ('Year', 'Month', 'Week', 'Day', 'Dayofweek', 'Dayofyear',
            'Is_month_end', 'Is_month_start', 'Is_quarter_end', 'Is_quarter_start', 'Is_year_end', 'Is_year_start'):
        df[targ_pre+n] = getattr(fld.dt,n.lower())
    df[targ_pre+'Elapsed'] = fld.astype(np.int64) // 10**9
    if drop: df.drop(fldname, axis=1, inplace=True)


#-------------------------------------------------------------------------------
from pysqldf import SQLDF; sqldf = SQLDF(globals()); q = getattr(sqldf, 'execute')
import warnings; warnings.filterwarnings('ignore')

# Select or exlcude particular data type of columns in Dataframe
melb_numeric_predictors = melb_predictors.select_dtypes(exclude=['object'])

# Aggregation of same column
df.groupby(['RateCodeID']).agg({'Fare_amount':['mean', 'median']})