% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/regularisation.R
\name{grou_regularisation}
\alias{grou_regularisation}
\title{Regularisation schemes for the GrOU process that implements
a Lasso, Ridge or Adaptive Lasso penalty.}
\usage{
grou_regularisation(
  times,
  data,
  thresholds = NA,
  lambda = NA,
  reg = "l1",
  div = 1e+05,
  output = "vector",
  gamma = NA,
  cut_off = NA,
  use_scaling = FALSE
)
}
\arguments{
\item{times}{Times at which data is given}

\item{data}{Values to compute the MLE with.}

\item{thresholds}{Jump threshold values.}

\item{lambda}{Penalty parameter.}

\item{reg}{Type of penalty (\code{l1}, \code{l2} or \code{adaptive}).}

\item{div}{Batch size/divisor to avoid large memory allocation.}

\item{output}{Output type: either "vector"or "matrix".}

\item{gamma}{Adaptive MLE scaling parameter.}

\item{cut_off}{Sparsity proportion, defaults to \code{NA}.}

\item{use_scaling}{Brownian motion covariance matrix scaling
in the likelihood.}
}
\value{
Regularised dynamics matrix.
}
\description{
Regularisation schemes for the GrOU process that implements
a Lasso, Ridge or Adaptive Lasso penalty.
}
\examples{
n <- 1000
d <- 10
times <- seq(n)
delta_time <- 0.01
noise <- matrix(rnorm(n * d, sd = sqrt(delta_time)), ncol = d)
data <- construct_path(
  diag(d),
  noise = noise, y_init = rep(0, d), delta_time = delta_time
)
\donttest{
    grou_regularisation(times = times, data = data, lambda = 1, div = 1e2)
}
}
