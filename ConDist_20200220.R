# Exploring continuous distributions
# 20 February 2020
# AAR

library(ggplot2)
library(MASS)

# Uniform -----------------------------------------------------------------

qplot(x=runif(n=100,min=1,max=6),
              color=I("black"),
              fill=I("goldenrod"))

qplot(x=runif(n=1000,min=1,max=6),
      color=I("black"),
      fill=I("goldenrod"))

qplot(x=sample(1:6,size=1000,replace=TRUE))


# Normal ------------------------------------------------------------------

my_norm <- rnorm(n=100, mean=100, sd=2)
qplot(x=my_norm,
      color=I("black"),
      fill=I("goldenrod"))

# problems with normal when mean is small
my_norm <- rnorm(n=100, mean=2, sd=2)
qplot(x=my_norm,
      color=I("black"),
      fill=I("goldenrod"))
toss_zeroes <- my_norm[my_norm>0]
qplot(x=toss_zeroes,
      color=I("black"),
      fill=I("goldenrod"))
mean(toss_zeroes)
sd(toss_zeroes)


# Gamma -------------------------------------------------------------------

# use for continuous data greater than zero

my_gamma <- rgamma(n=100, shape=1, scale=10)
qplot(x=my_gamma,
      color=I("black"),
      fill=I("goldenrod"))

# gamma with shape=1 is an exponential distribution with scale=mean
my_gamma <- rgamma(n=100, shape=1, scale=0.1)
qplot(x=my_gamma,
      color=I("black"),
      fill=I("goldenrod"))

# Increasing the shape parameter makes the distribution look more normal
my_gamma <- rgamma(n=100, shape=20, scale=1)
qplot(x=my_gamma,
      color=I("black"),
      fill=I("goldenrod"))

# The scale parameter changes both the mean and the variance of our distribution
# mean = shape * scale
# variance = shape * scale^2



# Beta --------------------------------------------------------------------

# Continuous distribution of values, but bounded between 0 and 1.
# It is analogous to the binomial, but with a continuos distribution 
# of possible values.

# p(data|parameters) ----> probability of the data given a set of parameters

# p(parameters|data) ----> maximum likelihood estimator of the parameters

# shape1 = number of successes + 1
# shape2 = number of failures + 1


my_beta <- rbeta(n=1000, shape1 = 5, shape2 = 5)
qplot(x=my_beta,
      color=I("black"),
      fill=I("goldenrod"))

my_beta <- rbeta(n=1000, shape1 = 50, shape2 = 50)
qplot(x=my_beta,
      color=I("black"),
      fill=I("goldenrod"))

# useful when we have a small amount of data
# example, a beta with 3 heads and no tails (coin tossed 3 times)

my_beta <- rbeta(n=1000, shape1 = 4, shape2 = 1)
qplot(x=my_beta,
      color=I("black"),
      fill=I("goldenrod"))

# if we have no data, we then get a uniform distribution
my_beta <- rbeta(n=1000, shape1 = 1, shape2 = 1)
qplot(x=my_beta,
      color=I("black"),
      fill=I("goldenrod"))

# shape and scale less than 1.0 gives u-shaped curve
my_beta <- rbeta(n=1000, shape1 = 0.2, shape2 = 0.1)
qplot(x=my_beta,
      color=I("black"),
      fill=I("goldenrod"))


# Estimate parameters from data -------------------------------------------

x <- rnorm(100,mean=92.5,sd=2.5)
qplot(x=x,
      color=I("black"),
      fill=I("goldenrod"))
fitdistr(x, "normal")
fitdistr(x, "gamma")
x_sim <- rgamma(n=1000, shape=1418, rate=15)
qplot(x=x_sim,
      color=I("black"),
      fill=I("goldenrod"))
