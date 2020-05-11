#' view_site
#'
#' @param con test
#' @param entity_id test
#' @param cache_dir test
#'
#' @export
view_site <- function(con, entity_id, cache_dir) {

  sites <- sidora.core::get_df(con, tab = "TAB_Site", cache_dir = cache_dir)
  
  selected <- sites %>% dplyr::filter(.data[["Site_Id"]] == entity_id[1] | .data[["Name"]] == entity_id[1])
  
  selected[c("Site_Id", "Name", "Country", "Tags", "Projects")] %>% knitr::kable() %>% print()
  
  if (nrow(selected) == 0) {
    sidora.cli::fuzzy_search(entity_id[1], c(sites$Site_Id, sites$Name))
  }

}
