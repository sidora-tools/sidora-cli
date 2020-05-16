#' summarise_extract
#'
#' @param con test
#' @param entity_id test
#' @param cache_dir test
#'
#' @export
summarise_extract <- function(
  con = sidora.core::get_pandora_connection(), 
  entity_id = "FUT001.A01", 
  cache_dir = "/tmp/sidora.cli_table_cache"
) {
  
  # get data
  extracts <- sidora.core::get_df(con, tab = "TAB_Extract", cache_dir = cache_dir)
  # filter
  sel_basic <- extracts %>% dplyr::filter(.data[["Full_Extract_Id"]] == entity_id[1])
  
  
  if (nrow(sel_basic) > 0) {
    
    # get additional data and merge
    sel_merged <- sidora.core::join_pandora_tables(x = list(
      "TAB_Sample" = sidora.core::get_df(tab = "TAB_Sample", con = con, cache_dir = cache_dir) %>% 
        dplyr::filter(Id == sel_basic$Sample),
      "TAB_Extract" = sel_basic,
      "TAB_Library" = sidora.core::get_df(con, tab = "TAB_Library", cache_dir = cache_dir)
    ))
    
    
    # Title
    cat("---\n")
    cat(
      crayon::underline("Extract:") %+% " " %+% 
        crayon::blue(crayon::bold(
          sel_basic$Full_Extract_Id
        ))  %+% " " %+%
        crayon::red(
          "from sample", unique(sel_merged$Full_Sample_Id)
        ) %+% 
        "\n"
    )
    cat("---\n")
    
    # Extracts from this extract
    cat(
      crayon::underline("Libraries:") %+% " " %+% crayon::silver(paste0(
        sel_merged$Full_Library_Id, 
        collapse = ", "
      )) %+% 
        "\n"
    )
    
  } else {
    sidora.cli::fuzzy_search(entity_id[1], extracts$Full_Extract_Id)
  }
  
}