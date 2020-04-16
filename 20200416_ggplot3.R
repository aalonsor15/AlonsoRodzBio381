# -------------------------------------------------------------------------------
# bar plot geoms and colors in ggplot 
# 16 Apr 2020
# AAR
# -------------------------------------------------------------------------------
# 

# Preliminaries -----------------------------------------------------------


library(ggplot2)
library(ggthemes)
library(patchwork)
library(colorblindr)
library(cowplot)
library(colorspace)
library(ggsci)
#install.packages("wesanderson")
library(wesanderson)
library(TeachingDemos)
char2seed("anxiety")
d <- mpg


# bar plots ---------------------------------------------------------------

table(d$drv)

p1 <- ggplot(d, aes(x = drv)) +
      geom_bar(color = "black",
               fill = "cornsilk")

# when we're inside geom_bar we dont need to call the identity (I) function 
# when we assign a color, because color and fill are just some of the options
# for geom_bar. However, we do need to call this Identity function when we're
# inside the first ggplot aesthetics so that ggplot understands we're not 
# trying to map that variable to that color, we're trying to simply assign it.

print(p1)

# aesthetic mapping for multiple groups in each bar

p1 <- ggplot(d, aes(x = drv, fill = fl)) + 
      geom_bar()
print(p1)

# stacking with color transparency, adjust alpha, which is the color 
# transparency of each bar
# alpha = 0 all colors invisible
# alpha = 1 all colors completely opaque

p1 <- ggplot(d, aes(x = drv, fill = fl)) + 
  geom_bar(alpha = 0.3, position = "identity")
print(p1) # this is not a great option 

# better to use position = fill for stacking with a constant height

p1 <- ggplot(d, aes(x = drv, fill = fl)) + 
  geom_bar(position = "fill")
print(p1) # here, y axis is a proportion, not a count

# best solution is to use position = dodge to generate multiple bars

p1 <- ggplot(d, aes(x = drv, fill = fl)) + 
  geom_bar(position = "dodge", color = "black", size = 0.8)
print(p1)

# more typical bar plot has heights as values (mean, total)

d_tiny <- tapply(X = d$hwy, 
                 INDEX = as.factor(d$fl),
                 FUN = mean)

d_tiny <- data.frame(hwy = d_tiny)
d_tiny <- cbind(fl = row.names(d_tiny), d_tiny)
d_tiny

p2 <- ggplot(d_tiny, aes(x = fl, y = hwy, fill = fl)) + 
      geom_col()
print(p2)

# much better to use a boxplot instead, which shows us the distribution
# of the data

p2 <- ggplot(d, aes(x = fl, y = hwy, fill = fl)) +
      geom_boxplot()
print(p2)

# overlaying the raw data greatly adds value to the boxplot
p2 <- ggplot(d, aes(x = fl, y = hwy)) +
  geom_boxplot(fill = "thistle", outlier.shape = NA) + 
  geom_point()
print(p2)

# improve the visualization of the data (best option!)
p2 <- ggplot(d, aes(x = fl, y = hwy)) +
  geom_boxplot(fill = "thistle", outlier.shape = NA) + 
  geom_point(position = position_jitter(width = 0.1,
                                        height = 0.7),
             color = "gray60", size = 2)
print(p2)

#################################################################################

# Color -------------------------------------------------------------------


# hue = wavelength of visible light
# saturation = intensity or vibrance of the color
# lightness = black to white (scale)
# red, blue, green
# named colors in R

# Aesthetics:  (colors should look good!)
# 1. attractive colors
# 2. for large geoms (bars, boxplots), use light pale colors
# 3. for small geoms (points, lines), use dark vibrant colors
# 4. pick color palettes that are visible to the colorblind
# 5. pick color palettes that convert well to black and white

# Information content:   (colors should convey information!)
# 1. use colors to group similar treatments
# 2. use neutral colors (black, grey, white) for control groups
# 3. look at symbolic colors that can be used to convey certain elements
#     examples: heat = red, cool = blue, photosynthesis/growth = green,
#     oligotrophic = blue, infected = red, dyes or stains, or even colors
#     of organisms

# Scales:
# discrete scales - for distinct groups
# continuous scales (as in a heat map)
#       1. monochromatic (different shades of one color)
#       2. 2-tone chromatic scale (from color x to color y)
#       3. 3-tone divergent scale (from color x through color y to color z)

# Use a consistent color scheme for a manuscript
# ---> use consistent colors within and between your figures

## www.colorbrewer2.org
# use this website to find awesome color combinations for graphs

my_cols <- c('#d7191c','#fdae61','#abd9e9','#2c7bb6') #colors taken from colorbrewer

# use demoplot to visualize your chosen color palette
demoplot(my_cols, "map")
demoplot(my_cols, "bar")
demoplot(my_cols, "scatter")
demoplot(my_cols, "spine")
demoplot(my_cols, "heatmap")
demoplot(my_cols, "perspective")

my_r_colors <- c("red", "brown", "cyan", "green")
demoplot(my_r_colors, "pie")



# Color coding ------------------------------------------------------------

# working with black and white

# grey colors and grey functions  (grey = gray)

# built in grey colors (0 = black, 100 = white)
my_greys <- c("grey20", "grey50", "grey80")
demoplot(my_greys, "bar")

