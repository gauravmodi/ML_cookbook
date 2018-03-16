color = sns.color_palette()

## 2D histogram
# Generate a 2-D histogram
plt.hist2d(x, y, bins=(20, 20), range=((40, 235),(8, 48)))

## Add a color bar to the histogram
plt.colorbar()

## Generate a 2d histogram with hexagonal bins 
# Gridsize is little complicate thing
# Extent is x and y axis ticks limits 
plt.hexbin(x, y, gridsize=(15,12), extent=((40, 235,8, 48)))


def histogram(x, bins=None, hist=False, kde=True, color='r', xlabel=None, ylabel='', title='', lower=-1*np.inf, upper=np.inf, figsize=(8, 5)):
    plt.subplots(figsize=figsize)
    sns.distplot(x.dropna()[(x > lower) & (x < upper)], bins=bins,
                 hist=hist, kde=kde, 
                 kde_kws={"shade": True}, 
                 color=color, axlabel=xlabel)
    plt.title(title)
    plt.ylabel(ylabel)

# Return axes
def histogram(x, bins=None, hist=False, kde=True, color='r', xlabel=None, ylabel='', title='', lower=-1*np.inf, upper=np.inf, figsize=(8, 5)):
    fig, ax = plt.subplots(figsize=figsize)
    sns.distplot(x.dropna()[(x > lower) & (x < upper)], bins=bins,
                 hist=hist, kde=kde, 
                 kde_kws={"shade": True}, 
                 color=color, axlabel=xlabel, )
    plt.title(title)
    plt.ylabel(ylabel)
    return ax

def barplot(x_data, y_data, figsize=(8, 5), x_label="", y_label="", title=""):
    _, ax = plt.subplots(figsize=figsize)
    # Draw bars, position them in the center of the tick mark on the x-axis
    ax.bar(x_data, y_data, color = '#539caf', align = 'center',)
    ax.set_ylabel(y_label)
    ax.set_xlabel(x_label)
    ax.set_title(title)


def scatterplot(x_data, y_data, x_label="", y_label="", title="", color = "r", yscale_log=False):

    # Create the plot object
    _, ax = plt.subplots()

    # Plot the data, set the size (s), color and transparency (alpha)
    # of the points
    ax.scatter(x_data, y_data, s = 10, color = color, alpha = 0.75)

    if yscale_log == True:
        ax.set_yscale('log')

    # Label the axes and provide a title
    ax.set_title(title)
    ax.set_xlabel(x_label)
    ax.set_ylabel(y_label)
 
def lineplot(x_data, y_data, x_label="", y_label="", title=""):
    # Create the plot object
    _, ax = plt.subplots()

    # Plot the best fit line, set the linewidth (lw), color and
    # transparency (alpha) of the line
    ax.plot(x_data, y_data, lw = 2, color = '#539caf', alpha = 1)

    # Label the axes and provide a title
    ax.set_title(title)
    ax.set_xlabel(x_label)
    ax.set_ylabel(y_label)




def boxplot(x_data, y_data, base_color="#539caf", median_color="#297083", x_label="", y_label="", title=""):
    _, ax = plt.subplots()

    # Draw boxplots, specifying desired style
    ax.boxplot(y_data
               # patch_artist must be True to control box fill
               , patch_artist = True
               # Properties of median line
               , medianprops = {'color': median_color}
               # Properties of box
               , boxprops = {'color': base_color, 'facecolor': base_color}
               # Properties of whiskers
               , whiskerprops = {'color': base_color}
               # Properties of whisker caps
               , capprops = {'color': base_color})

    # By default, the tick label starts at 1 and increments by 1 for
    # each box drawn. This sets the labels to the ones we want
    ax.set_xticklabels(x_data)
    ax.set_ylabel(y_label)
    ax.set_xlabel(x_label)
    ax.set_title(title)

# Time series plot
def time_plot(x, y, xlabel='', ylabel='', title=''):
	plt.figure(figsize=(10, 8))
	plt.plot(cars['Date'], cars['gm_cap'], 'b-', label = 'GM')
	plt.plot(cars['Date'], cars['tesla_cap'], 'r-', label = 'TESLA')
	plt.xlabel('Date'); 
	plt.ylabel('Market Cap (Billions $)'); 
	plt.title('Market Cap of GM and Tesla')
	plt.legend();