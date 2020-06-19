#' @rdname summarise
#' @export
summarise_individual <- function(
  con = sidora.core::get_pandora_connection(), 
  entity_id = "FUT001", 
  cache_dir = "/tmp/sidora.cli_table_cache"
) {
  
  # get data
  individuals <- sidora.core::get_df(con, tab = "TAB_Individual", cache_dir = cache_dir)
  # filter
  sel_basic <- individuals %>% dplyr::filter(.data[["individual.Full_Individual_Id"]] == entity_id[1])
  
  
  if (nrow(sel_basic) > 0) {
    
    # get additional data and merge
    sel_merged <- sidora.core::join_pandora_tables(x = list(
      "TAB_Site" = sidora.core::get_df(tab = "TAB_Site", con = con, cache_dir = cache_dir) %>% dplyr::filter(site.Id == sel_basic$individual.Site),
      "TAB_Individual" = sel_basic,
      "TAB_Sample" = sidora.core::get_df(tab = "TAB_Sample", con = con, cache_dir = cache_dir)
    ))
    
    
    # Title
    cat("---\n")
    cat(
      crayon::underline("Individual:") %+% " " %+% 
      crayon::yellow(crayon::bold(
        sel_basic$individual.Full_Individual_Id
      ))  %+% " " %+%
      crayon::green(
        "from site", unique(sel_merged$site.Name),
        "in", unique(sel_merged$site.Country)
      ) %+% 
      "\n"
    )
    cat("---\n")
    
    # Samples from this individual
    cat(
      crayon::underline("Samples:") %+% " " %+% crayon::red(paste0(
        sel_merged$sample.Full_Sample_Id, 
        collapse = ", "
      )) %+% 
        "\n"
    )
    
    # Dating
    if (!all(is.na(sel_merged$individual.C14_Calibrated_From))) {
      cat(
        crayon::underline("Dating (based only on C14 dates):") %+% " " %+% crayon::cyan(paste0(
          sel_basic$individual.C14_Calibrated_From, "-", sel_basic$individual.C14_Calibrated_To, " BC/AD",
          collapse = ", "
        )) %+% 
        "\n"
      )
    }
    
    # Map  
    if (!all(is.na(sel_merged$site.Longitude))) {
      sidora.cli::ascii_world_map(unique(sel_merged$site.Longitude), unique(sel_merged$site.Latitude))
    }

  } else {
    sidora.cli::fuzzy_search(entity_id[1], individuals$individual.Full_Individual_Id)
  }
  
}