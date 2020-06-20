#' glance_module
#'
#' This module gives you you an overview about the variables (columns) in a Pandora table.
#'
#' @param con test
#' @param entity_type test
#' @param cache_dir test
#'
#' @export
glance_module <- function(
  con = sidora.core::get_pandora_connection(), 
  entity_type,
  cache_dir = "/tmp/sidora.cli_table_cache"
) {
  
  entity_type_table <- sidora.core::entity2table(entity_type)
  
  result_table <- sidora.core::get_df(
    entity_type_table,
    con = con, cache_dir = cache_dir
  )
  
  for (i in 1:ncol(result_table)) {
    
    cat(crayon::bold(colnames(result_table)[i]), ": ", sep = "")
    first_three_values <- result_table[1:3,] %>% dplyr::pull(i)
    cat(first_three_values, sep = ", ")
    cat(", ...\n")
    
  }
  
}