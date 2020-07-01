#' view_module
#'
#'This module can be seen as a command-line replacement for the PANDORA web UI for viewing information about a single object.
#'
#' @param con test
#' @param entity_type test
#' @param entity_id test
#' @param cache_dir test
#'
#' @export
view_module <- function(con, entity_type, entity_id, cache_dir) {
  ## Get corresponding table from our 'clean' sidora.cliinput options
  tab_info <- sidora.cli::convert_option_to_pandora_table(entity_type)
  selected_table <- sidora.core::get_df(con, 
                                        tab = tab_info$pandora_table, 
                                        cache_dir = cache_dir)
  table_filtered <- selected_table %>% 
    dplyr::filter(eval(as.symbol(tab_info$id_column)) == entity_id, 
                  !eval(as.symbol(paste0(entity_type, ".Deleted"))))
  
  ## Check table isn't empty, and do fuzzy search if true
  if (nrow(table_filtered) == 0) {
    search_vec <- selected_table %>% dplyr::pull(eval(as.symbol(tab_info$id_column)))
    sidora.cli::fuzzy_search(entity_id, search_vec)
  } else {
    ## Find columns to get human-readable strings for get_name_from_id
    cols2update <- names(table_filtered[sidora.core::is_sidoracol_auxid(entity_type = entity_type, col_name = names(table_filtered))])
    ## Format for printing, not tidy output, so suppressed warnings from gather
    suppressWarnings(
      table_filtered %>%
        dplyr::select(-paste0(entity_type, ".Id"), 
                      -paste0(entity_type, ".Deleted"), 
                      -paste0(entity_type, ".Deleted_Date")) %>%
        dplyr::mutate(dplyr::across(all_of(cols2update), 
                                    ~sidora.core::get_name_from_id(con = con, 
                                                      query_tab = entity_type, 
                                                      query_col = dplyr::cur_column(), 
                                                      query_id = .x, 
                                                      cache_dir = cache_dir))) %>%
        dplyr::mutate(dplyr::across(dplyr::everything(), as.character)) %>%
        tidyr::gather("Field", "Value", 1:ncol(.)) %>% 
        dplyr::mutate(Field = gsub(paste0(entity_type, "\\."), "", .data$Field)) %>%
        knitr::kable() %>% 
        print()
    )

  }
  cat("\n")
}
