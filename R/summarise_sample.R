#' @rdname summarise
#' @export
summarise_sample <- function(
  con = sidora.core::get_pandora_connection(), 
  entity_id = "FUT001.A", 
  cache_dir = "~/.sidora"
) {
  
  # get data
  samples <- sidora.core::get_df(con, tab = "TAB_Sample", cache_dir = cache_dir)
  # filter
  sel_basic <- samples %>% dplyr::filter(.data[["sample.Full_Sample_Id"]] == entity_id[1])
  
  
  if (nrow(sel_basic) > 0) {
    
    # get additional data and merge
    sel_merged <- sidora.core::join_pandora_tables(x = list(
      "TAB_Individual" = sidora.core::get_df(tab = "TAB_Individual", con = con, cache_dir = cache_dir) %>% 
        dplyr::filter(.data[["individual.Id"]] == sel_basic$sample.Individual),
      "TAB_Sample" = sel_basic,
      "TAB_Extract" = sidora.core::get_df(con, tab = "TAB_Extract", cache_dir = cache_dir)
    ))
    
    
    # Title
    cat("---\n")
    cat(
      crayon::underline("Sample:") %+% " " %+% 
        crayon::red(crayon::bold(
          sel_basic$sample.Full_Sample_Id
        ))  %+% " " %+%
        crayon::yellow(
          "from individual", unique(sel_merged$individual.Full_Individual_Id)
        ) %+% 
        "\n"
    )
    cat("---\n")
    
    # Extracts from this sample
    cat(
      crayon::underline("Extracts:") %+% " " %+% crayon::blue(paste0(
        sel_merged$extract.Full_Extract_Id, 
        collapse = ", "
      )) %+% 
        "\n"
    )
    
  } else {
    sidora.cli::fuzzy_search(entity_id[1], samples$sample.Full_Sample_Id)
  }
  
}