# more functions and tricks with atomic vectors
# 06 Feb 2020
# AAR

# -------------------------------------------------------------------------

# Atomic Vectors - Continued

# create empty vector, specify its mode and length
z <- vector(mode='numeric', length=0)
z <- c(z,5)
print(z)
# this is dynamic sizing - size of vector will change as you add stuff to it
# Its better to avoid dynamic sizing in R. Its too slow in a loop

# preferred way: preallocate space to a vector
z <- rep(0,100)
head(z) # gives you the first few items of your vector

# fill with NA values, this is also a good way to go
z <- rep(NA,100)
head(z)

typeof(z) # check data type.
z[1] <- "Washington" 
typeof(z)

# Method for quickly assigning names to a vector
v_size <- 100
my_vector <- runif(v_size)
my_names <- paste("Species", seq(1:length(my_vector)), sep = "") 
# the paste function helps me name things easier
head(my_names)
names(my_vector) <- my_names
head(my_vector)

# the rep function for repeating elements 
rep(0.5,6)
rep(x=0.5, times=6) #this increases readability, instead of the above.
rep(times=6, x=0.5) #by specifying arguments, the order doesn't matter
rep(6, 0.5) #this on the other hand, doesn't give the same answer

my_vec <- c(1,2,3)
rep(x=my_vec, times=2)
rep(x=my_vec, each=2)
rep(x=my_vec, times=my_vec)
rep(x=my_vec, each=my_vec) #this one doesn't work

# Using seq to create regular sequences
seq(from=2, to=4)
2:4
`:`(2,4)

seq(from=2, to=4, by=0.5)
seq(from=2, to=4, length=7)
my_vec <- 1:length(x) #you decide what the length will be
seq_along(my_vec)

# Using random number generator
runif(5)
runif(n=5, min=100, max=110)

# rnorm for normal distributions
rnorm(6)
rnorm(n=5, mean=100, sd=30)

library(ggplot2)
z <- runif(1000)
qplot(x=z)
z <- rnorm(1000)
qplot(x=z)

# Use sample function to draw random values from an existing vector
long_vec= seq_len(10)
print(long_vec)
sample(x=long_vec) # mix the elements of my vector in a random order
sample(x=long_vec, size=3) #sampling 3 elements of my vector without replacement
sample(x=long_vec, size=16, replace=TRUE) #sampling with replacement
my_weights <- c(rep(20,5), rep(100,5))
print(my_weights)
sample(x=long_vec,replace=TRUE, prob=my_weights)


# -------------------------------------------------------------------------

# Techniques for subsetting atomic vectors

z <- c(3.1, 9.2, 1.3, 0.4, 7.5)

# subset with positive index values
z[c(2,3)] # gives me elements in location 2 and 3

# subset with negative index values
z[-c(1,5)] # gives me all elements except those in location 1 and 5

# create a logical vector of conditions for subsetting
z[z<3]

tester <- z<3
print(tester)
z[tester]

# the which function to find slots
which(z<3) #gives me the location of the vector elements that are less than 3
z[which(z<3)]

# use length for relative positioning
z[-c(length(z):(length(z)-2))]

# also subset using named vector elements
names(z) <- letters[1:5] #assign letters as names in vector
z
z[c("b","b")]


# -------------------------------------------------------------------------

# relational operators
# < less than
# > greater than
# <= less than or equal
# >= greater than or equal
# == equal... check whether two elements are equal

#logical operators
# !  NOT
# &  and (applies to a vector)
# |  or (applies to a vector) - vertical slash
# xor(a,b)  a or b, but not a and b
# &&  and (evaluates first element of vector)
#||  or (evaluates first element of vector)

x <- 1:5
y <- c(1:3, 7, 7)
x == 2
x != 2  # not equal to 2

x == 1 & y == 7 #looks for 1 and 7 occuring in the same locations
x == 1 | y == 7
x == 3 | y == 3
xor(x==3,y==3)
x == 3 && y == 3 # only evaluated the first element of the two vectors


# -------------------------------------------------------------------------

# Back to Subscripting: Subscripting with missing values
set.seed(90)
z <- runif(10)
z
z < 0.5
z[z<0.5]
which(z<0.5)
z[which(z<0.5)]

zD <- c(z,NA,NA)
zD[zD<0.5]
zD[which(zD<0.5)] #take out NAs from vector
