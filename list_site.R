sites <- sidora.core::get_df(con, tab = "TAB_Site", cache_dir = cache_dir)

selected <- sites %>%
  dplyr::filter(Site_Id %in% entity_id | Name %in% entity_id)

if (as_tsv) {
  selected %>% dplyr::select(Site_Id, Name, Country, Tags, Projects) %>% readr::format_tsv() %>% cat()
} else {
  selected %>% dplyr::select(Site_Id, Name, Country, Tags, Projects) %>% knitr::kable()
}
