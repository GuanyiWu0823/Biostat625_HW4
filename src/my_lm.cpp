#include <RcppArmadillo.h>


// [[Rcpp::depends(RcppArmadillo)]]

using namespace Rcpp;
using namespace arma;

// [[Rcpp::export]]
Rcpp::List fast_lm_cpp(const arma::mat& X, const arma::vec& y) {
  int n = X.n_rows;
  int p = X.n_cols;

  // X'X and X'y
  mat XtX = X.t() * X;
  vec Xty = X.t() * y;

  // beta = solve(X'X, X'y)
  vec beta = solve(XtX, Xty);

  // fitted and residuals
  vec fitted = X * beta;
  vec resid  = y - fitted;

  // sigma^2
  double sigma2 = dot(resid, resid) / (n - p);

  // standard error
  mat XtX_inv = inv_sympd(XtX);
  vec se = sqrt(sigma2 * XtX_inv.diag());

  return List::create(
    _["beta"]      = beta,
    _["fitted"]    = fitted,
    _["residuals"] = resid,
    _["sigma2"]    = sigma2,
    _["se"]        = se
  );
}
