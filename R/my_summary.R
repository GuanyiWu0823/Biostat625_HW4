#' Summary method for my_lm objects
#'
#' @param object An object of class "my_lm"
#' @param ... Not used
#'
#' @return Invisibly returns a list with coefficient table, etc.
#' @export
my_summary <- function(object, ...) {
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
