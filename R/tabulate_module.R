#' tabulate_module
#'
#' @param con test
#' @param entity_type test
#' @param filter_string test
#' @param as_tsv test
#' @param cache_dir test
#'
#' @export
tabulate_module <- function(
  con = sidora.core::get_pandora_connection(), 
  entity_type = "site", 
  filter_string = "Latitude > 50",
  as_tsv = T,
  cache_dir = "/tmp/sidora.cli_table_cache"
) {

  sites <- sidora.core::get_df(con, tab = "TAB_Site", cache_dir = cache_dir)
  
  print(filter_string)
  
  hu <- eval(parse(text = 
    "sites %>% dplyr::filter(" %+%
    filter_string %+%
    ")"
  ))
  
  print(hu)
  
}
