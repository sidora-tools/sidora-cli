sites <- sidora.core::get_df(con, tab = "TAB_Site", cache_dir = cache_dir)

selected <- sites %>%
  dplyr::filter(Site_Id == entity_id[1] | Name == entity_id[1])

selected %>% dplyr::select(Site_Id, Name, Country, Tags, Projects) %>% knitr::kable()

if (nrow(selected) > 0) {
  txtplot::txtplot(
    x = selected$Longitude, y = selected$Latitude, 
    pch = "+", width = 80, height = 20, 
    ylim = c(-95, 95),
    xlab = "Longitude", ylab = "Latitude", 
  )
}
