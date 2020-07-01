#' glance_module
#'
#' This module gives you an overview about the variables (columns) in a Pandora table.
#'
#' @param con test
#' @param entity_type test
#' @param cache_dir test
#'
#' @export
glance_module <- function(
  con = sidora.core::get_pandora_connection(), 
  entity_type,
  cache_dir = "~/.sidora"
) {
  
  # get relevant table
  sidora.core::get_df(
    sidora.core::entity_type_to_table_name(entity_type),
    con = con, cache_dir = cache_dir
  ) %>%
    # count number of "empty" columns per row
    dplyr::mutate(
      number_of_na = rowSums(is.na(.) | . == "")
    ) %>%
    # arrange by that count
    dplyr::arrange(.data[["number_of_na"]]) %>%
    dplyr::select(-.data[["number_of_na"]]) %>%
    # only keep rows with no/low number of missing values
    magrittr::extract(1:3, ) %>%
    # transpose table and transform to two column table
    t() %>%
    magrittr::set_colnames(c("V1", "V2", "V3")) %>%
    tibble::as_tibble(rownames = "Field") %>%
    tidyr::unite("Examples", tidyselect::starts_with("V"), sep = "; ") %>%
    dplyr::mutate(
      # remove weird linebreaks
      Examples = gsub("\n", "/", .data[["Examples"]]),
      # cut string length
      Examples = ifelse(nchar(Examples) > 43, paste0(strtrim(Examples, 40), '...'), Examples)
    ) %>%
    knitr::kable(col.names = c("Fields", "3 example values"))
  
  
}