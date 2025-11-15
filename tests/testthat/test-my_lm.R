test_that("my_lm matches lm coefficients", {
  set.seed(123)
  n <- 100
  x1 <- rnorm(n)
  x2 <- rnorm(n)
  y <- 1 + 2 * x1 - 3 * x2 + rnorm(n, sd = 0.3)
  dat <- data.frame(y = y, x1 = x1, x2 = x2)

  fit_lm <- lm(y ~ x1 + x2, data = dat)
  fit_my <- my_lm(y ~ x1 + x2, data = dat)

  expect_equal(
    unname(coef(fit_lm)),
    unname(fit_my$coefficients),
    tolerance = 1e-6
  )
})

test_that("my_summary returns correct list structure", {
  set.seed(123)
  n <- 50
  x1 <- rnorm(n)
  y <- 3 + 1.5 * x1 + rnorm(n)
  dat <- data.frame(y = y, x1 = x1)

  fit <- my_lm(y ~ x1, data = dat)
  summ <- my_summary(fit)

  expect_true(is.list(summ))
  expect_true("coefficients" %in% names(summ))
  expect_true("stderr" %in% names(summ))
  expect_true("t_values" %in% names(summ))
  expect_true("p_values" %in% names(summ))
})

test_that("my_lm_original matches lm coefficients", {
  set.seed(123)
  n <- 100
  x1 <- rnorm(n)
  x2 <- rnorm(n)
  y <- 1 + 2 * x1 - 3 * x2 + rnorm(n, sd = 0.3)
  dat <- data.frame(y = y, x1 = x1, x2 = x2)

  fit_lm <- lm(y ~ x1 + x2, data = dat)
  fit_my_original <- my_lm_original(y ~ x1 + x2, data = dat)

  expect_equal(
    unname(coef(fit_lm)),
    unname(fit_my_original$coefficients),
    tolerance = 1e-6
  )
})
