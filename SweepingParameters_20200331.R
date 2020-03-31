# -------------------------------------------------------------------------------
# Writing functions for equations and sweeping over parameters 
# 31 Mar 2020
# AAR
# -------------------------------------------------------------------------------
# 
library(ggplot2)

# S=cA^z  describes species-area relationship in ecology (# species as function of area)

 # -------------------------------------------------------------------------------
 # FUNCTION species_area_curve
 # description: creates a power function for S and A
 # inputs: A is a vector of island areas
 #          c is the intercept constant
 #          z is the slope constant
 # outputs: S is a vector of species richness
 #################################################################################
 species_area_curve <- function(A=1:5000,
                                c=0.5,
                                z=0.26) {
   S <- c*(A^z)
   return(S)
 
 } # end of species_area_curve
 # -------------------------------------------------------------------------------
 
head(species_area_curve())

# -------------------------------------------------------------------------------
# FUNCTION species_area_plot
# description: plots species area curves with parameter values
# inputs: A = vector of areas
#         c = single value for the c parameter
#         z = single value for the z parameter
# outputs: smoothed curve with parameters printed in a graph
#################################################################################
species_area_plot <- function (A=1:5000,
                               c=0.5,
                               z=0.26){
  plot(x=A, y=species_area_curve(A,c,z), 
       type="l", xlab="Island Area", ylab="S",
       ylim=c(0,2500))
  mtext(paste("c =",c,"z =",z), cex=0.7)

} # end of species_area_plot

# we used R's build in plotting function because for some reason, ggplot does not 
# work well with for loops. You may not get any errors, but you also don't get the plots.
# -------------------------------------------------------------------------------

species_area_plot()


# build a grid of plots!  this is cool!

# global variables
c_pars <- c(100,150,175)
z_pars <- c(0.10,0.16,0.26,0.30)
par(mfrow=c(4,3))

for (i in seq_along(c_pars)) {
  for (j in seq_along(z_pars)) {
    species_area_plot(c=c_pars[i], z=z_pars[j])
  }
}

# while function and repeat function -> they also evaluate a set of lines of code,
# but there will be a conditional operator, a condition that it will check. It will 
# repeat until a condition is met or it will continue to go through the code while
# a certain value is set. Gotelli will not show us these functions because we could
# generate a loop that we can never get out of (infinite loop if the condition can 
# never be met), and then the program will simply hang forever. His preference is to 
# set up the same kind of code in a for loop but instead add the break function, 
# which is kind of a safety because if we don't meet the condition, we will simply 
# finish the loop out and move on from the code. We might have to adjust the length
# of our loop so that we can get the result we want before the break, but it will not
# cause the code to fail or lock up.



# expand.grid function ----------------------------------------------------

expand.grid(c_pars,z_pars) # generates a data.frame as output

# -------------------------------------------------------------------------------
# FUNCTION sa_output
# description: summary stats for species-area power function
# inputs: vector of predicted species richness values
# outputs: list of max-min, coefficient of variation
#################################################################################
sa_output <- function(S=runif(10)) {
  
  sum_stats <- list(s_gain = max(S)-min(S),
                    s_cv = sd(S)/mean(S))
  return(sum_stats)

} # end of sa_output
# -------------------------------------------------------------------------------

sa_output()


# build program body ------------------------------------------------------

# global variables
Area <- 1:5000
c_pars <- c(100,150,175)
z_pars <- c(0.10, 0.16, 0.26, 0.30)

# set up model data frame
model_frame <- expand.grid(c=c_pars, z=z_pars)
str(model_frame)
model_frame$SGain <- NA
model_frame$SCV <- NA
head(model_frame)

# cycle through model calculations
for (i in 1:nrow(model_frame)) {
  
  # generate S vector
  temp1 <- species_area_curve(A=Area,
                              c=model_frame[i,1],
                              z=model_frame[i,2])
  # calculate output stats
  temp2 <- sa_output(temp1)
  
  # pass results to columns in the data frame
  model_frame[i,c(3,4)] <- temp2
  
}
print(model_frame)


# parameter sweep redux with ggplot graphics ------------------------------------

# even though we can't very easily use ggplot inside a for loop, ggplot has a built in 
# sweeping function of its own, which comes from its facet graphics

area <- 1:5
c_pars <- c(100,150,175)
z_pars <- c(0.10, 0.16, 0.26, 0.30)

# set up model frame
model_frame <- expand.grid(c=c_pars, z=z_pars, A=area)
head(model_frame)
nrow(model_frame)

# add response variable
model_frame$S <- NA

# loop through parameters and fill with sa function
for (i in 1:length(c_pars)) {
  for (j in 1:length(z_pars)) {
    model_frame[model_frame$c==c_pars[i] &
                  model_frame$z==z_pars[j],"S"] <-
      species_area_curve(A=area, c=c_pars[i], z=z_pars[j])
  }
}

head(model_frame)

# now for plotting with ggplot

p1 <- ggplot(data=model_frame)
p1 + geom_line(mapping=aes(x=A, y=S)) +
  facet_grid(c~z)

p2 <- p1
p2 + geom_line(mapping=aes(x=A, y=S, group=z)) +
  facet_grid(.~c)

p3 <- p1
p3 + geom_line(mapping=aes(x=A, y=S, group=c)) + 
  facet_grid(z~.)









  
  
  


 