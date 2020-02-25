# Experimental Designs
# 20 February 2020
# AAR


# Class Notes -------------------------------------------------------------------------

# In an experiment, we have dependent and independent variable
# Hypothesis: Independent variable is driving or changing the dependent variable
# Null Hypothesis: Independent variable is not causing any changes to dep. var.

# How are these variables measured?
# All variables can be continuous or discrete

# 4 possibilities
# a. Independent continuous
# b. Independent discrete
# c. Dependent continuous
# d. Dependent discrete

# Both dep and indep are continuous (a-c): regression
# Indep discrete and dep continuous (b-c): ANOVA
# Both dep and indep are discrete(b-d): contingency table (freq of observations)
# Indep continuous and dep discrete(a-d): logistic regression


# Regression analysis -----------------------------------------------------

# Used when both the dependent and independent variables are continuous

n <- 50 # number of observations (rows)
var_a <- runif(n) # 50 random uniforms (independent variable)
var_b <- runif(n) # dependent variable
var_c <- 5.5 + var_a*10  # this variable will be correlated with var_a
# var_b should not be correlated with var_a, but var_c should be because of 
# how we coded it. 
# You can create fake variables like these to test whether your analyses are 
# working and are giving you real correlations in your data. Some analyses may
# be faulty and you could end up with significant p values that are not real.

id <- seq_len(n) # creates a sequence from 1 to n if n>0
reg_df <- data.frame(id,var_a,var_b,var_c)
str(reg_df)
head(reg_df)

# Regression Model
reg_model <- lm(var_b~var_a, data=reg_df)
reg_model #sparse output
str(reg_model)
head(reg_model$residuals)
summary(reg_model) #this is the output that we usually want 
summary(reg_model$coefficients)
str(summary(reg_model))

# to pull a list out of your model, with items of interest
z <- unlist(summary(reg_model)) 
print(z)
reg_sum <- list(intercept=z$coefficients1,
                slope=z$coefficients2,
                intercept_p=z$coefficients7,
                slope_p=z$coefficients8,
                r2=z$r.squared)
reg_sum$intercept # not I can see outputs of the model individually and use it 


# regression plot for data
# library(ggplot2)
reg_plot <- ggplot(data=reg_df, # ggplot requires data to be in a data frame.
                   aes(x=var_a,y=var_b)) +
                  geom_point() +
                  stat_smooth(method=lm,se=0.95)
print(reg_plot) 

# test this same method with var_c. It should show correlation with var_a
reg_model <- lm(var_c~var_a, data=reg_df)
reg_model #sparse output
str(reg_model)
head(reg_model$residuals)
summary(reg_model) #this is the output that we usually want 
summary(reg_model$coefficients)
str(summary(reg_model))


reg_plot <- ggplot(data=reg_df, # ggplot requires data to be in a data frame.
                  aes(x=var_a,y=var_c)) +
                  geom_point() +
                  stat_smooth(method=lm,se=0.95)
print(reg_plot)

# Basic ANOVA -------------------------------------------------------------

# First we are creating our data
n_group <- 3 # number of treatment groups
n_name <- c("control","treat1","treat2")
n_size <- c(12,17,9) #number of observations in our 3 groups
# we should not do an experiment with less than 10 observations in each group

n_mean <- c(40,41,60)
n_sd <- c(5,5,5) #ANOVA assumes that the variance is the same in all groups
t_group <- rep(n_name,n_size)
t_group
table(t_group)

id <- 1:(sum(n_size))
res_var <- c(rnorm(n=n_size[1], mean=n_mean[1], sd=n_sd[1]),
             rnorm(n=n_size[2], mean=n_mean[2], sd=n_sd[2]),
             rnorm(n=n_size[3], mean=n_mean[3], sd=n_sd[3]))
ano_data <- data.frame(id,t_group,res_var)
str(ano_data)


# anova model -------------------------------------------------------------

ano_model <- aov(res_var~t_group, data=ano_data)
print(ano_model)
summary(ano_model)
z<- summary(ano_model)
str(z)
aggregate(res_var~t_group,data=ano_data, FUN=mean)

unlist(z)
unlist(z)[7]
ano_sum <- list(Fval=unlist(z)[7],
                probF=unlist(z)[9])
print(ano_sum)


# ggplot for anova data ---------------------------------------------------

ano_plot <- ggplot(data = ano_data,
                   aes(x=t_group,
                       y=res_var,
                       fill=t_group)) + 
                  geom_boxplot()
print(ano_plot)
ggsave(filename = "plot2.pdf", plot=ano_plot, device="pdf")
# this last code saves the plot to my repository


# data frame for logistic regression --------------------------------------

# discrete y variable (0,1), continuous x variable

x_var <- sort(rgamma(n=200, shape=5, scale=5)) 
# sort puts the numbers in ascending order in the vector
head(x_var)
y_var <- sample(rep(c(0,1),each=100),prob=seq_len(200))
head(y_var)

l_reg_data <- data.frame(x_var,y_var)


# logistic regression model -----------------------------------------------

l_reg_model <- glm(y_var~x_var,
                   data=l_reg_data,
                   family=binomial(link=logit))
summary(l_reg_model)
summary(l_reg_model)$coefficients


# basic ggplot of logistic regression data --------------------------------

l_reg_plot <- ggplot(data=l_reg_data,
                     aes(x=x_var, y=y_var)) +
              geom_point() + 
              stat_smooth(method=glm,
                          method.args = list(family=binomial))
print(l_reg_plot)


# contingency table data --------------------------------------------------

# both x and y variables are discrete (=counts)
# integer counts of different groups

vec_1 <- c(50,66,22)
vec_2 <- c(120,22,30)
data_matrix <- rbind(vec_1,vec_2)
rownames(data_matrix) <- c("Cold", "Warm")
colnames(data_matrix) <- c("Aphaenogaster",
                           "Camponotus",
                           "Crematogaster")
str(data_matrix)
head(data_matrix)


# simple association test -------------------------------------------------

print(chisq.test(data_matrix))

# plotting contingency data -----------------------------------------------

# base R graphics
mosaicplot(x=data_matrix,
           col=c("goldenrod", "grey", "black"),
           shade=FALSE)

barplot(height=data_matrix,
        beside=TRUE,
        col=c("cornflowerblue", "tomato"))

# ggplot graphs
install.packages("tidyverse")
library(tidyverse)
d_frame <- as.data.frame(data_matrix) #because ggplot can only work on df
d_frame <- cbind(d_frame,list(Treatment=c("Cold", "Warm")))
d_frame <- gather(d_frame, key=Species, Aphaenogaster:Crematogaster, 
                  value=Counts)
data_matrix
head(d_frame)

p <- ggplot(data=d_frame,
            aes(x=Species, y=Counts, fill=Treatment)) +
        geom_bar(stat="identity",
                 position="dodge",
                 color=I("black")) +
        scale_fill_manual(values=c("cornflowerblue", "colar"))
print(p)
