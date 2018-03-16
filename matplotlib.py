#===============================================================================
#							    	 PLOTS                                     #
#===============================================================================

## Basic Line Plot
plt.plot(x, y, color='b')

#-------------------------------------------------------------------------------
## Scatter Plot
plt.scatter(x = x, y = y, s = size_array, c = col_array, alpha = 0.8)
# Note: size and color array should be of same length or length = 1

#-------------------------------------------------------------------------------
## if any axis values range is too large from 1 to billions then we can take
## log of that axis values and scale it down.
plt.xscale('log') # plt.yscale('log')

#-------------------------------------------------------------------------------
## Histogram with 20 bins
plt.hist(x, bins=20)

#-------------------------------------------------------------------------------
## Show and clean up again. NOT REQUIRED with Jupyter notebook
plt.show()
plt.clf()

#===============================================================================
#								 PLOT CUSTOMIZATION                            #
#===============================================================================
## Add axis labels
plt.xlabel('X-label')
plt.ylabel('y-label')
plt.title('title')

#-------------------------------------------------------------------------------
## All of the rc settings are stored in a dictionary-like variable called
## matplotlib.rcParams, which is global to the matplotlib package.
plt.rcParams['figure.figsize'] = (5.0, 4.0) # set default size of plots

#-------------------------------------------------------------------------------
# Set the x-axis range
plt.xlim([1990, 2010])
# Set the y-axis range
plt.ylim([0, 50])
# Set the x-axis and y-axis limits AT ONCE
plt.axis([1990, 2010, 0, 50])
# Angle of xticks
plt.xticks(rotation=45);

#-------------------------------------------------------------------------------
## Definition of tick_val and tick_lab
tick_val_x = [1000,10000,100000] # only show this values in axis
tick_lab_x = ['1k','10k','100k'] # change above ticks to these values. As you can think length of array should be same.

# Adapt the ticks on the x-axis
plt.xticks(tick_val_x, tick_lab_x)
plt.yticks(tick_val_y, tick_lab_y)

#-------------------------------------------------------------------------------
# Specify the label 'Computer Science'
plt.plot(x1, y1, color='red', label='Label1')

# Specify the label 'Physical Sciences'
plt.plot(x2, y2, color='blue', label='Label2')

# Add a legend at the lower center
plt.legend(loc='lower center')

#-------------------------------------------------------------------------------
# Add a black arrow annotation
# Compute the maximum y: y_max
y_max = y.max()

# Calculate the x in which y was max
x_max = x[y.argmax()] # x value when y is max

plt.annotate(s='Y Maximum', xy=(x_max, y_max),
			 xytext=(x_max+5, y_max+5),
			 arrowprops=dict(facecolor='black'))

#-------------------------------------------------------------------------------
## Add text to plot
plt.text(x_cordinate, y_cordinate, 'test-text')

#-------------------------------------------------------------------------------
# Set the style to 'ggplot'
plt.style.use('ggplot')

#-------------------------------------------------------------------------------
## Add grid() call to show grid lines but depend on style also.
plt.grid(True)

#===============================================================================
#								 SUBPLOTS                                      #
#===============================================================================
## Using Axes to show multiple plots at once
plt.axes([0.05, 0.05, 0.425, 0.9])

# Plot in blue the % of degrees awarded to women in the Physical Sciences
plt.plot(year, physical_sciences, color='blue')

# Create plot axes for the second line plot
plt.axes([0.525, 0.05, 0.425, 0.9])

# Plot in red the % of degrees awarded to women in Computer Science
plt.plot(year, computer_science, color='red')

#-------------------------------------------------------------------------------
## Multiple Subplots using subplot method
# Create a figure with 1x2 subplot and make the left subplot active
plt.subplot(1, 2, 1)
# Plot in blue the % of degrees awarded to women in the Physical Sciences
plt.plot(x1, y1, color='blue')
plt.title('Plot 1')

# Make the right subplot active in the current 1x2 subplot grid
plt.subplot(1, 2, 2)

# Plot in red the % of degrees awarded to women in Computer Science
plt.plot(x2, y2, color='red')
plt.title('Plot 2')

#-------------------------------------------------------------------------------
## Use plt.tight_layout() to improve the spacing between subplots
plt.tight_layout()

#===============================================================================
#								 MISCELLANEOUS                                 #
#===============================================================================
# Save the image as 'xlim_and_ylim.png'
plt.savefig('xlim_and_ylim.png')
# Annotate a text for maximum value
# Creating a histogram table in numpy
hist_series = np.histogram(df.AmountInUSD[df.AmountInUSD< 10**6].dropna(), bins=50)
x_value = hist_series[1][np.argmax(hist_series[0])]
y_value = hist_series[0][np.argmax(hist_series[0])]
# Drawing histogram using function and annotate max value we got from numpy histogram table
ax = histogram(df.AmountInUSD, upper=10**6, hist=True, kde=False, bins=50)
ax.annotate(x_value, xy=(x_value, y_value), xytext=(700000, 80),
            arrowprops=dict(facecolor='black', shrink=0.05));

