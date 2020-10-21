table_profiles=dplyr::bind_rows(
  tibble::tibble(
      type="Profil en long (m)",
      filename="LONG_PROFILE",
      xname="measure",
      yname="zmin"),
  tibble::tibble(
      type= "Largeur du corridor fluvial (m)",
      filename= "FLUVIAL_CORRIDOR_WIDTH",
      xname="measure",
      yname="fcw1"),
  tibble::tibble(
      type="Occupation du sol",
      filename="LANDCOVER_WIDTH_CONT_BDT",
      xname="measure",
      yname="lcw"
  )
 #"REFAXIS_TALWEG_PROFILE","measure","z",
 #"REFAXIS_VALLEY_PROFILE","measure","z"
 #"LANDCOVER_SWATH_PROFILES_CONT_BDT","ak","i"
 #"LANDCOVER_SWATH_PROFILES_TOTAL_BDT","ak","i"
)
usethis::use_data(table_profiles, overwrite=T)