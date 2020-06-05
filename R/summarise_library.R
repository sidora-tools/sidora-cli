#' @rdname summarise
#' @export
summarise_library <- function(
  con = sidora.core::get_pandora_connection(), 
  entity_id = "FUT001.A0101", 
  cache_dir = "/tmp/sidora.cli_table_cache"
) {
  
  # get data
  libraries <- sidora.core::get_df(con, tab = "TAB_Library", cache_dir = cache_dir)
  # filter
  sel_basic <- libraries %>% dplyr::filter(.data[["library.Full_Library_Id"]] == entity_id[1])
  
  
  if (nrow(sel_basic) > 0) {
    
    # get additional data and merge
    sel_merged <- sidora.core::join_pandora_tables(x = list(
      "TAB_Extract" = sidora.core::get_df(tab = "TAB_Extract", con = con, cache_dir = cache_dir) %>% 
        dplyr::filter(extract.Id == sel_basic$library.Extract),
      "TAB_Library" = sel_basic,
      "TAB_Capture" = sidora.core::get_df(con, tab = "TAB_Capture", cache_dir = cache_dir),
      "TAB_Sequencing" = sidora.core::get_df(con, tab = "TAB_Sequencing", cache_dir = cache_dir)
    ))
    
    
    # Title
    cat("---\n")
    cat(
      crayon::underline("Library:") %+% " " %+% 
        crayon::silver(crayon::bold(
          sel_basic$library.Full_Library_Id
        ))  %+% " " %+%
        crayon::blue(
          "from extract", unique(sel_merged$extract.Full_Extract_Id)
        ) %+% 
        "\n"
    )
    cat("---\n")
    
    # Captures and sequencing runs from this library
    cat(
      crayon::underline("Sequencing runs (SG -> no capture):") %+% " " %+% paste0(
        crayon::bgGreen(sel_merged$sequencing.Full_Sequencing_Id),
        collapse = ", "
      ) %+% 
        "\n"
    )
    
  } else {
    sidora.cli::fuzzy_search(entity_id[1], libraries$library.Full_Library_Id)
  }
  
}