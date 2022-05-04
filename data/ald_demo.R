delayedAssign("ald_demo", {
  on_r_cmd <- !identical(Sys.getenv("R_CMD"), "")
  if (!on_r_cmd) {
    warning(
      "The dataset `ald_demo`is superseded as of r2dii.data 0.3.0 (expected July 2022).",
      "\nPlease use `abcd_demo` instead.",
      "\nRead this blog post to learn more:",
      "\nhttps://2degreesinvesting.github.io/posts/2022-03-02-ald-becomes-abcd/",
      call. = FALSE
    )
  }
  r2dii.data::abcd_demo
})
