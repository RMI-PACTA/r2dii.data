delayedAssign(
  x = "green_or_brown",
  value = {
    on_r_cmd <- !identical(Sys.getenv("R_CMD"), "")
    if (!on_r_cmd) {
      warning(
        "The dataset `green_or_brown`is superseded as of r2dii.data 0.3.2.",
        "\nPlease use `increasing_or_decreasing` instead.",
        call. = FALSE
      )
    }
    r2dii.data:::legacy_green_or_brown
  }
)
