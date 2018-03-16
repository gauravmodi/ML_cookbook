#=============================JUPYTER NOTEBOOK==================================
## Progress bar
from tqdm import tqdm_notebook
from time import sleep

for i in tqdm_notebook(range(100)):
	sleep(0.01)
#-------------------------------------------------------------------------------
## matplotlib inline
%matplotlib inline

#-------------------------------------------------------------------------------
## change from scientific notation to decimal point in pandas
pd.set_option('display.float_format', lambda x: '%.0f' % x)

#-------------------------------------------------------------------------------
##
 #Limiting floats output to 3 decimal points
pd.set_option('display.float_format', lambda x: '{:.3f}'.format(x))
#-------------------------------------------------------------------------------
##Ignore warnings
import warnings; warnings.filterwarnings('ignore')

#-------------------------------------------------------------------------------
## Run SQL queries in Pandas
from pysqldf import SQLDF; sqldf = SQLDF(globals()); q = getattr(sqldf, 'execute')
import warnings; warnings.filterwarnings('ignore')

#-------------------------------------------------------------------------------
## Styling tables in Notebook
from IPython.display import HTML

def over_10M(value):
    if value > 10**7:
        color = 'green'
    else:
        color = 'blue'        
    return 'color: %s' % color

df.style.applymap(over_10M, subset=['AmountInUSD'])\
		.format({'AmountInUSD': "$ {:}"})
#-------------------------------------------------------------------------------

