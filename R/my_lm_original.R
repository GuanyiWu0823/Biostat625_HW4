#' A pure R implementation without Rcpp
#' @param formula An object of class "formula"
#' @param data A data.frame containing the variables in the model
#' @return An object of class "my_lm" similar to lm() output
#' @importFrom stats model.frame model.matrix model.response pt
#' @export
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
