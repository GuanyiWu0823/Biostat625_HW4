
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Biostat625HW4

<!-- badges: start -->

[![R-CMD-check](https://github.com/GuanyiWu0823/Biostat625_HW4/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/GuanyiWu0823/Biostat625_HW4/actions/workflows/R-CMD-check.yaml)
[![codecov](https://codecov.io/gh/GuanyiWu0823/Biostat625_HW4/branch/main/graph/badge.svg)](https://codecov.io/gh/GuanyiWu0823/Biostat625_HW4)
<!-- badges: end --> This R package was developed as part of Biostat 625
coursework. It implements custom statistical modeling functions,
acceleration via Rcpp, unit testing, vignettes, and complete package
documentation.

------------------------------------------------------------------------

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

------------------------------------------------------------------------

## Installation

Install the package from GitHub using **devtools**:

``` r
# install.packages("devtools")
devtools::install_github("GuanyiWu0823/Biostat625_HW4", build_vignettes = TRUE)
```

## Usage

Below are examples demonstrating how to use the main functions in
**Biostat625HW4**.

------------------------------------------------------------------------

### Linear Regression

``` r
library(Biostat625HW4)

# Simulated data
set.seed(1)
n <- 10
x1 <- rnorm(n)
x2 <- rnorm(n)
y <- 1 + 2 * x1 - 3 * x2 + rnorm(n, sd = 0.5)

dat <- data.frame(y = y, x1 = x1, x2 = x2)


# Fit model using custom R implementation
fit <- my_lm(y ~ x1 + x2, data = dat)
fit
```

    ## $coefficients
    ## [1]  0.9358931  1.6516789 -2.8259183
    ## 
    ## $fitted.values
    ##  [1] -4.3709776  0.1375477  1.3112781  9.8293456 -1.6988288 -0.2922785
    ##  [7]  1.7867217 -0.5118357 -0.4338051 -1.2468271
    ## 
    ## $residuals
    ##  [1]  0.04221511  0.45127738 -0.08153107  0.01063983  0.29296448 -0.24192179
    ##  [7]  0.15880947 -0.57839973 -0.11737083  0.06331715
    ## 
    ## $sigma2
    ## [1] 0.1048714
    ## 
    ## $se
    ## [1] 0.1096127 0.1492860 0.1089564
    ## 
    ## $tvalue
    ## [1]   8.538184  11.063858 -25.936220
    ## 
    ## $pvalue
    ## [1] 6.000946e-05 1.094585e-05 3.239214e-08
    ## 
    ## $df
    ## [1] 7
    ## 
    ## $formula
    ## y ~ x1 + x2
    ## 
    ## $X
    ##    (Intercept)         x1          x2
    ## 1            1 -0.6264538  1.51178117
    ## 2            1  0.1836433  0.38984324
    ## 3            1 -0.8356286 -0.62124058
    ## 4            1  1.5952808 -2.21469989
    ## 5            1  0.3295078  1.12493092
    ## 6            1 -0.8204684 -0.04493361
    ## 7            1  0.4874291 -0.01619026
    ## 8            1  0.7383247  0.94383621
    ## 9            1  0.5757814  0.82122120
    ## 10           1 -0.3053884  0.59390132
    ## attr(,"assign")
    ## [1] 0 1 2
    ## 
    ## $y
    ##          1          2          3          4          5          6          7 
    ## -4.3287624  0.5888251  1.2297470  9.8399854 -1.4058643 -0.5342003  1.9455311 
    ##          8          9         10 
    ## -1.0902354 -0.5511759 -1.1835100 
    ## 
    ## attr(,"class")
    ## [1] "my_lm"

### Model Summary

``` r
my_summary(fit)
```

    ## Call:
    ## y ~ x1 + x2
    ## 
    ## Coefficients:
    ##        Estimate Std.Error    t.value      p.value
    ## [1,]  0.9358931 0.1096127   8.538184 6.000946e-05
    ## [2,]  1.6516789 0.1492860  11.063858 1.094585e-05
    ## [3,] -2.8259183 0.1089564 -25.936220 3.239214e-08
    ## 
    ## Residual standard error: 0.3238386 on 7 degrees of freedom
