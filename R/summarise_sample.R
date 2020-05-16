#' summarise_sample
#'
#' @param con test
#' @param entity_id test
#' @param cache_dir test
#'
#' @export
summarise_sample <- function(
  con = sidora.core::get_pandora_connection(), 
  entity_id = "FUT001.A", 
  cache_dir = "/tmp/sidora.cli_table_cache"
) {
  
  # get data
  samples <- sidora.core::get_df(con, tab = "TAB_Sample", cache_dir = cache_dir)
  # filter
  sel_basic <- samples %>% dplyr::filter(.data[["Full_Sample_Id"]] == entity_id[1])
  
  
  if (nrow(sel_basic) > 0) {
    
    # get additional data and merge
    sel_merged <- sidora.core::join_pandora_tables(x = list(
      "TAB_Individual" = sidora.core::get_df(tab = "TAB_Individual", con = con, cache_dir = cache_dir) %>% 
        dplyr::filter(Id == sel_basic$Individual),
      "TAB_Sample" = sel_basic,
      "TAB_Extract" = sidora.core::get_df(con, tab = "TAB_Extract", cache_dir = cache_dir)
    ))
    
    
    # Title
    cat("---\n")
    cat(
      crayon::underline("Sample:") %+% " " %+% 
        crayon::red(crayon::bold(
          sel_basic$Full_Sample_Id
        ))  %+% " " %+%
        crayon::yellow(
          "from individual", unique(sel_merged$Full_Individual_Id)
        ) %+% 
        "\n"
    )
    cat("---\n")
    
    # Extracts from this sample
    cat(
      crayon::underline("Extracts:") %+% " " %+% crayon::blue(paste0(
        sel_merged$Full_Extract_Id, 
        collapse = ", "
      )) %+% 
        "\n"
    )
    
  } else {
    sidora.cli::fuzzy_search(entity_id[1], samples$Full_Sample_Id)
  }
  
}