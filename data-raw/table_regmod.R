table_regmod=dplyr::bind_rows(
  tibble::tibble(
    name="m_surf_bv",
    label="surface drainée"),
  tibble::tibble(
    name="m_surf_eau",
    label="surface du chenal en eau"),
  tibble::tibble(
    name="m_lrgm_ba",
    label="largeur moyenne de la bande active"),
  tibble::tibble(
    name="m_surf_ba",
    label="surface de la bande active"),
  tibble::tibble(
    name="m_surf_bf",
    label="surface de la bande fluviale")
)
# "m_dist_axe", "longueur du tronçon",
# "m_dist_dir","longueur directe entre les deux extrémités du tronçon",
# "m_surf_eau","surface du chenal en eau"
# "m_eiqba", "écart interquartile de la largeur de la bande active adimensionnelle",
# "m_d_source","distance à la source",
# "m_pente", "pente en ppm",
# "m_strahler","ordre de Strahler",
# "Types","styles fluviaux"

usethis::use_data(table_regmod, overwrite=TRUE)