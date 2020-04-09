# -------------------------------------------------------------------------------
# Basics of ggplot grammar and graphics 
# 09 Apr 2020
# AAR
# -------------------------------------------------------------------------------
# 

# Two kinds of graphics

# 1. Publication quality graphics --> Its a very interactive type of programming.
# Not so much long lines of codes but rather tweaking the code that we have and 
# looking at the output that we get from it.

# 2. Exploration graphics -->
# When we are deep in our programming and we want to very quickly look at what 
# the relationship is between some variables, or visualize an R data object, and we 
# want to do that with a minimal amount of coding. We just want to be able to look
# at a graph on the screen, make sure the data are what we think they are and move on.


# Components of a ggplot layer --------------------------------------------

# 1. data (in a data frame)
# 2. aesthetic mapping (variables are mapped to an aesthetic)
# 3. geom (geometric object used to draw the layer: points, bars, polygons, etc)
# 4. stat (raw data and tranforms it for something useful in a plot: linear regression
# line, or 95% interval, etc)
# 5. position (adjust points for overplotting)
# 6. facet function (for producing multiple plots)
# 7. coordinate (flip or invert the x and y axes)


# Template for ggplot components (anatomy of code) ------------------------

# p1 <- ggplot(data = <DATA>,
#               mapping = aes(<MAPPING>)) + 
#       <GEOM_fUNCTION>(mapping = aes(<MAPPING>),
#                       stat = <STAT>,
#                       position = <POSITION>) +
#       <COORDINATE_FUNCTION> + 
#       <FACET_FUNCTION>
#  print(p1)
#  ggsave(plot = p1, 
#         filename = "MyPlot", 
#         width = 5, 
#         height = 3, 
#         units = "in",
#         device = "pdf")

# An essential part of reproducible research is to save the graphics once you have them
# in the form that you want and the code is complete. For this, use the ggsave function.


# Preliminaries -----------------------------------------------------------

library(ggplot2)
library(ggthemes)
library(patchwork)
library(TeachingDemos)
char2seed("doubling time")

d <- mpg # use built in data set on car performance
str(d)
table(d$fl)


# fast plotting with qplot ------------------------------------------------

# qplot  -->  its part of ggplot, and it mimics the underlying R base graphics
# unlike ggplot graphics, qplot does not require data to be in a data frame
# very simple code that we can use for looking at variables and data in the midst of our programming
# not for publication quality graphs


# basic histogram
qplot(x = d$hwy)
qplot(x = d$hwy, fill = I("tan"), color = I("black"))

# make your own custom histogram function
my_histo <- function(x_var, fil_col="goldenrod") {
  qplot(x = x_var, color = I("black"), fill = I(fil_col))
}

my_histo(d$hwy)
my_histo(d$hwy, "thistle")

# basic density plot 
#(smooths over the irregularities and tries to estimate the smooth density 
# at each point along the x axis)
qplot(x = d$hwy, geom = "density")

# basic scatter plot
qplot(x = d$displ, 
      y = d$hwy,
      geom = c("smooth", "point"))

# basic scatter plot with linear regression line
qplot(x = d$displ, 
      y = d$hwy,
      geom = c("smooth", "point"), 
      method = "lm")

# basic boxplot
# (use if x axis variable is discrete and the y variable is continuous)
qplot(x = d$fl, y = d$cty, geom = "boxplot", fill = I("tan"))

# basic barplot ("long format")
qplot(x = d$fl, geom = "bar", fill = I("goldenrod"))

# common mistake
# (if you don't use the I() for the fill, it thinks the color is a grouping and adds a legend)
qplot(x = d$fl, geom = "bar", fill = "goldenrod")

# bar plot with specified counts or means("short format")
x_treatment <- c("Control", "Low", "High")
y_response <- c(12, 2.5, 22.9)
qplot(x = x_treatment, y = y_response, 
      geom = "col", fill = I(c("grey20", "grey50", "grey90"))) # good way to do grayscale colors

# basic curves and functions
my_vec <- seq(1, 100, by = 0.1)
head(my_vec)
my_fun <- function(x) sin(x) + 0.1*x
qplot(x = my_vec, y = sin(my_vec), geom = "line")  # built in function
qplot(x = my_vec, y = dgamma(my_vec, shape = 5, scale = 3), geom = "line")  # density functions for stats
qplot(x = my_vec, y = my_fun(my_vec), geom = "line")  # user defined function



# ggplot: themes and fonts ---------------------------------------------------------------


p1 <- ggplot(data = d,
             mapping = aes(x = displ, y = cty)) + 
      geom_point()
print(p1)

# overall appearance of the plot is controlled by the themes

p1 + theme_classic()
p1 + theme_linedraw()
p1 + theme_dark()
p1 + theme_base()   # looks similar to base graphics
p1 + theme_void()  # plots only the data, none of the text or axis
p1 + theme_economist()
p1 + theme_bw()
p1 + theme_grey()  # this is the default theme for ggplot


#### MAJOR THEME MODIFICATIONS ####
# we can make major modifications to our basic themes

p1 + theme_classic(base_size = 40)  # change size of all labels, fonts and lines at once (all except data)
p1 + theme_classic(base_family = "serif")  # change font type

# defaults: theme_grey, base_size = 16, base_family = "Helvetica"

# ***for publication quality graphs, the default font size of 16 is too small***

# default font families (Mac): Times, Arial, Monaco, Courier, Helvetica, serif, sans

# use coordinate_flip element to invert entire plot

p2 <- ggplot(data = d, mapping = aes(x = fl, fill = fl)) + 
      geom_bar()
print(p2)

p2 + coord_flip()

#### MINOR THEME MODIFICATIONS ####

p1 <- ggplot(data = d,
             mapping = aes(x = displ, y = cty)) +
      geom_point(size = 7, shape = 21, 
                 color = "black", fill = "steelBlue") + 
      labs(title = "My graph title here",
           subtitle = "An extended subtitle that will print below the main title",
           x = "My x axis label",
           y = "My y axis label") +
      xlim(0,9) +
      ylim(0,40)
  
print(p1)







