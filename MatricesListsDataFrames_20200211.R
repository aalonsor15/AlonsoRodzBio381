# Working with matrices, lists, data frames
# 11 Feb 2020
# AAR

# -------------------------------------------------------------------------

library(ggplot2)


# Matrices ----------------------------------------------------------------

# A matrix is just an atomic vector reorganized into 2 dimensions
# Create a matrix with the matrix function

m <- matrix(data=1:12, nrow=4, ncol=3)
print(m)
m <- matrix(data=1:12, nrow=4)

# Use byrow=TRUE to change filling direction
m <- matrix(data=1:12, nrow=4, byrow=TRUE)
print(m)

# Use dim() function
dim(m) #check dimensions of my matrix

# Change dimensions of matrix
dim(m) <- c(6,2)
print(m)
dim(m) <- c(4,3)

# Individual row and column dimensions
nrow(m)
ncol(m)

# Length of atomic vector is still there
length(m)

# Add names to matrices
rownames(m) <- c("a","b","c","d")
print(m)
colnames(m) <- LETTERS[1:ncol(m)]
print(m)
rownames(m) <- letters[nrow(m):1]
print(m)

# Grabbing an entire atomic vector
z <- runif(3)
z[]

# Specify rows and columns, separated by a comma
m[2,3]   # [row,column]
m

# Choose row 2 and all columns in the matrix
m[2,]
m[,3]

# Print everything
print(m)
print(m[])
print(m[,])

# Another way to add names to my matrix. dimnames requires a list
dimnames(m) <- list(paste("Site",1:nrow(m),sep=""),
                    paste("Species",1:ncol(m),sep="_"))
print(m)

# Transpose a matrix
m2 <- t(m)
print(m2)

# Add a row to a matrix with rbind()
m2 <- rbind(m2,c(10,20,30,40))
print(m2)
rownames(m2)

# Call the function to get the atomic
rownames(m2)[4] <- "myfix"
print(m2)
rownames(m2)

# Access rows and columns with their names as well as index numbers
m2["myfix","Site3"]
m2[4,3]
m2[c("myfix","Species_1"),c("Site2","Site2")]

# cbind() will add a column to a matrix

# changing a matrix back to a vector
my_vec <- as.vector(m)
print(my_vec)


# Lists -------------------------------------------------------------------

# Lists are like atomic vectors (in that they are one dimensional) but each 
# element can hold different things of different types and sizes

my_list <- list(1:10,
                matrix(1:8,nrow=4,byrow=TRUE),
                letters[1:3],
                pi)
str(my_list)

# Try grabbing one of our list components
my_list[4]
my_list[4] - 3  #error
typeof(my_list[4])

# Single brackets always returns a list from a list!
typeof(my_list[[4]])

# Double bracket always extracts a single element of the correct type
my_list[[4]] - 3

# If a list has 10 elements, it is like a train with 10 cars
# [[5]] gives me the contents of car #5
# [c(4,5,6)] gives me a little train with cars 4, 5 and 6
# [5] a train with 1 car (#5)

my_list[[2]][2,2]

# Name list items as we create them
my_list2 <- list(Tester=FALSE, 
                 little_m=matrix(runif(9),nrow=3))
print(my_list2)
my_list2$little_m[2,3]
my_list2$little_m
t(my_list2$little_m)
my_list2$little_m[2,]
my_list2$little_m[2]

# Using a list to access output from a lineal model
y_var <- runif(10)
x_var <- runif(10)
my_model <- lm(y_var~x_var)
qplot(x=x_var, y=y_var)
print(my_model)
summary(my_model)
str(summary(my_model))

# Use the unlist() function to flatten the output of the model
z <- unlist(summary(my_model),recursive=TRUE)
print(z) #here you can look for the coefficient #s that correspond to the slope and p value
my_slope <- z$coefficients2
my_pval <- z$coefficients8
print(c(my_slope,my_pval))


# Data Frames -------------------------------------------------------------

# A data frame is a list of equal-lengthed vectors, each of which is a
# column in a data frame

# A data frame differs from a matrix only in that different columns may be
# of different data types

var_a <- 1:12
var_b <- rep(c("Con", "LowN", "HighN"), each=4)
var_c <- runif(12)
d_frame <- data.frame(var_a, var_b, var_c, stringsAsFactors = FALSE)
print(d_frame)
head(d_frame)
str(d_frame)

# Adding a new row to the data frame as a formatted list (because it has
# different data types)
new_data <- list(var_a=13,var_b="HighN",var_c=0.668)
str(new_data)
d_frame <- rbind(d_frame, new_data)
print(d_frame)

# Adding a new column to the data frame as an atomic vector (because its all
# the same data type)
new_var <- runif(nrow(d_frame))
d_frame <- cbind(d_frame,new_var)
head(d_frame)
