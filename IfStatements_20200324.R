# -------------------------------------------------------------------------------
# Booleans and if/else control structures 
# 24 Mar 2020
# AAR
# -------------------------------------------------------------------------------
# 

# review of boolean operators ---------------------------------------------

# Simple inequality
# uses logical operators
5 > 3
5 < 3
5 >= 5
5 <= 5
5 == 3 # be sure to use double ==
5 != 3 # not equal to

# Compound statements use & or |

# use & for AND
FALSE & FALSE
FALSE & TRUE
TRUE & TRUE  # both sides have to be true to generate a true result at the console
5>3 & 1!=2
1==2 & 1!=2

# use | for OR
FALSE | FALSE
FALSE | TRUE
TRUE | TRUE
1==2 | 1!=2

# boolean operators work with vectors

1:5 >3

a <- 1:10
b <- 10:1

a > 4 & b > 4
sum(a > 4 & b > 4) # coerces booleans to numeric values

# evaluate all elements and give a vector of true/false
a < 4 & b > 4

# "long" form && evaluates only the first element
# i.e. evaluates only the first comparison that gives a boolean
a < 4 && b > 4

# there is also a "long" form for or ||

# vector result (short)
a < 4 | b > 4
# single boolean result
a < 4 || b > 4

# xor for exclusive "or" testing of vectors
# works for (TRUE FALSE) but not for (FALSE FALSE) or (TRUE TRUE)

a <- c(0,0,1)
b <- c(0,1,1)
xor(a,b)

# by comparison with ordinary |
a | b



# Set operations ----------------------------------------------------------

# boolean algebra on entire sets of atomic vectors (numeric, logical, character strings...)

a <- 1:7
b <- 5:10

# union function to get all elements (OR for a set)
union(a,b) # does not show repeated elements

# intersect function to get common elements (AND for a set)
intersect(a,b) # only shows elements that are repeated in both vectors

# setdiff function to get distinct elements in a
setdiff(a,b)
# setdiff function to get distinct elements in b
setdiff(b,a)

# setequal function to check for identical elements
setequal(a,b)

# more generally, to compare any two objects
z <- matrix(1:12, nrow=4, byrow=TRUE)
z1 <- matrix(1:12, nrow=4, byrow=FALSE)

# this just compares element by element
z == z1

identical(z,z1)
z1 <- z
identical(z,z1)

# most useful in if statements is %in% or is.element
# these are equivalent, but %in% is prefered to improve readability

d <- 12
d %in% union(a,b)
is.element(d, union(a,b))

# avoid long compound OR statements
a <- 2
a==1 | a==2 | a==3   # avoid this!
a %in% c(1,2,3)  # this is better

# check for partial matching with vector comparisons
a <- 1:7

d <- c(10,12)
d %in% union(a,b)  # each item of d is compared one at a time to the union of a and b
d %in% a


# if statements -----------------------------------------------------------

# anatomy of if statements

# if (condition) expression
# condition -> boolean statement that has to generate a single true/false value
# expression -> code that will be executed if the condition is met
# if the condition is not met, the expression will not be evaluated

# if (condition) expression1 else expression2
# in this case, if the condition is not met, it executes the second expression

# if (condition1) expression1 else if (condition2) expression2 else expression3
# in this case, the final unspecified else captures the rest of the unspecified conditions

# else statements MUST appear on the same line as the previous expression

# instead of a single expression, we can use curly brackets to execute a set of 
# lines when the condition is met {}


z <- signif(runif(1), digits=2)
print(z)

# simple if statement with no else
if (z > 0.5) cat(z, "is a bigger than average number","\n")

# compound if statement with 3 outcomes (2 if statements)

if (z > 0.8) cat(z, "is a large number","\n") else
  if (z < 0.2) cat(z, "is a small number","\n") else
  {cat(z, "is a number of typical size","\n")
    cat("z^2 =", z^2, "\n")}

# if statements wants a single boolean value (TRUE FALSE)
# if you give an if statement a vector of booleans, it will only operate on the
# very first element in that vector

z <- 1:10

# this does not do anything
if (z > 7) print(z)

# probably not what you want
if (z < 7) print(z)

# use subsetting! its a better an more elegant solution than the two above
print(z[z<7])


# ifelse function ---------------------------------------------------------

# format

# ifelse(test,yes,no)
# test -> an object that can be coerced into a logical TRUE/FALSE
# yes -> returns values for TRUE elements in the test
# no -> returns values for FALSE elements in the test

# Suppose we have an insect population in which each female lays an average of
# 10.2 eggs, following a Poisson distribution (lambda=10.2). However, there is a
# 35% chance of parasitism, in which case no eggs are laid. Here is a random sample
# of eggs laid for a group of 1000 individuals.

tester <- runif(1000) # start with random uniform elements
eggs <- ifelse(tester > 0.35, rpois(n=1000,lambda=10.2),0)
hist(eggs)

# Suppose we have a vector of probability values (perhaps from a simulation). We 
# want to highlight significant values in the vector for plotting

p_vals <- runif(1000)
z <- ifelse(p_vals < 0.025, "lower_tail", "non_sig")
z[p_vals >= 0.975] <- "upper_tail"
table(z)


# Here is how Gotelli would do it - using subsetting instead of ifelse 
z1 <- rep("non_sig", 1000)
z1[p_vals <= 0.025] <- "lower_tail"
z1[p_vals >= 0.975] <- "upper_tail"
table(z1)











































































