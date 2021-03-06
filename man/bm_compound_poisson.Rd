% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/path_generation.R
\name{bm_compound_poisson}
\alias{bm_compound_poisson}
\title{Generates a (correlated) Brownian motion path with
correlated but unsynchronised Gaussian jumps.}
\usage{
bm_compound_poisson(
  n,
  sigma,
  jump_sigma,
  n_jumps,
  delta_time,
  synchronised = FALSE
)
}
\arguments{
\item{n}{Length of the path}

\item{sigma}{Correlation matrix for the Brownian part.}

\item{jump_sigma}{Correlation matrix for the jump part.}

\item{n_jumps}{Number of jumps.}

\item{delta_time}{Time step.}

\item{synchronised}{Boolean to synchronise all jumps or not.}
}
\value{
A BM path with Correlated Gaussian jumps
}
\description{
Generates a (correlated) Brownian motion path with
correlated but unsynchronised Gaussian jumps.
}
\examples{
n <- 1000
sigma <- matrix(c(1.0, 0.2, 0.2, 0.2, 1.0, 0.2, 0.2, 0.2, 1.0), 3, 3)
jump_sigma <- sigma
n_jumps <- 50
delta_time <- 0.5
bm_compound_poisson(n, sigma, jump_sigma, n_jumps, delta_time)
}
