# Function structure and use
# 25 February 2020
# AAR


# -------------------------------------------------------------------------

# Everything in R is a function
sum(3,2) # "prefix" function
3 + 2  # an "operator", but it is actually a function
`+`(3,2) # rewritten as an "infix" function

y <- 3
print(y)

`<-`(yy,3)
print(yy)

# to see contents of a function, print it
print(read.table)
sd  # print function
sd(c(3,2)) # call function with parameters
sd()  # call function with no inputs



# Anatomy of a user-defined function --------------------------------------

# try to use a verb in the function name

function_name <- function(par_x=default_x,
                          par_y=default_y,
                          par_z=default_z) {
  
  # function body
  # lines of r code and annotation
  # may call other functions
  # can create functions
  # create local varibles
  
  return(z) # returns from the function a single element
  
} # ends function

function_name
function_name()
function_name(par_x = my_matrix,
              par_y = "Order",
              par_z = 1:10)

# RECOMENDATIONS - FUNCTION PRINCIPLES
# use prominent hash fencing around your function code
# give a header with function name, and brief 1 line description of input and output
# names inside functions can be short
# functions should be short and simple, no more than 1 screen full of text
# provide default values for all input parameters
# make default values using 1 or more of the random number generators (good way to test code)



# Building functions ------------------------------------------------------


#############################

# FUNCTION: hardy_weinberg
# input: an allele frequency p (0,1)
# output: p and the frequencies of genotypes AA AB BB


hardy_weinberg <- function(p = runif(1)) {
  q <- 1 - p
  f_AA <- p^2
  f_AB <- 2*p*q
  f_BB <- q^2
  vec_out <- list(p = p, 
                  f_AA = f_AA,
                  f_AB = f_AB,
                  f_BB = f_BB)
  return(vec_out) # technically we don't need to use return, but it helps for clarity
}

# Testing the function

hardy_weinberg()
hardy_weinberg(p=0.5) #variable is inside the function. not the best way
pp <- 0.6
hardy_weinberg(p=pp) #its better to asign the variable individually, instead of inside the function
print(hardy_weinberg)
print(hardy_weinberg(p=pp))



#############################

# FUNCTION: hardy_weinberg2
# input: an allele frequency p (0,1)
# output: p and the frequencies of genotypes AA AB BB


hardy_weinberg2 <- function(p = runif(1)) {
  if(p > 1.0 | p < 0.0) {     # vertical bracket | means or
    return("Function failure: p must be <=1 and >=0")
  }
  q <- 1 - p
  f_AA <- p^2
  f_AB <- 2*p*q
  f_BB <- q^2
  vec_out <- list(p = p, 
                  f_AA = f_AA,
                  f_AB = f_AB,
                  f_BB = f_BB)
  return(vec_out) # technically we don't need to use return, but it helps for clarity
}


# Testing the function

hardy_weinberg2()
hardy_weinberg(1.1)
hardy_weinberg2(1.1)
z <- hardy_weinberg2(1.1)
z # shows the error when you call z, not on the code above. 
# this is not ideal because you could carry the error around in your code without noticing


# 'stop' function for error tracking------------------------------------------------------

# use the 'stop' function for true error tracking
# its better than using return as in the function above, because it shows the error even 
# when assigning the function to a variable (z)


#############################

# FUNCTION: hardy_weinberg3
# input: an allele frequency p (0,1)
# output: p and the frequencies of genotypes AA AB BB


hardy_weinberg3 <- function(p = runif(1)) {
  if(p > 1.0 | p < 0.0) {     # vertical bracket | means or
    stop("Function failure: p must be <=1 and >=0")
  }
  q <- 1 - p
  f_AA <- p^2
  f_AB <- 2*p*q
  f_BB <- q^2
  vec_out <- list(p = p, 
                  f_AA = f_AA,
                  f_AB = f_AB,
                  f_BB = f_BB)
  return(vec_out) # technically we don't need to use return, but it helps for clarity
}

# Now it returns an error, even when we assign it to a variable (z)
hardy_weinberg3(1.1)
z <- hardy_weinberg3(1.1)



# -------------------------------------------------------------------------

# global variables: visible in all parts of code and declared in main body of the program

# local variables: visible only within the function. Declared in the function or passed
# to it through input parameters

# functions can "see" variables in global environment
# global environment cannot "see" variables in the function environment

my_func <- function(a=3, b=4) {
  z <- a + b
  return(z)
}
my_func()


my_func_bad <- function(a=3) {
  z <- a + b
  return(z)
}
my_func_bad() # returns error because b is not declared in the function
b <- 100
my_func_bad() # now it works because b was assigned above, but this is not a good way to code


my_func_ok <- function(a=3){
  bb <- 100
  z <- a + bb
  return(z)
}
my_func_ok()
print(bb) # we declared bb inside the function, so its not saved in the global environment


#############################

# FUNCTION: fit_linear
# fits simple regression line
# inputs: numeric vectors of predictor (x) and response (y)
# output: slope and p-value

fit_linear <- function(x=runif(20),
                       y=runif(20)) {
  my_mod <- lm(y~x)
  my_out <- list(slope=summary(my_mod)$coefficients[2,1],
                 p_val=summary(my_mod)$coefficients[2,4])
  plot(x=x,y=y)
  return(my_out)
}

# Testing the function

fit_linear()


#############################

# Creating a more complex input value

# FUNCTION: fit_linear2
# fits simple regression line
# inputs: numeric vectors of predictor (x) and response (y)
# output: slope and p-value

fit_linear2 <- function(p=NULL) {
  if(is.null(p)){
    p <- list(x=runif(20), y=runif(20))
  }
  my_mod <- lm(p$y~p$x)
  my_out <- list(slope=summary(my_mod)$coefficients[2,1],
                 p_val=summary(my_mod)$coefficients[2,4])
  plot(x=p$x,y=p$y)
  return(my_out)
}

# Testing the model

fit_linear2()
my_pars <- list(x=1:10, y=runif(10))
fit_linear2(p=my_pars)
fit_linear2(my_pars)

# use the do.call function to pass a list of parameters to a function

z <- c(runif(99),NA)
mean(z)
mean(x=z,na.rm = TRUE)
mean(x=z, na.rm = TRUE, trim = 0.5)
my_list <- list(x=z, na.rm=TRUE, trim=0.05)
mean(my_list) # does not work because the structure is not appropriate. use do.call instead
do.call(mean, my_list)



