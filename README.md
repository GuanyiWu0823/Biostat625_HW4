# Biostat625HW4
<!-- badges: start -->
  [![R-CMD-check](https://github.com/GuanyiWu0823/Biostat625_HW4/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/GuanyiWu0823/Biostat625_HW4/actions/workflows/R-CMD-check.yaml)
  <!-- badges: end -->
This R package was developed as part of Biostat 625 coursework. It implements custom statistical modeling functions, acceleration via Rcpp, unit testing, vignettes, and complete package documentation.

---

## Overview

`Biostat625HW4` contains implementations of:

- A custom linear regression function with Rcpp (`my_lm`)
- A custom summary function (`my_summary`)
- A baseline version of linear regression (`my_lm_original`)
- A C++-accelerated matrix computation (`my_lm.cpp`)
- Built-in examples, roxygen2 documentation, and unit tests

This package demonstrates a full R package workflow:

- Package structure (R/, man/, src/, tests/, vignettes/)
- Rcpp integration  
- Unit testing with **testthat**
- Vignettes using R Markdown
- GitHub version control
- DESCRIPTION + NAMESPACE auto-generation  

---

## Installation

Install the package from GitHub using **devtools**:

```r
# install.packages("devtools")
devtools::install_github("GuanyiWu0823/Biostat625_HW4", build_vignettes = TRUE)
```
## Usage

Below are examples demonstrating how to use the main functions in **Biostat625HW4**.

---

###  Linear Regression

```r
library(Biostat625HW4)

# Simulated data
set.seed(1)
n <- 100
x1 <- rnorm(n)
x2 <- rnorm(n)
y <- 1 + 2 * x1 - 3 * x2 + rnorm(n, sd = 0.5)

dat <- data.frame(y = y, x1 = x1, x2 = x2)


# Fit model using custom R implementation
fit <- my_lm(y ~ x1 + x2, data = dat)
fit
```

###  Model Summary

```r
my_summary(fit)
```

