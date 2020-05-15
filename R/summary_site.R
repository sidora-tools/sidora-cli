#' summary_site
#'
#' @param con test
#' @param entity_id test
#' @param cache_dir test
#'
#' @export
summary_site <- function(con, entity_id, cache_dir) {

  # get data
  sites <- sidora.core::get_df(con, tab = "TAB_Site", cache_dir = cache_dir)
  individuals <- sidora.core::get_df(con, tab = "TAB_Individual", cache_dir = cache_dir)
  
  # filter and merge
  sel_basic <- sites %>% dplyr::filter(.data[["Site_Id"]] == entity_id[1] | .data[["Name"]] == entity_id[1])
  sel_individuals <- dplyr::left_join(
    sel_basic %>% dplyr::rename("Site" = "Id"), 
    individuals,
    by = "Site",
    suffix = c(".Site", ".Individual")
  )
  
  if (nrow(sel_basic) > 0) {
    
    # Site name
    cat(
      crayon::bold("Site: ") %+% 
      crayon::green(sel_basic$Name, paste0("(", sel_basic$Site_Id ,")")) %+% 
      "\n"
    )
    cat("---\n")
    
    # Individuals from this site
    cat(
      crayon::underline("Individuals:") %+% " " %+% paste0(
        sel_individuals$Full_Individual_Id, 
        collapse = ", "
      ) %+% 
      "\n"
    )
      
    sidora.cli::ascii_world_map(sel_basic$Longitude, sel_basic$Latitude)
    
  } else {
    sidora.cli::fuzzy_search(entity_id[1], c(sites$Site_Id, sites$Name))
  }
  
}