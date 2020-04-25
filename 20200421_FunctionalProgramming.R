# -------------------------------------------------------------------------------
# Functional programming 
# 21 Apr 2020
# AAR
# -------------------------------------------------------------------------------
# 

# functional programming -> writing functions that use functions.

# apply functions in base R -> alternative to using for loops to get our tasks done


# different types of functions in R ---------------------------------------------

z <- 1:10

# built-in functions 
# i.e. "prefix" functions -> name of the function comes first, followed by the inputs into it
mean(z)

# "in-fix" functions
z + 100
`+`(z,100)  # same as above but written as an "in-fix" function

# user-defined functions

# -------------------------------------------------------------------------------
# FUNCTION: my_fun
# description: calculate maximum of the sin of x + x
# inputs: numeric vector
# outputs: 1-element numeric vector
#################################################################################
my_fun <- function(x=runif(5)) {

  z <- max(sin(x) + x)

return(z)

} # end of my_fun
# -------------------------------------------------------------------------------
my_fun()
my_fun(z)


# anonymous functions
# Unnamed, used for single calculations, usually with a single input
# By convention, input if called x
# Typically, it is only 1 line of code

function(x) x + 3  # example of an anonymous function, but it still doesn't have data
function(x) x + 3 (10)  # try to provide an input... this doesn't work either
(function(x) x + 3) (10)  # now this works and we do get an output
# But this is an odd construct and we would not use it in this way in our coding
# These functions are useful when we combine them with the apply functions,
# because it lets us write a little function on the fly without having to set up
# a whole formal user-defined function the way we have done so far.


# Task #1 -----------------------------------------------------------------

# First task: apply a function to each row (or column) of a matrix

# build matrix
m <- matrix(1:20, nrow = 5, byrow = TRUE)
print(m)


# for loop solution #
# create a vector of numeric values to hold the output
output <- vector("numeric", nrow(m))
str(output)

# run the function in a for loop for each row of the matrix

for (i in seq_len(nrow(m))) {
  output[i] <- my_fun(m[i,])
}  # this will operate my_fun on each row of the matrix and put the results in output

print(output)


# apply solution #
# use the apply() function to do the same thing
# apply(X,MARGIN,FUN,...)

# X = vector or an array (=matrix)
# MARGIN = number, 1=row, 2=column, c(1,2)= rows and columns
# ... = optional arguments to the function

# apply the function my_fun to each row of m
row_out <- apply(X = m,
                 MARGIN = 1,
                 FUN = my_fun)
print(row_out)  # this is much shorter and simpler code than the for loop above!

# apply the function my_fun to each column of m
col_out <- apply(m,2,my_fun)
print(col_out)

# apply the function my_fun to each element of the matrix
apply(m,c(1,2),my_fun)


# use apply functions with anonymous function
apply(m, 1, function(x) max(sin(x) + x))   # rows
apply(m, 2, function(x) max(sin(x) + x))   # columns
apply(m, c(1,2), function(x) max(sin(x) + x))   # entire matrix


# What happens to outputs of variable length?
# first, modify code to simply reshuffle the order of the elements in each row (or column)

apply(m, 1, sample)  # this switches the number of rows and columns. not what we wanted!
# caution! array output from apply goes into the columns. Better to do the following:
t(apply(m,1,sample))  # using the t for transpose gives me the output I want.


# Create a function to choose a random number of elements from each row and 
# pick them in random order
apply(m, 1, 
      function(x) x[sample(1:length(x), 
                           size = sample(1:length(x)))])
# output comes out as list. each item of the list is a vector of random numbers

# apply may output a vector, a matrix, or a list... it depends on what the function generates



#  Task #2 -------------------------------------------------------------------------


# Second task: apply a function to every column of a data frame

# build data frame
df <- data.frame(x = runif(20), y = runif(20), z = runif(20))


# for loop solution #

# output vector
output <- vector("numeric", ncol(df))  # not a great method because it just generates zeroes
print(output)  

output <- rep(NA, ncol(df))  # preferred structure... better to fill with NAs
print(output)

# for loop
for (i in seq_len(ncol(df))) {
  output[i] <- sd(df[,i])/mean(df[,i])
}
print(output) # output is the coefficient of variation of all three columns in our df


# lapply solution #
# use lapply to do the same thing
# lapply(X,FUN,...)

# X = a vector (atomic or list)
# FUN = a function applied to each element of the list or vector
# note: a data frame is a list of vectors
# ... = additional inputs to FUN

# output of lapply is always a list
# names are retained from original structure

summary_out <- lapply(df, 
                      function(x) sd(x)/mean(x))
print(summary_out)

