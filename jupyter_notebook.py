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
##


#-------------------------------------------------------------------------------
##



