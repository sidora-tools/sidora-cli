#' summarise_individual
#'
#' @param con test
#' @param entity_id test
#' @param cache_dir test
#'
#' @export
summarise_individual <- function(con, entity_id, cache_dir) {
  
  # get data
  individuals <- sidora.core::get_df(con, tab = "TAB_Individual", cache_dir = cache_dir)
  # filter
  sel_basic <- individuals %>% dplyr::filter(.data[["Full_Individual_Id"]] == entity_id[1])
  
  
  if (nrow(sel_basic) > 0) {
    
    # get additional data and merge
    sites <- sidora.core::get_df(con, tab = "TAB_Site", cache_dir = cache_dir)
    samples <- sidora.core::get_df(con, tab = "TAB_Sample", cache_dir = cache_dir)
    sel_merged <- dplyr::left_join(
      sel_basic %>% dplyr::rename("Individual" = "Id"), 
      sites %>% dplyr::rename("Site" = "Id"),
      by = "Site",
      suffix = c(".Individual", ".Site")
    ) %>%
      dplyr::left_join(
        samples %>% dplyr::rename("Sample" = "Id"),
        by = "Individual",
        suffix = c(".Individual", ".Sample")
      )
    
    # Title
    cat("---\n")
    cat(
      crayon::underline("Individual:") %+% " " %+% 
      crayon::yellow(crayon::bold(
        sel_basic$Full_Individual_Id
      ))  %+% " " %+%
      crayon::green(
        "from site", unique(sel_merged$Name),
        "in", unique(sel_merged$Country)
      ) %+% 
      "\n"
    )
    cat("---\n")
    
    # Samples from this individual
    cat(
      crayon::underline("Samples:") %+% " " %+% crayon::red(paste0(
        sel_merged$Full_Sample_Id, 
        collapse = ", "
      )) %+% 
        "\n"
    )
    
    # Dating
    if (!all(is.na(sel_merged$C14_Calibrated_From))) {
      cat(
        crayon::underline("Dating (based only on C14 dates):") %+% " " %+% crayon::cyan(paste0(
          sel_basic$C14_Calibrated_From, "-", sel_basic$C14_Calibrated_To, " BC/AD",
          collapse = ", "
        )) %+% 
        "\n"
      )
    }
    
    # Map  
    if (!all(is.na(sel_merged$Longitude))) {
      sidora.cli::ascii_world_map(unique(sel_merged$Longitude), unique(sel_merged$Latitude))
    }

  } else {
    sidora.cli::fuzzy_search(entity_id[1], individuals$Full_Individual_Id)
  }
  
}