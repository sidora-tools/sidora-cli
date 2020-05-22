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
  filter_entity_type = "sample",
  filter_string = "Protocol == 18",
  as_tsv = T,
  cache_dir = "/tmp/sidora.cli_table_cache"
) {

  # transform table names
  entity_type_table <- sidora.cli::convert_option_to_pandora_table(entity_type)$pandora_table
  filter_entity_type_table <- sidora.cli::convert_option_to_pandora_table(filter_entity_type)$pandora_table
  
  # get the relevant tables and the tables in between
  table_list <- sidora.core::get_df_list(
    # TODO: Function to fill the table sequence automatically
    c(entity_type_table, "TAB_Individual", filter_entity_type_table), 
    con = con, cache_dir = cache_dir
  )
  
  # apply filter operation on filter entity
  table_list[[filter_entity_type_table]] <- eval(parse(text = 
   "table_list[[filter_entity_type_table]] %>% dplyr::filter(" %+%
   filter_string %+%
   ")"
  ))
  
  # create big, merged table
  # TODO: Better way to filter to final result, maybe another join function that starts from the filter entity
  joined_table <- sidora.core::join_pandora_tables(table_list) 

  firstup <- function(x) {
    substr(x, 1, 1) <- toupper(substr(x, 1, 1))
    x
  }
  
  result_table <- joined_table %>%
    # filter merged table to only include values in filtered filter entity
    dplyr::filter(!is.na(!!rlang::sym(paste0(firstup(filter_entity_type), "_Id")))) %>%
    # reduce result variable selection to requested entity
    dplyr::select(colnames(table_list[[entity_type_table]]))
  
  print(result_table)
  
}
