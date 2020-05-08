sites <- sidora.core::get_df(con, tab = "TAB_Site", cache_dir = cache_dir)

selected_site <- sites %>%
  dplyr::filter(Site_Id == entity_id | Name == entity_id)

print(tibble::as_tibble(
  selected_site %>% dplyr::select(Site_Id, Name, Country, Tags, Projects)
))

if (nrow(selected_site) > 0) {
  txtplot::txtplot(
    x = selected_site$Longitude, y = selected_site$Latitude, 
    pch = "+", width = 80, height = 20, 
    ylim = c(-95, 95),
    xlab = "Longitude", ylab = "Latitude", 
  )
}
