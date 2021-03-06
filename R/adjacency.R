# This script attempts to provide construction functions for
# 4 main types of networks;
# They cover the following properties
#   - max(degree) = 0, 2, 4/8, d-1

#' Checks that \code{|theta_1| <= theta_2}.
#' @param theta_1 Off-diagonal value or network effect.
#' @param theta_2 Diagonal value or momentum effect.
#' @return An error if \code{|theta_1| > theta_2}, nothing happens otherwise.
check_thetas <- function(theta_1, theta_2) {
  assertthat::assert_that(
    theta_2 > abs(theta_1),
    msg = paste("In", match.call()[1], "must verify theta_2 > abs(theta_1)")
  )
}

#' Creates adjacency matrix with max degree zero.
#' @param d Number of nodes.
#' @param theta_1 Off-diagonal value or network effect.
#' @param theta_2 Diagonal value or momentum effect.
#' @return Adjacency `d x d` matrix of a graph with max degree zero.
#' @examples
#' d <- 10
#' theta_2 <- 2
#' theta_1 <- 1
#' isolated_network(d = d, theta_1 = theta_1, theta_2 = theta_2)
#' @export
isolated_network <- function(d, theta_1, theta_2) {
  # theta_2 is the diagonal element
  return(theta_2 * diag(d))
}

#' Creates adjacency matrix with min degree one and max degree two.
#' @param d Number of nodes.
#' @param theta_1 Off-diagonal value or network effect.
#' @param theta_2 Diagonal value or momentum effect.
#' @param directed Boolean if lower triangular is the opposite
#'     to the upper triangular matrix.
#' @return Adjacency `d x d` matrix of a graph with max degree two
#'     and minimum one.
#' @examples
#' d <- 10
#' theta_2 <- 2
#' theta_1 <- 1
#' polymer_network(d = d, theta_1 = theta_1, theta_2 = theta_2)
#' @export
polymer_network <- function(d, theta_1, theta_2, directed = FALSE) {
  check_thetas(theta_1, theta_2)
  # theta_2 is the diagonal element
  mat_temp <- augmented_diag(d = d, offset = 1) + if (directed) {
    -augmented_diag(d = d, offset = 1)
  } else {
    augmented_diag(d = d, offset = -1)
  }
  mat_temp <- theta_1 * mat_temp / rowSums(abs(mat_temp))
  return(mat_temp + isolated_network(d = d, theta_2 = theta_2))
}

#' Lattice/grid-like network with max degree of four across all nodes.
#' @param d Number of nodes.
#' @param theta_1 Off-diagonal value or network effect.
#' @param theta_2 Diagonal value or momentum effect.
#' @param directed Boolean if lower triangular is the opposite
#'     to the upper triangular matrix.
#' @return A `d x d` adjacency matrix of a lattice network.
#' @examples
#' d <- 10
#' theta_2 <- 2
#' theta_1 <- 1
#' lattice_network(d = d, theta_1 = theta_1, theta_2 = theta_2)
#' @importFrom copCAR adjacency.matrix
#' @export
lattice_network <- function(d, theta_1, theta_2, directed = FALSE) {
  # TODO add directed for it
  check_thetas(theta_1, theta_2)

  if (directed) stop("NotImplementedError")
  d_real <- round(sqrt(d))
  net_matrix <- adjacency.matrix(d_real)
  if (d_real^2 < d) {
    net_matrix <- rbind(
      net_matrix,
      matrix(0, nrow = d - d_real^2, ncol = d_real * d_real)
    )
    net_mat_tmp <- rbind(
      matrix(0, ncol = d - d_real^2, nrow = d_real * d_real),
      diag(1, nrow = d - d_real^2)
    )
    net_matrix <- cbind(net_matrix, net_mat_tmp)
  } else {
    stop(paste(
      "Cannot generate a lattice for d =",
      d, "- choose a larger value for `d`."
    ))
  }

  net_matrix <- theta_1 * row_normalised(net_matrix)
  diag(net_matrix) <- theta_2

  return(net_matrix)
}

#' Fully-connected graph.
#' @param d Number of nodes.
#' @param theta_1 Off-diagonal value or network effect.
#' @param theta_2 Diagonal value or momentum effect.
#' @param directed Boolean if lower triangular is the opposite
#'     to the upper triangular matrix.
#' @return A `d x d` adjacency matrix of a fully-connected graph.
#' @examples
#' d <- 10
#' theta_2 <- 2
#' theta_1 <- 1
#' fully_connected_network(d = d, theta_1 = theta_1, theta_2 = theta_2)
#' @export
fully_connected_network <- function(d, theta_1, theta_2, directed = FALSE) {
  net_temp <- matrix(1, d, d)
  net_temp <- theta_1 * row_normalised(net_temp)

  if (directed) {
    net_temp[lower.tri(net_temp)] <- -net_temp[lower.tri(net_temp)]
  }

  diag(net_temp) <- theta_2
  return(net_temp)
}