# grey()  --> use this function for selection a vector of grey colors
my_greys2 <- gray(seq(from = 0.1, to = 0.9, length.out = 10))
print(my_greys2)
demoplot(my_greys2, "heatmap")

# convert color plots to black and white
p1 <- ggplot(d, aes(x = as.factor(cyl),
                    y = cty, fill = as.factor(cyl))) +
      geom_boxplot()
print(p1)

p1_des <- colorblindr::edit_colors(p1, desaturate)
# double colon: object that comes before it is the package that this function is
# taken from. We don't technically need to do this because we already called the 
# colorblindr library, but this way to know where the function is coming from. 
plot(p1_des)

# desaturate with custom colors
p2 <- p1 + scale_fill_manual(values = c("red", "blue", "green", "yellow"))
plot(p2)

p2_des <- colorblindr::edit_colors(p2, desaturate)
plot(p2_des)

# using alpha transparency for histogram plots
x1 <- rnorm(n=100, mean=0)
x2 <- rnorm(n=100, mean=2.7)
d_frame <- data.frame(v1=c(x1,x2))
lab <- rep(c("Control", "Treatment"), each=100)
d_frame <- cbind(d_frame, lab)
str(d_frame)

h1 <- ggplot(d_frame, aes(x = v1, fill = lab)) 
h1 + geom_histogram(position = "identity",
                    alpha = 0.5, 
                    color = "black")


# Color customization in ggplots -------------------------------------------

### discrete classification ###

# scale_fill_manual()  ---> used for big geoms (histogram, boxplots, bars)
# scale_color_manual() ---> used for geoms that are controled by the color call (lines, points)

# boxplot with no color
p_fill <-ggplot(d, aes(x = as.factor(cyl), y = cty))
p_fill + geom_boxplot()

# boxplot with default fill
p_fill <-ggplot(d, aes(x = as.factor(cyl), y = cty, fill = as.factor(cyl)))
p_fill + geom_boxplot()

# create custom color palette
my_col <- c("red", "brown", "blue", "orange")
p_fill + geom_boxplot() + 
        scale_fill_manual(values = my_col)

# scatterplot with no color
p_color <- ggplot(d, aes(x = displ, y = cty)) +
          geom_point(size = 3)
print(p_color)

# scatterplot with default ggplot colors
p_color <- ggplot(d, aes(x = displ, y = cty, 
                         col = as.factor(cyl))) +
  geom_point(size = 3)
print(p_color)

# scatterplot with custom colors
p_color + scale_color_manual(values=my_col)


### continuous classification ###

# default color gradient
p_grad <- ggplot(d, aes(x = displ, y = cty, col = hwy)) +
          geom_point(size = 3)
print(p_grad)

# custom sequential gradient (2 colors)
p_grad + scale_color_gradient(low = "green", high = "red")

# custom diverging gradient (3 colors)
mid <- median(d$hwy)
p_grad + scale_color_gradient2(midpoint = mid, 
                               low = "blue",
                               mid = "white",
                               high = "red")

# custom diverging gradient (n colors)
p_grad + scale_color_gradientn(colors = c("blue", 
                                          "green",
                                          "yellow",
                                          "purple",
                                          "orange"))

# R has built-in color gradients that work better than these manual ones, 
# but it's still cool to know what the above coding is possible for custom coloring.


# Built-in R color palettes --------------------------------------------------------

### library(wesanderson)

print(wes_palettes)
demoplot(wes_palettes$BottleRocket1, "pie")
demoplot(wes_palettes[[2]][1:3], "spine")  # second movie in list, first 3 colors

my_cols <- wes_palettes$GrandBudapest2[1:4]  # first 4 colors
p_fill + geom_boxplot() + scale_fill_manual(values = my_cols)

### library(RColorBrewer)

display.brewer.all()
display.brewer.all(colorblindFriendly = TRUE)

demoplot(brewer.pal(4, "Accent"), "bar")
demoplot(brewer.pal(11, "Spectral"), "heatmap")

# combine palettes to make a custom palette
my_cols <- c("grey75", brewer.pal(3, "Blues"))
print(my_cols)
demoplot(my_cols, "pie")

p_fill + geom_boxplot() + scale_fill_manual(values=my_cols)

# nice tool for seeing hex values
library(scales)
show_col(my_cols)


### viridis palettes

# making a heat map
x_var <- 1:30
y_var <- 1:5
my_data <- expand.grid(x_var=x_var, y_var=y_var)
head(my_data)
z_var <- my_data$x_var + my_data$y_var + 2*rnorm(n=150)
my_data <- cbind(my_data, z_var)
head(my_data)

# default gradient colors in r
p4 <- ggplot(my_data, aes(x = x_var, y = y_var, fill = z_var)) + 
      geom_tile()
print(p4)

# user defined divergent palette
p4 + scale_fill_gradient2(midpoint = 19, 
                          low = "brown",
                          mid = gray(0.8),
                          high = "darkblue")

# use viridis continuous scale
p4 + scale_fill_viridis_c()

# options in viridis: viridis, cividis, magma, inferno, plasma
p4 + scale_fill_viridis_c(option = "cividis")  # colorblind option
p4 + scale_fill_viridis_c(option = "magma")
p4 + scale_fill_viridis_c(option = "inferno")
p4 + scale_fill_viridis_c(option = "plasma")

# desaturation with viridis
p4 <- p4 + scale_fill_viridis_c()
p4_des <- edit_colors(p4, desaturate)
plot(p4_des)






