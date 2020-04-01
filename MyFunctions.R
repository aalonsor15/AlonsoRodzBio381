# -------------------------------------------------------------------------------
# Sourcing file to contain all our functions 
# 21 Mar 2020
# AAR
# -------------------------------------------------------------------------------
# 
# -------------------------------------------------------------------------------
# FUNCTION: get_data
# description: read in .csv file
# inputs: .csv file
# outputs: data frame
#################################################################################
get_data <- function(file_name=NULL) {
  
  if(is.null(file_name)) {
    df <- data.frame(ID=101:110,
                     var_a=runif(10),
                     var_b=runif(10))
  } else {
    df <- read.table(file=file_name,
                     header=TRUE,
                     sep=",",
                     stringsAsFactors = FALSE)
  }
  
  return(df)
  
} # end of get_data

# get_data()
# -------------------------------------------------------------------------------

# -------------------------------------------------------------------------------
# FUNCTION: calculate_stuff
# description: fits an OLS regression model
# inputs: x and y vectors of numeric; must be the same length
# outputs: entire model summary from lm
#################################################################################
calculate_stuff <- function(x_var=runif(10),
                            y_var=runif(10)) {
  
  df <- data.frame(x_var, y_var)
  reg_model <- lm(y_var~x_var, data=df)
  
  return(summary(reg_model))
  
} # end of calculate_stuff

# calculate_stuff()
# -------------------------------------------------------------------------------

# -------------------------------------------------------------------------------
# FUNCTION: summarize_output
# description: pull elements from the model summary list
# inputs: list from summary call of lm
# outputs: vector of regression residuals
#################################################################################
summarize_output<- function(z=NULL) {
  
  if(is.null(z)) {
    z <- summary(lm(runif(10)~runif(10)))
  }
  
  return(z$residuals)
  
} # end of summarize_output

# summarize_output()
# -------------------------------------------------------------------------------

# -------------------------------------------------------------------------------
# FUNCTION: graph_results
# description: graph data and fitted OLS line
# inputs: x and y vectors of numeric; must be of the same length
# outputs: creates graph
#################################################################################
graph_results <- function(x_var=runif(10),
                          y_var=runif(10)) {
  
  df <- data.frame(x_var, y_var)
  p1 <- qplot(data=df, 
              x=x_var,
              y=y_var,
              geom=c("smooth","point"))
  print(p1)
  message("Message: Regression graph created!")
  
} # end of graph_results

# graph_results()
# -------------------------------------------------------------------------------
