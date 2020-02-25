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

