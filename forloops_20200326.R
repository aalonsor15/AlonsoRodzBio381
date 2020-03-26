# -------------------------------------------------------------------------------
# Basic anatomy and use of for loops 
# 26 Mar 2020
# AAR
# -------------------------------------------------------------------------------
# 

# Random notes about for loops:
# the workhouse function in computer programming for doing repetitive tasks
# we are going to repeatedly loop through a set of commands
# universal in all computer languages, but controversial in their use in R
# some people claim they are not necessary or are too slow, but Gotelli does not agree
# all good programmers use then within their R programs

# Anatomy of a for loop

# for (var in seq) { 

# body of for loop
# }

# var -> Variable. Counter variable that holds the current value of the counter in the loop.
# This number will increase by a value of 1 each time we go through the loops - tells us 
# which loop we are on as we go through the sequence
# seq -> sequence of values. Integer vector (or vector of character strings) that defines
# the starting and ending values of the loop
# { designates the start of the loop
# } designates the end of the loop

# suggest using i, j, k for the var (counter)


# how to NOT set up your for loops (do not use this method!)
my_dogs <- c("chow", "akita", "malamute", "husky", "samoyed")

for (i in my_dogs) {
  print(i)
}
# problem with this code is that I can only access the names in the vector 
# and not their position 
# usually we want the var to take on values of an actual numeric sequence, 
# not just an ordered value or character vectors

# set it up this way instead
for (i in 1:length(my_dogs)) {
  cat("i =", i, "my_dogs[i] =", my_dogs[i], "\n")
}

# potential hazard: suppose our vector is empty! 
my_bad_dogs <- NULL

for (i in 1:length(my_bad_dogs)) { 
  cat("i =", i, "my_bad_dogs[i] =", my_bad_dogs[i], "\n")
  }    # this produces an error because the vector is empty

# safer way to code var in the forloop is use seq_along, which also handles the 
# empty vector correctly

for (i in seq_along(my_dogs)) {
  cat("i =", i, "my_dogs[i] =", my_dogs[i], "\n")
}

for (i in seq_along(my_bad_dogs)) { 
  cat("i =", i, "my_bad_dogs[i] =", my_bad_dogs[i], "\n")
}   # now nothing happens (no output), which is the correct response


# could also define vector length from a constant and then use seq_len in for loop
zz <- 5
for (i in seq_len(zz)) { 
  cat("i =", i, "my_dogs[i] =", my_dogs[i], "\n")
}
  
  

# Main tips and suggestions for for loops ---------------------------------


# tip #1: do NOT change object dimensions inside a loop
# avoid these functions (cbind,rbind,c,list)

my_dat <- runif(1)
for (i in 2:10) {
  temp <- runif(1)
  my_dat <- c(my_dat, temp)   # don't do this!
  cat("loop number =", i, "vector element =", my_dat[i], "\n")
}
print(my_dat)  
  

# tip #2: don't do things in a loop if you do not need to!

for (i in 1:length(my_dogs)) {
  my_dogs[i] <- toupper(my_dogs[i]) # don't do this in loop
  cat("i =", i, "my_dogs[i] =", my_dogs[i], "\n")
}

z <- c("dog", "cat", "pig")
toupper(z)   # you can do this in a separate step, such as this


# tip #3: do not use a loop if you can vectorize!

my_dat <- seq(1:10)
for (i in seq_along(my_dat)) {
  my_dat[i] <- my_dat[i] + my_dat[i]^2
  cat("loop number =", i, "vector element =", my_dat[i], "\n")
}

# no loop needed to do the above! It's easier to do the options below
z <- 1:10
z <- z + z^2
print(z)


# tip #4: understand the distinction between the counter variable i, and
# the vector element z[i]

z <- c(10,2,4)
for (i in seq_along(z)) {
  cat("i =", i, "z[i] =", z[i], "\n")
}  

# what is the value of i at the end of the loop?
print(i)
# what is the value of z at the end of the loop?
print(z)


# tip #5: use function next to skip certain elements in the loop

# suppose we want to work only with the odd-numbered elements?
z <- 1:20

for (i in seq_along(z)) {
  if (i %% 2==0) next 
  print(i)
}

    # %% calculates the remainder of a division
    # next -> immediately jumps to the end of the for loop and go to the next loop (skip)

# another method to do the same thing, probably faster (why?)

z <- 1:20
z_sub <- z[z %% 2!=0] # contrast with logical expression in loop above
length(z)
length(z_sub)
z_sub  

for (i in seq_along(z_sub)) {
  cat("i =", i, "z_sub[i] =", z_sub[i], "\n")
}  # this is faster than the loop above because it is half as long by not using next.
  

# tip #6: use break function to set up a conditional to break out or a loop early

# create a simple random walk population model function

# -------------------------------------------------------------------------------
# FUNCTION ran_walk
# description: stochastic random walk
# inputs: times = number of time steps
#         n1 = initial population size (=n[1])
#         lambda = finite rate of increase
#         noise_sd = standard deviation of a normal distribution with mean 0
# outputs: vector n with population sizes > 0 until extinction, then NA values
#################################################################################
library(tcltk)
library(ggplot2)

ran_walk <- function(times = 100, 
                     n1 = 50,
                     lambda = 1.0,
                     noise_sd = 10) {    # start of function
  n <- rep(NA, times)    # create output vector
  n[1] <- n1    # initialize starting population size
  noise <- rnorm(n=times, mean=0, sd=noise_sd)  # create random noise vector
  
  for (i in 1:(times - 1)) {    # start of forloop
    n[i + 1] <- n[i] * lambda + noise[i]
    if(n[i + 1] <= 0) {      # start of if statement
      n[i + 1] <- NA
      cat("Population extinction at time", i-1, "\n")
      tkbell()    # runs a bell from my computer, like an alarm
      break    # jump out of the loop entirely, stops the loop when this happens
    }    # end of if statement
  }    # end of for loop

return(n)

} # end of ran_walk function
# -------------------------------------------------------------------------------

ran_walk()





