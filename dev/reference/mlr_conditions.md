# Error Classes

Condition classes for mlr3.

## Usage

``` r
error_config(msg, ..., class = NULL, signal = TRUE)

error_input(msg, ..., class = NULL, signal = TRUE)

error_timeout(signal = TRUE)

error_mlr3(msg, ..., class = NULL, signal = TRUE)

warning_mlr3(msg, ..., class = NULL, signal = TRUE)

warning_config(msg, ..., class = NULL, signal = TRUE)

warning_input(msg, ..., class = NULL, signal = TRUE)

error_learner(msg, ..., class = NULL, signal = TRUE)

error_learner_train(msg, ..., class = NULL, signal = TRUE)

error_learner_predict(msg, ..., class = NULL, signal = TRUE)
```

## Arguments

- msg:

  (`character(1)`)  
  Error message.

- ...:

  (any)  
  Passed to [`sprintf()`](https://rdrr.io/r/base/sprintf.html).

- class:

  (`character`)  
  Additional class(es).

- signal:

  (`logical(1)`)  
  If `FALSE`, the condition object is returned instead of being
  signaled.

## Formatting

It is also possible to use formatting options as defined in
[`cli::cli_bullets`](https://cli.r-lib.org/reference/cli_bullets.html).

## Errors

- `error_mlr3()` for the base `Mlr3Error` class.

- `error_config()` for the `Mlr3ErrorConfig` class, which signals that a
  user has misconfigured something (e.g. invalid learner configuration).

- `error_input()` for the `Mlr3ErrorInput` class, which signals that an
  invalid input was provided.

- `error_timeout()` for the `Mlr3ErrorTimeout`, signalling a timeout
  (encapsulation).

- `error_learner()` for the `Mlr3ErrorLearner`, signalling a learner
  error.

- `error_learner_train()` for the `Mlr3ErrorLearner`, signalling a
  learner training error.

- `error_learner_predict()` for the `Mlr3ErrorLearner`, signalling a
  learner prediction error.

## Warnings

- `warning_mlr3()` for the base `Mlr3Warning` class.

- `warning_config()` for the `Mlr3WarningConfig` class, which signals
  that a user might have misconfigured something.

- `warning_input()` for the `Mlr3WarningInput` if an invalid input might
  have been provided.
