# -------------------------------------------------------------------------------
# ggplot: multiple plots and aesthetics 
# 14 Apr 2020
# AAR
# -------------------------------------------------------------------------------
# 


# preliminaries -----------------------------------------------------------

library(ggplot2)
library(ggthemes)
library(patchwork)
library(TeachingDemos)
char2seed("sunflower")
d <- mpg # use mpg data set


# multiple plots ----------------------------------------------------------

# first, create a series of plots

g1 <- ggplot(data = d, 
             mapping = aes(x = displ, y = cty)) + 
      geom_point() + 
      geom_smooth()
print(g1)

g2 <- ggplot(data = d,
             mapping = aes(x = fl,
                           fill = I("tomato"),
                           color = I("black"))) + 
      geom_bar(stat = "count") + 
      theme(legend.position = "none")
print(g2)

g3 <- ggplot(data = d,
             mapping = aes(x = displ, 
                           fill = I("royalblue"),
                           color = I("black"))) +
      geom_histogram()
print(g3)

g4 <- ggplot(data = d,
             mapping = aes(x = fl, y = cty, 
                           fill = fl)) + 
      geom_boxplot() + 
      theme(legend.position = "none")
print(g4)


# now, let's use patchwork to combine plots

# place 2 plots horizontally
g1 + g2

# place 3 plots vertically
g1 + g2 + g3 + plot_layout(ncol = 1)

# change relative area of each plot
g1 + g2 + plot_layout(ncol = 1, heights = c(2,1))

g1 + g2 + plot_layout(ncol = 2, widths = c(1,2))

# add a spacer plot
g1 + plot_spacer() + g2

# use nested plots
g1 + {
  g2 + { 
    g3 + 
      g4 + 
      plot_layout(ncol=1)
    }
} + plot_layout(ncol=1)

# - operator for subtrack element
g1 + g2 - g3 + plot_layout(ncol=1)

# / and | for instuitive plot layouts
(g1 | g2 | g3)/g4

(g1 | g2)/(g3 | g4)

# Add title, subtitle to patchwork plot
g1 + g2 + plot_annotation("This is a title",
                          caption = "made with patchwork")

# change the styling of patchwork annotations
g1 + g2 + 
  plot_annotation(
    title = "This is a title", 
    caption = "made with patchwork",
    theme = theme(plot.title = element_text(size = 16)))

# Add tags to plots
g1 / (g2 | g3) + 
  plot_annotation(tag_levels = 'A')


# swapping axes, orientation ----------------------------------------------

g3a <- g3 + scale_x_reverse()
g3b <- g3 + scale_y_reverse()
g3c <- g3 + scale_x_reverse() + scale_y_reverse()

(g3 | g3a)/(g3b | g3c)

# coordinate flipping

(g3 + coord_flip() | g3a + coord_flip()) / 
  (g3b + coord_flip() | g3c + coord_flip())



# aesthetic mapping -------------------------------------------------------

# There is a systematic logic to the mapping of variables, and we can take advantage 
# of these different variable attributes to get the different types of plots that we need. 

# mapping of discrete variable to point color
m1 <- ggplot(data = d,
             mapping = aes(x = displ, 
                           y = cty, 
                           color = class)) + 
      geom_point(size = 3)
print(m1)

# mapping of a discrete variable to point shape
# (doesn't work if you have more than 6 groups)
m1 <- ggplot(data = d,
             mapping = aes(x = displ, 
                           y = cty, 
                           shape = class)) + 
  geom_point(size = 3)
print(m1)

# mapping of a discrete variable to point size
# (mapping to point size is not recommended for discrete variables)
m1 <- ggplot(data = d,
             mapping = aes(x = displ, 
                           y = cty, 
                           size = class)) + 
  geom_point()
print(m1)

# mapping a continuous variable to point size
m1 <- ggplot(data = d,
             mapping = aes(x = displ, 
                           y = cty, 
                           size = hwy)) + 
  geom_point()
print(m1)

# mapping a continuous variable to point color
m1 <- ggplot(data = d,
             mapping = aes(x = displ, 
                           y = cty, 
                           color = hwy)) + 
  geom_point(size = 5)
print(m1)

# map 2 variables to different aesthetics
m1 <- ggplot(data = d,
             mapping = aes(x = displ, 
                           y = cty, 
                           shape = class,
                           color = hwy)) + 
  geom_point(size = 5)
print(m1)

# use shape for a smaller number of categories
m1 <- ggplot(data = d,
             mapping = aes(x = displ, 
                           y = cty, 
                           shape = drv,
                           color = fl)) + 
  geom_point(size = 5)
print(m1)

# use all 3 (size, shape, color) to indicate 5 data attributes
m1 <- ggplot(data = d,
             mapping = aes(x = displ, 
                           y = cty, 
                           shape = drv,
                           size = hwy,
                           color = fl)) + 
  geom_point()