# other functions that work the same way, but not as consistent/easy as lapply (not worth using)
# 1. sapply tries to simplify output to a vector or a matrix  (s = simplify)
# 2. vapply requires you specify the output formats  (v = verify)


# challenge: what if not all dataframe columns are of the same type?

treatment <- rep(c("Control", "Treatment"), each = nrow(df)/2)
print(treatment)

df2 <- cbind(treatment,df)
print(df2)


# for loop solution #

output2 <- rep(NA, ncol(df2))

for (i in seq_len(ncol(df2))) {
  if(!is.numeric(df2[,i])) next   # this line jumps the non-numeric columns
  output2[i] <- sd(df2[,i])/mean(df2[,i])
}
print(output2)   # output is a vector


# lapply solution #
z <- lapply(df2, 
       function(x) if(is.numeric(x)) sd(x)/mean(x))
print(z)   # output is a list
unlist(z)



# Task #3 ------------------------------------------------------------------------

# Third task: split/apply/combine for groups in a data frame

# use df2 for this, and split over the two groups (control, treatment)


# for loop solution # 

g <- unique(df2$treatment)
print(g)

out_g <- rep(NA, length(g))
names(out_g) <- g
print(out_g)

for (i in seq_along(g)) {
  df_sub <- df2[df2$treatment==g[i],]  # split statement
  out_g[i] <- sd(df_sub$x)/mean(df_sub$x)  # make calculation and save to output
}
print(out_g)


# tapply solution #
# use tapply to do the same thing (t = tagged)
# tapply(X,INDEX,FUN,...)

# X = vector (atomic or list) to be subsetted
# INDEX = list of factors (or character strings) designating one or more groups in the data
# ... = additional inputs to FUN

z <- tapply(X = df2$x,
            INDEX = df2$treatment,
            FUN = function(x) sd(x)/mean(x))
print(z) 
# note how concise the tapply function is compared to the for loop solution!!



# Task #4 -----------------------------------------------------------------------------

# Fourth task: replicate a stochastic process

# in this case, we will write our own function, instead of using anonymous functions
# -------------------------------------------------------------------------------
# FUNCTION: pop_gen
# description: generate a stochastic population track of varying length
# inputs: number of time steps
# outputs: numeric vector of population size
#################################################################################
pop_gen <- function(z = sample.int(n=10, size=1)) {
  
  n <- round(1000*runif(z))

return(n)

} # end of pop_gen
# -------------------------------------------------------------------------------
pop_gen()  # output is a series of integers that indicate population size


# for loop solution # 

n_reps <- 20
list_out <- vector("list", n_reps)
head(list_out)

for (i in seq_len(n_reps)) {
  list_out[i] <- list(pop_gen())
}
head(list_out)


# replicate solution (apply family) #
# use replicate() to do the same thing
# replicate(n,expr)

# n = number of times to repeat the operation
# expr = a function (base or user-defined) ; 
#     = an expression (anonymous function without the function call)

z_out <- replicate(n=5, pop_gen())
print(z_out)



# Task #5 -------------------------------------------------------------------------

# Fifth task: sweep a function with all parameter combinations

# species area function, where S = cA^z
# this has parameters c, z, and A as inputs
# S is the output

# first, set up data frame with all possible parameter combinations
a_pars <- 1:10
c_pars <- c(100,150,125)
z_pars <- c(0.10,0.16,0.26,0.30)
df <- expand.grid(a=a_pars, c=c_pars, z=z_pars)
head(df)


# for loop solution #

df_out <- cbind(df,s=NA)
head(df_out)

for (i in seq_len(nrow(df))) {
  df_out$s[i] <- df$c[i]*(df$a[i]^df$z[i])
}
head(df_out)


# mapply solution #
# using mapply to do the same thing (m=multiple)
# mapply(FUN,...,MoreArgs)

# FUN = function to be used (note that its first in the list!)
# ... = arguments to vectorize over (vectors or lists)
# MoreArgs = bundled list of additional arguments applied to all iterations of FUN

df_out$s <- mapply(function(a, c, z) c*(a^z), 
                   df$a, df$c, df$z)    # MoreArgs not used here
head(df_out)


# what is the correct way to do this task? For loop or mapply? --->  actually none of the above!
# the correct solution for this particular problem is that there is no need for a function at all
# we can simply vectorize this operation, which R is really good at

df_out$s <- df_out$c*(df_out$a^df_out$z)
head(df_out)

# So, whenever you're looking at a problem where you have to do repeat things, the
# first question you wanna ask yourself is: Do I even need to bother with a 
# for loop or an apply function, or, as in this case, can I just carry out a vectorized
# operation on the individual elements?


# With the apply functions, we don't have to set up output containers to hold things.
# We can just operate the functions, and the output is created by the function itself.
# This is a huge advantage and it is the basis of functional programming.




