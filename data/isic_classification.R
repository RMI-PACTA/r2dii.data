delayedAssign("isic_classification", {
  on_r_cmd <- !identical(Sys.getenv("R_CMD"), "")
  if (!on_r_cmd) {
    warning(
      "The dataset `isic_classification` will be superseded as of r2dii.data 0.5.0 (expected Q2 2024).",
      "\nPlease see `sector_classifications` for available datasets",
      call. = FALSE
    )
  }
  r2dii.data:::isic_classification_
})
