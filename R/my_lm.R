#' Fast linear model using RcppArmadillo
#'
#' A simplified version of lm() that uses RcppArmadillo for the core
#' linear algebra. Supports formulas of the form y ~ x1 + x2 + ...
#'
#' @param formula An object of class "formula"
#' @param data A data.frame containing the variables in the model
#'
#' @return An object of class "my_lm" similar to lm() output
#' @export
#' @importFrom stats model.frame model.matrix model.response pt
#' @examples
#' \dontrun{
#'   set.seed(1)
#'   x <- rnorm(100)
#'   y <- 1 + 2 * x + rnorm(100, sd = 0.5)
#'   df <- data.frame(x = x, y = y)
#'   fit <- my_lm(y ~ x, df)
#'   summary(fit)
#' }
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
