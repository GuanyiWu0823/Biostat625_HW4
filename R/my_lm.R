#' Fit Linear Models (Rcpp-Accelerated)
#'
#' @description
#' `my_lm()` fits a linear regression model using ordinary least squares (OLS).
#' This version is accelerated using Rcpp for faster matrix operations.
#'
#' @usage
#' my_lm(formula, data)
#'
#' @param formula
#' an object of class `"formula"` specifying the model to be fitted.
#'
#' @param data
#' a `data.frame` containing the variables referenced in `formula`.
#'
#' @details
#' The function extracts the model matrix and response via `model.frame()`,
#' `model.matrix()`, and `model.response()`.
#' OLS coefficients are computed as:
#'
#' \deqn{\hat{\beta} = (X^T X)^{-1} X^T y}
#'
#' Standard errors, t-values, p-values, fitted values and residuals
#' are computed following standard OLS formulas.
#'
#' @return
#' An object of class `"my_lm"`, which is a list containing:
#'
#' \itemize{
#'   \item `coefficients` — estimated regression coefficients
#'   \item `residuals` — residuals: *y - fitted*
#'   \item `fitted.values` — fitted means
#'   \item `sigma2` — residual variance estimate
#'   \item `se` — standard errors of coefficients
#'   \item `tvalue` — t-statistics
#'   \item `pvalue` — two-sided p-values
#'   \item `df` — residual degrees of freedom
#'   \item `formula` — the original model formula
#'   \item `X` — model matrix
#'   \item `y` — response vector
#' }
#'
#' @examples
#' n <- 100
#' x1 <- rnorm(n)
#' x2 <- rnorm(n)
#' y <- 1 + 2*x1 - 3*x2 + rnorm(n)
#' dat <- data.frame(y, x1, x2)
#'
#' fit <- my_lm(y ~ x1 + x2, data = dat)
#' fit$coefficients
#'
#' @export
#' @importFrom stats model.frame model.matrix model.response pt
my_lm <- function(formula, data) {
  mf <- stats::model.frame(formula, data)
  y  <- stats::model.response(mf)
  X  <- stats::model.matrix(formula, data)


  res <- fast_lm_cpp(X, y)

  n <- nrow(X)
  p <- ncol(X)

  tvalue <- res$beta / res$se
  pvalue <- 2 * (1 - stats::pt(abs(tvalue), df = n - p))

  out <- list(
    coefficients = as.vector(res$beta),
    fitted.values = as.vector(res$fitted),
    residuals = as.vector(res$residuals),
    sigma2 = res$sigma2,
    se = as.vector(res$se),
    tvalue = as.vector(tvalue),
    pvalue = as.vector(pvalue),
    df = n - p,
    formula = formula,
    X = X,
    y = y
  )
  class(out) <- "my_lm"
  out
}
