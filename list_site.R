sites <- sidora.core::get_df(con, tab = "TAB_Site", cache_dir = cache_dir)

selected <- sites %>%
  dplyr::filter(Site_Id %in% entity_id | Name %in% entity_id)

print(tibble::as_tibble(
  selected %>% dplyr::select(Site_Id, Name, Country, Tags, Projects)
))
