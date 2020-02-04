# Basic examples of data types and their uses
# 4 Feb 2020
#AAR

# -------------------------------------------------------------------------

# Using the assignment operator
x <- 5 # preferred
y = 4 # legal but not used except in function defaults, due to readability
y = y + 1 # should be avoided
y <- y + 1 # this is better than the above because its evident that you're 
          # asigning something to the y variable
y
print(y) #will work no matter where you are in the r space, whereas the one 
        # above only works on R script and not in Markdown


# -------------------------------------------------------------------------

# variable names
z <- 3 # use lower case
plantHeight <- 3 # camel case naming, but not that easy to read
plant.height <- 3 # avoid using periods in variable names because periods 
                  # are sometimes used in other ways and could create conflict
plant_height <- 3 # snake case - preferred naming strategy, creates most 
                  # readable code
. <- # use exclusively for temporary variables to pass the contents from one 
        # line to the next. could be better than piping
  

# -------------------------------------------------------------------------
# DATA TYPE: ATOMIC VECTORS

# combine or concatenate function 
z <- c(3.2, 5, 5, 6) # all elements should be of the same type
print(z)
typeof(z) # see what data type is assigned to my vector
is.numeric(z) # ask if my vector is numeric
is.character(z) 

# character variable bracketed by quotes (single or double)
z <- c("perch", "striped bass", "trout")  # character string
print(z)

z <- c("this is one 'character string'", "and another") # I can use both 
                      #types of brackets, as long and I'm consistent.
print(z)

z <- c(c(2,3),c(4.4,6))
print(z)

z <- c(TRUE,FALSE,FALSE) # boolean vector
print(z)
typeof(z)
is.integer(z)


# -------------------------------------------------------------------------

# Properties of atomic vectors

# has a unique type
typeof(z)
is.logical(z)

# has a specified length
length(z)

# can have optional names
z <- runif(5)
print(z)
names(z)
names(z) <- c("chow",
              "pug",
              "beagle",
              "greyhound",
              "akita")
print(z)
z[3] # get the third element in the list, a single element
z[c(3,4)] #get third and fourth element. doing z[3,4] doesn't 
          # work because that is for matrices [column,row]
z[c("beagle","greyhound")]
z[c(3,3,3)]

# add names when variable is first built (with or without quotes)
z2 <- c(gold = 3.3, silver = 10, lead = 2)
print(z2)
# to reset the names
names(z2) <- NULL

# name some elements, but not others
names(z2) <- c("copper","zinc")
print(z2)


# -------------------------------------------------------------------------

# NA for missing data
# NA values represent missing data. 
# imporant: do not use 0 (ceros) for missing data.

z <- c(3.2,3.3,NA)
typeof(z)
length(z)
typeof(z[3]) #this shows that the NA is still read as doubles, because it assumes
            # the same data type as the rest of the vector. So NAs can be hard to find
z1 <- NA
typeof(z1)
is.na(z) # boolean to find NA. good way to find NAs in my vector
!is.na(z) # boolean to find NOT NA
mean(z) # does not compute because of the NA in my vector
mean(!is.na(z)) # will compute something, but its not correct because it operates on booleans
mean(z[!is.na(z)]) # correct way to exclude NA from mean calculation

# NaN, -Inf, Inf --- I could also get these from numeric division
z <- 0/0  # NaN
print(z)
typeof(z)
z <- 1/0  # Inf
print(z)
z <- -1/0  # -Inf
print(z)

# null is nothing
z <- NULL
typeof(z)
length(z)
is.null(z)

# -------------------------------------------------------------------------

# Features of atomic vectors... 3 important rules

# RULE 1: Coercion
# All atomics are of the same type
# However, if some elements are different, R coerces them.
# logical is coerced into integer, integer is coerced into double, 
  # and double is coerced into character

z <- c(0.1, 5, "0.2") # all elements are read as characters, even though 
                      # there are 2 numbers and 1 character
typeof(z)
print(z)

# Use coercion for useful calculations
a <- runif(10)
print(a)
a > 0.5 # will check if all my numbers are higher than 0.5 and return
        # true or false
sum (a > 0.5) # how many elements in my vector are higher than 0.5
mean (a > 0.7) # what is the proportion of values that are greater than 0.7


# Qualifying exam question
# In a normal distribution, approximately what percent of observations
  # from a normal (0,1) are larger than 2.0

mean(rnorm(1000000) > 2)

# RULE 2: Vectorization
z <- c(10,20,30)
z + 1 # carry out operation on each element of the vector
z2 <- c(1,2,3)
z + z2 # will match each element with the one in the same location on the other vector
z^2

# RULE 3: Recycling
z <- c(10,20,30)
z2 <- c(1,2)
z + z2 # If vectors are not of the same length, it will start the calculation over on the
      # shorter vector and will give me a warming message.
