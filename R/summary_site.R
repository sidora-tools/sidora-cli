#' summary_site
#'
#' @param con test
#' @param entity_id test
#' @param cache_dir test
#'
#' @export
summary_site <- function(con, entity_id, cache_dir) {

  sites <- sidora.core::get_df(con, tab = "TAB_Site", cache_dir = cache_dir)
  
  selected <- sites %>%
    dplyr::filter(Site_Id == entity_id[1] | Name == entity_id[1])
  
  selected %>% dplyr::select(Site_Id, Name, Country, Tags, Projects) %>% knitr::kable() %>% print()
  
  if (nrow(selected) > 0) {
    sidora.cli::ascii_world_map(selected$Longitude, selected$Latitude)
  }
  
  if (nrow(selected) == 0) {
    sidora.cli::fuzzy_search(entity_id[1], c(sites$Site_Id, sites$Name))
  }
  
}