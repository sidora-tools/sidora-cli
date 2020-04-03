sites <- sidora.core::get_df(con, tab = "TAB_Site", cache_dir = cache_dir)

sites_filtered <- sites %>%
  sidora.core::filter_pr_tag("Projects", projects) %>%
  sidora.core::filter_pr_tag("Tags", tags)

print(tibble::as_tibble(
  sites_filtered %>% dplyr::select(Site_Id, Name, Country, Tags, Projects)
))

if (nrow(sites_filtered) > 0) {
  txtplot::txtplot(
    x = sites_filtered$Longitude, y = sites_filtered$Latitude, 
    pch = "+", width = 80, height = 20, 
    ylim = c(-95, 95),
    xlab = "Longitude", ylab = "Latitude", 
  )
}