print(m1) 


# ***Gotelli doesn't recomment using this last example since it includes too
# ***much information in one plot. This must be used with care.

# mapping a variable to the same aesthetic in two different geoms
m1 <- ggplot(data = d,
             mapping = aes(x = displ,
                           y = cty, 
                           color = drv)) +
      geom_point(size = 2) + geom_smooth(method = "lm")
print(m1)



# faceting ---------------------------------------------------------------

# basic faceting with variables split by row, column or both 
m1 <- ggplot (data = d,
              mapping = aes(x = displ,
                            y = cty)) + 
      geom_point()
m1 + facet_grid(class~fl)   # class in rows and fl in columns

# this is a good method to observe relationships between the data 
# that would otherwise be hard to see. For example, where we have
# missing values

# change axes by letting some of them be free
m1 + facet_grid(class~fl, scales = "free_y")

# let both axes be free in scale
m1 + facet_grid(class~fl, scales = "free")

# facets also work with one-way layout
m1 + facet_grid(.~class)

# one-way layout with differing rows
m1 + facet_grid(class~.)


# use facet wrap when variables are not crossed
m1 + facet_grid(.~class) #facet grid
m1 + facet_wrap(.~class) #facet wrap

# add a second variable to facet_wrap
m1 + facet_wrap(~class + fl)
# here we only see the combination of variables that have data in them

# include "empty" combos in facet_wrap
m1 + facet_wrap(~class + fl, drop = FALSE)
# here we see all variable combinations, even if they don't have data

# contrast with grid two-way layout
m1 + facet_grid(class~fl)


# use facet with other aesthetic mappings within rows or columns
m1 <- ggplot(data = d,
             mapping = aes(x = displ,
                           y = cty,
                           color = drv)) + 
      geom_point()
m1 + facet_grid(.~class)

# easy to switch to other geoms
m1 <- ggplot(data = d,
             mapping = aes(x = displ,
                           y = cty,
                           color = drv)) + 
  geom_smooth(se = FALSE, method = "lm") # nice to see only the trends
m1 + facet_grid(.~class) 

# fit boxplots with a continuous variable
m1 <- ggplot(data = d,
             mapping = aes(x = displ,
                           y = cty)) + 
      geom_boxplot()
m1 + facet_grid(.~class)

# add a "group" and fill the mappings for subgroups
m1 <- ggplot(data = d,
             mapping = aes(x = displ,
                           y = cty,
                           group = drv,
                           fill = drv)) + 
  geom_boxplot()
m1 + facet_grid(.~class)


# Aesthetic mappings 2 ----------------------------------------------------

# standard plot with all data
p1 <- ggplot(data = d,
             mapping = aes(x = displ,
                           y = hwy)) + 
      geom_point() + geom_smooth()
print(p1)


# break out drive types (note what "group" affects)
p1 <- ggplot(data = d,
             mapping = aes(x = displ,
                           y = hwy,
                           group = drv)) + 
  geom_point() + geom_smooth()
print(p1)
# group mapping affects only the lines


# break out drive types (note what "color" affects)
p1 <- ggplot(data = d,
             mapping = aes(x = displ,
                           y = hwy,
                           color = drv)) + 
  geom_point() + geom_smooth()
print(p1)
# color mapping affects both the points and the lines


# break out drive types (note what "fill" affects)
p1 <- ggplot(data = d,
             mapping = aes(x = displ,
                           y = hwy,
                           fill = drv)) + 
  geom_point() + geom_smooth()
print(p1)
# fill mapping affects only the confidence intervals (larger objects)


# color all the points, lines and confidence intervals
p1 <- ggplot(data = d,
             mapping = aes(x = displ,
                           y = hwy,
                           fill = drv,
                           color = drv)) + 
  geom_point() + geom_smooth()
print(p1)


# use aesthetic mappings to overide defaults
# subset data to plot what is needed
p1 <- ggplot(data = d,
             mapping = aes(x = displ,
                           y = hwy,
                           color = drv)) + 
  geom_point(data = d[d$drv=="4",]) + geom_smooth()
print(p1)


# instead of subsetting, just map an aesthetic
p1 <- ggplot(data = d,
             mapping = aes(x = displ,
                           y = hwy)) + 
  geom_point(mapping = aes(color = drv)) + 
  geom_smooth()
print(p1)


# Conversely, map the smoother, but not the points
p1 <- ggplot(data = d,
             mapping = aes(x = displ,
                           y = hwy)) + 
  geom_point() + 
  geom_smooth(mapping = aes(color = drv))
print(p1)


# Also, subset in the first layer to eliminate some data entirely
# instead of subsetting, just map an aesthetic
p1 <- ggplot(data = d[d$drv != "4",],
             mapping = aes(x = displ,
                           y = hwy)) + 
  geom_point(mapping = aes(color = drv)) + 
  geom_smooth()
print(p1)




