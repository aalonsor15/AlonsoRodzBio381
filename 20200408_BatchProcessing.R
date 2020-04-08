# -------------------------------------------------------------------------------
# File creation and batch processing 
# 07 Apr 2020
# AAR
# -------------------------------------------------------------------------------
# 

# Batch processing --> when you have a lot of files, you don't want to have to tinker
# with the code for each file. If some of the files have the data changed and others
# do not, this is a big headache and its very easy to make mistakes. Batch processing
# will work with a number of files to carry out the same set of automated calculations
# on each of them and then save all of the information into a summary.
# When you set it up this way, it means that you can delete, add or change files and then
# run your batch commands again and get a clean output of what you need. 


# Useful commands for file management -----------------------------

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
                        formatC(i, width=3, format="d", flag="0"),
                        ".csv", sep="")
    
    # set up data file, incorporate time stamp and minimal metadata
    write.table(cat("# Simulated random data file for batch processing",
                    "\n", "# timestamp: ", as.character(Sys.time()),
                    "\n", "# AAR", "\n", "# -----------------------",
                    "\n", "\n", file = file_label, 
                    row.names = "", col.names = "",
                    sep = ""))
    
    # now add the data frame
    write.table(x = df, file = file_label, sep = ",", 
                row.names = FALSE, append = TRUE)
  
    } # end of for loop
} # end of file_builder
# -------------------------------------------------------------------------------

# -------------------------------------------------------------------------------
# FUNCTION: reg_stats
# description: fits linear models, extract model stats
# inputs: 2-column data frame (x and y)
# outputs: slope, p-value, and r2
#################################################################################
reg_stats <- function(d = NULL) {
  if (is.null(d)) {
    x_var <- runif(10)
    y_var <- runif(10)
    d <- data.frame(x_var, y_var)
  }
  
  . <- lm(data=d, d[,2]~d[,1])
  . <- summary(.)
  stats_list <- list(Slope = .$coefficients[2,1],
                     pVal = .$coefficients[2,4],
                     r2 = .$r.squared)
  
return(stats_list)

} # end of reg_stats
# -------------------------------------------------------------------------------


# body of program ---------------------------------------------------------

library(TeachingDemos)
char2seed("polar bear")

#################################################################################
# Global variables

file_folder <- "RandomFiles/"
n_files <- 100
file_out <- "StatsSummary.csv"

#################################################################################
# Create random data sets

dir.create(file_folder)   # create folder in my wd
file_builder(file_n = n_files)   # create 100 random data files inside my new folder
file_names <- list.files(path = file_folder)

# Create a data frame to hold summary file statistics

ID <- seq_along(file_names)
file_name <- file_names
slope <- rep(NA, length(file_names))
p_val <- rep(NA, length(file_names))
r2 <- rep(NA, length(file_names))

stats_out <- data.frame(ID, file_name, slope, p_val, r2)

#################################################################################
# batch process by looping through individual files and operating on them

for (i in seq_along(file_names)) {
  data <- read.table(file = paste(file_folder, file_names[i], sep = ""),
                     sep = ",", header = TRUE)
  d_clean <- data[complete.cases(data),]  # subset for clean cases (remove NAs)
  . <- reg_stats(d_clean)  # pull out regression stats from clean file
  stats_out[i,3:5] <- unlist(.)  # unlist, copy into last 3 columns
}

# set up an output file, incorporate time stamp and minimal metadata

write.table(cat("# Summary stats for ",
                "batch processing of regression models",
                "\n", "timestamp: ", as.character(Sys.time()),
                "\n", file = file_out, 
                row.names = "", col.names = "", sep = ""))

# now add the data frame
write.table(x = stats_out, file = file_out,
            row.names = FALSE, col.names = TRUE,
            sep = ",", append = TRUE)




