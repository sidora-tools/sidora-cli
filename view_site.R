sites <- sidora.core::get_df(con, tab = "TAB_Site", cache_dir = cache_dir)

selected <- sites %>% 
  dplyr::filter(Site_Id %in% entity_id[1] | Name %in% entity_id[1])

selected %>% dplyr::select(Site_Id, Name, Country, Tags, Projects) %>% knitr::kable()

if (nrow(selected) == 0) {
  fuzzy_search(entity_id[1], c(sites$Site_Id, sites$Name))
}
