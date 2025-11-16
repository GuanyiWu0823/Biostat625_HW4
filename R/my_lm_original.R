#' Fit Linear Models (Pure R Implementation)
#'
#' @description
#' `my_lm_original()` fits a linear regression model using ordinary least squares (OLS),
#' implemented entirely in base R (no Rcpp acceleration).
#'
#' @usage
#' my_lm_original(formula, data)
#'
#' @param formula
#' a model formula specifying the regression structure.
#'
#' @param data
#' a `data.frame` containing variables used in the model.
#'
#' @details
#' This function performs the following computations:
#'
#' \itemize{
#'   \item Extracts model components (`model.frame`, `model.matrix`, `model.response`)
#'   \item Computes OLS estimator: \eqn{(X^T X)^{-1} X^T y}
#'   \item Derives standard errors, t-values, p-values
#'   \item Constructs residuals and fitted values
#' }
#'
#' It is functionally equivalent to `my_lm()`, but slower due to lack of Rcpp.
#'
#' @return
#' A list of class `"my_lm"` containing:
#'
#' \itemize{
#'   \item `coefficients`
#'   \item `residuals`
#'   \item `fitted.values`
#'   \item `sigma2`
#'   \item `se`
#'   \item `tvalue`
#'   \item `pvalue`
#'   \item `df`
#'   \item `formula`
#'   \item `X`
#'   \item `y`
#' }
#'
#' @examples
#' n <- 50
#' x <- rnorm(n)
#' y <- 1 + 4*x + rnorm(n)
#' dat <- data.frame(y, x)
#' fit <- my_lm_original(y ~ x, data = dat)
#' fit$coefficients
#'
#' @export
#' @importFrom stats model.frame model.matrix model.response pt
my_lm_original <- function(formula, data) {
  mf <- model.frame(formula, data)
  y <- model.response(mf)
  X <- model.matrix(formula, data)

  XtX <- t(X) %*% X
  XtX_inv <- solve(XtX)
  beta_hat <- XtX_inv %*% t(X) %*% y

  fitted <- X %*% beta_hat
  residuals <- y - fitted

  n <- nrow(X); p <- ncol(X)
  sigma2 <- as.numeric(t(residuals) %*% residuals / (n - p))


  se <- sqrt(diag(sigma2 * XtX_inv))

  tvalue <- beta_hat / se
  pvalue <- 2 * (1 - pt(abs(tvalue), df = n - p))

  result <- list(
    coefficients = beta_hat,
    residuals = residuals,
    fitted.values = fitted,
    sigma2 = sigma2,
    se = se,
    tvalue = tvalue,
    pvalue = pvalue,
    df = n - p,
    formula = formula,
    X = X,
    y = y
  )
  class(result) <- "my_lm"
  return(result)
}
