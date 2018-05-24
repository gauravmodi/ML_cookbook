color = sns.color_palette()

#==================================Seaborn======================================
## Scatter plot
sns.lmplot(x="amount_sum", y="count_sum", data=df, 
		   hue='churn', scatter_kws={'alpha': 0.4})

# optional argument for lmplot to change line color: line_kws={'color':'red'}
# BUT then hue categories will have same color
#-------------------------------------------------------------------------------
## Box Plot
fig, ax = plt.subplots(1, 1)
boxplot = sns.boxplot(x=spend_counts_groupby_account.amount, orient='v')


#-------------------------------------------------------------------------------
## Univariante distribution
sns.distplot(spend.amount, hist=False, color="g", kde_kws={"shade": True})

#-------------------------------------------------------------------------------
## Plot a linear regression between 'weight' and 'hp'
# hue to group data, and palette to select color theme
sns.lmplot(x='weight', y='hp', data=auto, hue='origin', palette='Set1')

# Plot linear regressions grouped row-wise by 'origin' column of auto df
sns.lmplot(x='weight', y='hp', data=auto, row='origin')

#-------------------------------------------------------------------------------
## Generate a green residual plot of the regression between 'hp' and 'mpg'
sns.residplot(x='hp', y='mpg', data=auto, color='green')

#-------------------------------------------------------------------------------
## Plot in green a linear regression of order 2 between 'weight' and 'mpg'
sns.regplot(x='weight', y='mpg', data=auto, color='green', scatter=None, order=2, label='order 2')

#-------------------------------------------------------------------------------
##
## Univariante Distribution
# jitter tp spread the data points instead of overlap
sns.stripplot(x='cyl', y='hp', data=auto, size=3, jitter=True)

# doesn't overlap the data points
sns.swarmplot(x='hp', y='cyl', data=auto, hue='origin', orient='h')

## Violin plot
sns.violinplot(x='cyl', y='hp', data=auto)

## Violin + strip plot inside it
sns.violinplot(x='cyl', y='hp', data=auto, color='lightgray', inner=None)

# Overlay a strip plot on the violin plot
sns.stripplot(x='cyl', y='hp', data=auto, jitter=True, size=1.5)

## Multivariate Plots
sns.jointplot(x='hp', y='mpg', data=auto)

# kind = 'scatter', 'reg', 'resid', 'kde', 'hex'
sns.jointplot(x='hp', y='mpg', data=auto, kind='hex')


# Pair plot of all numeric variables in dataframe
sns.pairplot(auto)
sns.pairplot(data=auto, hue='origin', kind='reg')

# Visualize the covariance matrix using a heatmap
# Note: cov_matrix is covariance matrix
corrmat = train.corr()
plt.subplots(figsize=(12,9))
sns.heatmap(corrmat, vmax=0.9, square=True)
sns.heatmap(cov_matrix)

color = sns.color_palette()
sns.set_style('darkgrid')

# horizontal Plot
def horizontal_barplot(df_column, top_n=None, figsize=(20, 6), bar_color=None, 
                       suptitle='', suptitle_size=18, title='', title_size=18, 
                       xlabel='', ylabel='', xlabel_size=18, ylabel_size=18, 
                       xticks_size=14, yticks_size=14, 
                       text_offset=0, bar_text_size=20, bar_text_color='black' ):
    
    plt.figure(figsize=figsize)
    count = df_column.value_counts()
    top_count = count[:top_n]

    sns.barplot(x=top_count.values, y=top_count.index, orient='h', palette=color)

    plt.suptitle(suptitle, size=suptitle_size, fontweight='bold')
    plt.title(title, size=title_size)
    plt.xlabel(xlabel, size=xlabel_size); 
    plt.ylabel(ylabel, size=ylabel_size)
    plt.xticks(size=xticks_size); plt.yticks(size=yticks_size)

    for index, value in enumerate(top_count.values):
        s = str('{:,}'.format(value))+ " | " + str(np.round(100*value/count.sum(), 2)) + ' %'
        plt.text(text_offset, index, s, fontdict={'size': bar_text_size, 
                                                  'fontweight':'bold', 
                                                  'color':bar_text_color})