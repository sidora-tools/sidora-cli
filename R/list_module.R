#' list_module
#'
#' A module where, given a pandora entity type, a row-wise list of IDs will be printed for screen. Useful for fast look up of certain IDs.
#' 
#' @param con a pandora connection from sidora.core
#' @param entity_type a pandora table to the generate a list of IDs from. Options: site,
#' @param cache_dir location of your cache directory.
#' @examples 
#' list_module(con, "site", cache_dir)
#' @export

list_module <- function(con, entity_type, cache_dir) {
  
  tab_info <- sidora.cli::convert_option_to_pandora_table(entity_type)

  if (entity_type %in% sidora.core::pandora_tables_restricted) {
    
    table <- sidora.core::access_restricted_table(con, entity_id = tab_info)
    
  } else {
    table <- sidora.core::get_df(con, 
                                 tab = tab_info$pandora_table, 
                                 cache_dir = cache_dir)
  }

  
  ## Use cat() to ensure pretty printing in terminal
  table %>% 
    dplyr::select(tab_info$id_col) %>% 
    dplyr::pull(tab_info$id_col) %>% 
    cat(sep = "\n")
  
}
