#' Summary Method for my_lm Objects
#'
#' @description
#' `my_summary()` produces a summary of a fitted linear model object
#' created by `my_lm()` or `my_lm_original()`.
#'
#' @usage
#' my_summary(object)
#'
#' @param object
#' an object of class `"my_lm"` produced by `my_lm()` or `my_lm_original()`.
#' @details
#' The function prints:
#'
#' \itemize{
#'   \item model call
#'   \item coefficient table (Estimate, Std.Error, t-value, p-value)
#'   \item residual standard error
#' }
#'
#' @return
#' Invisibly returns the input `"my_lm"` object after printing its summary.
#'
#' @examples
#' n <- 100
#' x <- rnorm(n)
#' y <- 3 + 2*x + rnorm(n)
#' dat <- data.frame(y, x)
#' fit <- my_lm(y ~ x, data = dat)
#'
#' my_summary(fit)
#'
#' @export
my_summary <- function(object) {
  cat("Call:\n")
  print(object$formula)

  cat("\nCoefficients:\n")
  coef_table <- cbind(
    Estimate  = object$coefficients,
    Std.Error = object$se,
    t.value   = object$tvalue,
    p.value   = object$pvalue
  )
  print(coef_table)

  cat(
    "\nResidual standard error:",
    sqrt(object$sigma2),
    "on",
    object$df,
    "degrees of freedom\n"
  )

  invisible(list(
    coefficients = object$coefficients,
    stderr       = object$se,
    t_values     = object$tvalue,
    p_values     = object$pvalue,
    sigma        = sqrt(object$sigma2),
    df           = object$df
  ))
}
