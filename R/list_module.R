#' list_module
#'
#' A module where, given a pandora entity type, a row-wise list of IDs will be printed for screen. Useful for fast look up of certain IDs.
#' 
#' @param con a pandora connection from sidora.core
#' @param entity_type a pandora table to the generate a list of IDs from. Options: site,
#' @param cache_dir location of your cache directory.
#' 
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

  selected_table <- sidora.core::get_df(con, 
                                        tab = sidora.core::entity2table(entity_type), 
                                        cache_dir = cache_dir)

  selected_table[[sidora.core::get_namecol_from_entity(entity_type)]] %>% 
    cat(sep = "\n")
  
}
