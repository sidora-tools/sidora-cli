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

  selected_table <- sidora.core::get_df(
    tab = sidora.core::entity_type_to_table_name(entity_type),
    con = con, 
    cache_dir = cache_dir
  ) 
  
  filtered_table <- selected_table %>% dplyr::filter(
    !!dplyr::sym(sidora.core::namecol_for_entity_type(entity_type)) == entity_id
  )

  ## Check table is empty, and do fuzzy search if true
  if (nrow(filtered_table) == 0) {
    search_vec <- selected_table[[sidora.core::namecol_for_entity_type(entity_type)]]
    sidora.cli::fuzzy_search(entity_id, search_vec)
  } else {
    ## Find columns to get human-readable strings for get_name_from_id
    cols2update <- names(
      filtered_table[, sidora.core::sidora_col_name_has_aux(sidora_col_name = names(filtered_table))]
    )
    
    ## Format for printing, not tidy output, so suppressed warnings from gather
    suppressWarnings(
      filtered_table %>%
        dplyr::select(
          -paste0(entity_type, ".Id"), 
          -paste0(entity_type, ".Deleted"), 
          -paste0(entity_type, ".Deleted_Date")
        ) %>%
        dplyr::mutate(dplyr::across(
          tidyselect::all_of(cols2update),
          ~sidora.core::namecol_value_from_id(
            sidora_col_name = dplyr::cur_column(),
            query_id = .x,
            con = con,
            cache_dir = cache_dir
          )
        )) %>%
        tidyr::gather("Field", "Value", 1:ncol(.)) %>% 
        dplyr::mutate(Field = gsub(paste0(entity_type, "\\."), "", .data$Field)) %>%
        knitr::kable() %>% 
        print()
    )

  }
  cat("\n")
}
