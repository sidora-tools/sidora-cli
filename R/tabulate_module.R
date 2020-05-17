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

  entity_type_table <- sidora.cli::convert_option_to_pandora_table(entity_type)$pandora_table
  filter_entity_type_table <- sidora.cli::convert_option_to_pandora_table(filter_entity_type)$pandora_table
  
  # TODO: Function to fill the table sequence
  table_list <- sidora.core::get_df_list(
    c(entity_type_table, "TAB_Individual", filter_entity_type_table), 
    con = con, cache_dir = cache_dir
  )
  
  table_list[[filter_entity_type_table]] <- eval(parse(text = 
   "table_list[[filter_entity_type_table]] %>% dplyr::filter(" %+%
   filter_string %+%
   ")"
  ))

  joined_table <- sidora.core::join_pandora_tables(table_list) 

  # TODO: Better way to filter to final result, maybe another join function
  firstup <- function(x) {
    substr(x, 1, 1) <- toupper(substr(x, 1, 1))
    x
  }
  
  result_table <- joined_table %>%
    dplyr::filter(!is.na(!!rlang::sym(paste0(firstup(filter_entity_type), "_Id"))))
  
  print(result_table)
  
}
