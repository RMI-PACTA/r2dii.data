delayedAssign("ald_demo", {
  on_r_cmd <- !identical(Sys.getenv("R_CMD"), "")
  if (!on_r_cmd) {
    warning(
      "`ald_demo` was superseded in r2dii.data 0.3.0. ",
      "Please use `abcd_demo` instead.",
      call. = FALSE
    )
  }

  abcd_demo
})
