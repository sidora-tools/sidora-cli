#' list_site
#'
#' @param con test
#' @param entity_id test
#' @param as_tsv test
#' @param cache_dir test
#'
#' @export
list_site <- function(con, entity_id, as_tsv, cache_dir) {

  sites <- sidora.core::get_df(con, tab = "TAB_Site", cache_dir = cache_dir)
  
  selected <- sites %>% dplyr::filter(.data[["Site_Id"]] %in% entity_id | .data[["Name"]] %in% entity_id)
  
  if (as_tsv) {
    selected[c("Site_Id", "Name", "Country", "Tags", "Projects")] %>% readr::format_tsv() %>% cat()
  } else {
    selected[c("Site_Id", "Name", "Country", "Tags", "Projects")] %>% knitr::kable() %>% print()
  }
  
  if (nrow(selected) == 0) {
    sidora.cli::fuzzy_search(entity_id[1], c(sites$Site_Id, sites$Name))
  }

}
