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
  entity_type,
  entity_id = c(),
  filter_entity_type = NA,
  filter_string = NA,
  as_tsv = T,
  as_id_list = F, # list module argument
  cache_dir = "/tmp/sidora.cli_table_cache"
) {

  entity_type_table <- sidora.core::entity2table(entity_type)
  
  if ( !is.na(entity_id[1]) && !is.na(filter_entity_type)) {
  
    stop("[sidora.cli error] Use either entity_id selection or filter. Not both.")
    
  } else if ( is.na(entity_id[1]) && is.na(filter_entity_type)) {
    # no filter/selection: returns the requested table
    
    result_table <- sidora.core::get_df(
      entity_type_table,
      con = con, cache_dir = cache_dir
    )
    
  } else if ( !is.na(entity_id[1]) ) {
    # selection: returns the selected entities from the requested table

    result_table <- sidora.core::get_df(
      entity_type_table,
      con = con, cache_dir = cache_dir
    ) %>%
      dplyr::filter(
        !!rlang::sym(sidora.core::get_namecol_from_entity(entity_type)) %in% entity_id
      )
    
  } else if ( !is.na(filter_entity_type) && !is.na(filter_string) ) {
    # filter: applies filter operation on filter table and returns requested table
    
    filter_entity_type_table <- sidora.core::entity2table(filter_entity_type)
    
    # get the relevant tables and the tables in between
    table_list <- sidora.core::get_df_list(
      sidora.core::make_complete_table_list(c(entity_type_table, filter_entity_type_table)),
      con = con, cache_dir = cache_dir
    )
    
    # apply filter operation on filter entity
    table_list[[filter_entity_type_table]] <- eval(parse(text = c(
     "table_list[[filter_entity_type_table]] %>% dplyr::filter(",
     filter_string,
     ")"
    )))
    
    # create big, merged table
    # TODO: (optional) Better way to filter to final result, maybe another join function that starts from the filter entity
    joined_table <- sidora.core::join_pandora_tables(table_list) 
  
    result_table <- joined_table %>%
      # filter merged table to only include values in filtered filter entity
      dplyr::filter(!is.na(!!rlang::sym( sidora.core::get_namecol_from_entity(filter_entity_type) ))) %>%
      # reduce result variable selection to requested entity_type
      dplyr::select(colnames(table_list[[entity_type_table]]))
  
  }
  
  if (as_tsv) {
    result_table %>% readr::format_tsv() %>% cat()
  } else if (as_id_list) {
    result_table %>% dplyr::pull(sidora.core::get_namecol_from_entity(entity_type)) %>% cat(sep = "\n")
  } else {
    result_table %>% print()
  }
  
}
