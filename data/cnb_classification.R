delayedAssign("cnb_classification", {
  on_r_cmd <- !identical(Sys.getenv("R_CMD"), "")
  if (!on_r_cmd) {
    warning(
      "The dataset `cnb_classification` will be superseded as of r2dii.data 0.5.0 (expected March 2024).",
      "\nPlease see `sector_classifications` for available datasets",
      call. = FALSE
    )
  }
  r2dii.data:::cnb_classification_
})
