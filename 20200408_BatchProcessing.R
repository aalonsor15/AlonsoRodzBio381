# -------------------------------------------------------------------------------
# File creation and batch processing 
# 07 Apr 2020
# AAR
# -------------------------------------------------------------------------------
# 



# Useful console commands for file management -----------------------------

# getwd()     --> check my working directory 
# list.files()    --> see files inside my working directory
# list.files("my_folder/")   --> see files inside folder in my working directory
# dir.create("new_folder")   --> create new folder in my working directory
# dir.create("my_folder/new_folder")  --> create new folder inside an existing folder in my wd
# dir.create("new_folder1/new_folder2/", recursive=TRUE)   --> create new folder within a new folder in my wd


# -------------------------------------------------------------------------

# -------------------------------------------------------------------------------
# FUNCTION: file_builder
# description: create a set of random files for regression
# inputs: file_n = number of data files to create
#         file_folder = name of folder for random files
#         file_size = c(min,max) number of rows in the file
#         file_NA = average number of NA values per column
# outputs: creates a set of random files
#################################################################################
file_builder <- function(file_n = 10,
                         file_folder = "RandomFiles/",
                         file_size = c(15,100),
                         file_NA = 3) {
  
  for (i in seq_len(file_n)) {
    file_length <- sample(file_size[1]:file_size[2], size=1)
    var_x <- runif(file_length) # create random x
    var_y <- runif(file_length) # create random y
    df <- data.frame(var_x, var_y)  # bind into a data frame
    bad_vals <- rpois(n=1, lambda=file_NA)  # determine NA number
    df[sample(nrow(df), size=bad_vals), 1] <- NA
    df[sample(nrow(df), size=bad_vals), 2] <- NA
    
    # create a label for the file name with padded ceroes
    file_label <- paste(file_folder, "ranFile", 
                        formatC)
  }

return("Checking...file_builder")

} # end of file_builder
# -------------------------------------------------------------------------------


