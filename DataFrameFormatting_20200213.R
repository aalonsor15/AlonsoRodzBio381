# Finishing data frames, lists
# Formatting data
# 13 February 2020
# AAR


# -------------------------------------------------------------------------

# Matrix and data frame similarities and differences
z_mat <- matrix(data=1:30,ncol=3,byrow=TRUE)
z_dataframe <- as.data.frame(z_mat) #turning the matrix into a data frame

# structure
str(z_mat)
str(z_dataframe)

# Appearance
head(z_mat)
head(z_dataframe)

# Element referencing
z_mat[2,3]
z_dataframe[2,3]

# column referencing
z_mat[,2] #all rows, column 2
z_dataframe[,2]
z_dataframe$V2 #another way to get the same as the code above

# row referencing
z_mat[2,] #row 2, all columns
z_dataframe[2,]

# Specifying single elements is different! 
# Single element designators should be used with atomic vectors. It isn't 
# recommended for matrices or data frames because its not consistent.
z_mat[2] #I get object 2
z_dataframe[2] #I get all of column 2
# Its better to use the following code to get the same output as above.
z_mat[1,2]
z_dataframe$V2

# complete.cases for scrubbing atomic vectors
zD <- c(runif(3),NA,NA,runif(2))
zD

complete.cases(zD)
zD[complete.cases(zD)] # removes NA cases from atomic vector
zD[!complete.cases(zD)] # gives me only the NAs

# removing NAs from a matrix is a bit more difficult
m <- matrix(1:20,nrow=5)
m[1,1] <- NA
m[5,4] <- NA
m

#sweep out all rows with missing values
m[complete.cases(m),] #removes (drops) entire row that have an NA

#get complete cases for only certain columns
m[complete.cases(m[,c(1,2)]),] #drop row #1
m[complete.cases(m[,c(2,3)]),] #drop none of the rows 
m[complete.cases(m[,c(3,4)]),] #drop row #4
m[complete.cases(m[,c(1,4)]),] #drop row #1 and #4

# Techniques for assignments and subsetting matrices and data frames

m <- matrix(data=1:12,nrow=3)
dimnames(m) <- 
  list(paste("Species", LETTERS[1:nrow(m)],sep=""),
       paste("Site",1:ncol(m),sep = ""))
m

m[1:2,3:4]
m[c("SpeciesA","SpeciesB"),c("Site3","Site4")]

# Use blanks to pull all rows or columns
m[c(1,2),]
m[,c(1,2)]

# Use logicals for more complex subsetting
# e.g. select all columns that have totals > 15

colSums(m) > 15
m[,colSums(m)>15]

# Select all rows for which row total is equal to 22
m[rowSums(m)==22,]
m[rowSums(m)!=22,] #get the rows not equal to 22

m[,"Site1"]<3
m["SpeciesA",]<5
m[m[,"Site1"]<3,m["SpeciesA",]<5]

# Caution!!! Simple subscripting can change the data type!
z <- m[1,]
print(z)
str(z) #Now the structure of z is a long character string, instead of a matrix

# To avoid the above, use drop=FALSE to retain dimentions
z2 <- m[1, , drop=FALSE]
str(z2)


# extracting data frames ---------------------------------------------------

# Basic format is a csv file

my_data <- read.table(file="FirstData.csv", 
                      header=TRUE, 
                      sep=",",
                      stringsAsFactors = FALSE)
str(my_data)

#There is no need to save things as csv's once you have them.
#Instead, use saveRDS(), which will save an R object as a binary
saveRDS(my_data, file="my_RDSobject")
z <- readRDS("my_RDSobject")
z

# Other options: save and load commands. This saves the data in the memory. 
# Not recommended, because you save stuff from the environment with whatever name 
# you used, and you can't change it later.

