neuralNetworkLBFGSB <- function(p, df) {
  n <- nrow(df)

  GeLu <- function(x) {
    return(x * pnorm(x))
  }

  GeLu_prime <- function(x) {
    return(pnorm(x) + x * dnorm(x))
  }

  objective_function <- function(alpha) {
    alpha_0 <- alpha[1]
    alpha_j <- alpha[2:(p+1)]
    alpha_pj <- alpha[(p+2):(2*p+1)]
    alpha_2pj <- alpha[(2*p+2):(3*p+1)]

    Xi <- df$X
    Yi <- df$Y
    inner_terms <- sapply(1:p, function(j) alpha_j[j] * GeLu(alpha_pj[j] + alpha_2pj[j] * Xi))
    predictions <- alpha_0 + rowSums(inner_terms)

    return(mean((Yi - predictions)^2))
  }

  gradient_function <- function(alpha) {
    alpha_0 <- alpha[1]
    alpha_j <- alpha[2:(p+1)]
    alpha_pj <- alpha[(p+2):(2*p+1)]
    alpha_2pj <- alpha[(2*p+2):(3*p+1)]

    Xi <- df$X
    Yi <- df$Y
    n <- length(Yi)

    grad_alpha_0 <- -2 * mean(Yi - (alpha_0 + rowSums(sapply(1:p, function(j) alpha_j[j] * GeLu(alpha_pj[j] + alpha_2pj[j] * Xi)))))

    grad_alpha_j <- sapply(1:p, function(j) {
      -2 * mean((Yi - (alpha_0 + rowSums(sapply(1:p, function(k) alpha_j[k] * GeLu(alpha_pj[k] + alpha_2pj[k] * Xi))))) *
                  GeLu(alpha_pj[j] + alpha_2pj[j] * Xi))
    })

    grad_alpha_pj <- sapply(1:p, function(j) {
      -2 * mean((Yi - (alpha_0 + rowSums(sapply(1:p, function(k) alpha_j[k] * GeLu(alpha_pj[k] + alpha_2pj[k] * Xi))))) *
                  alpha_j[j] * GeLu_prime(alpha_pj[j] + alpha_2pj[j] * Xi))
    })

    grad_alpha_2pj <- sapply(1:p, function(j) {
      -2 * mean((Yi - (alpha_0 + rowSums(sapply(1:p, function(k) alpha_j[k] * GeLu(alpha_pj[k] + alpha_2pj[k] * Xi))))) *
                  alpha_j[j] * GeLu_prime(alpha_pj[j] + alpha_2pj[j] * Xi) * Xi)
    })

    return(c(grad_alpha_0, grad_alpha_j, grad_alpha_pj, grad_alpha_2pj))
  }

  initial_alpha <- runif(3 * p + 1, min = -1, max = 1)
  lower_bounds <- rep(-10, 3 * p + 1)
  upper_bounds <- rep(10, 3 * p + 1)

  result <- optim(
    par = initial_alpha,
    fn = objective_function,
    gr = gradient_function,
    method = "L-BFGS-B",
    lower = lower_bounds,
    upper = upper_bounds,
    control = list(maxit = 450, factr = 1e8, pgtol = 1e-7)
  )

  return(result)
}
