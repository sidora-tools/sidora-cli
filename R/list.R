#' list
#'
#' A module where, given a pandora entity type, a row-wise list of IDs will be printed for screen. Useful for fast look up of certain IDs.
#' 
#' @param con a pandora connection from sidora.core
#' @param entity_type a pandora table to the generate a list of IDs from. Options: site,
#' @param cache_dir location of your cache directory.
#' @examples 
#' list(con, "site", cache_dir)


list <- function(con, entity_type, cache_dir) {
  
  entity_map <- c(
    site = "TAB_Site",
    individual = "TAB_Individual",
    sample = "TAB_Sample",
    extract = "TAB_Extract",
    library = "TAB_Library",
    capture = "TAB_Capture",
    sequencing = "TAB_Sequencing",
    raw_data = "TAB_Raw_Data",
    sequencer = "TAB_Sequencer",
    tag = "TAB_Tag",
    project = "TAB_Project"
  )
  
  id_col_map <- c(
   TAB_Site = "Full_Site_Id",
   TAB_Individual = "Full_Individual_Id",
   TAB_Sample = "Full_Sample_Id",
   TAB_Extract = "Full_Extract_Id",
   TAB_Library = "Full_Library_Id",
   TAB_Capture  = "Full_Capture_Id",
   TAB_Sequencing = "Full_Sequencing_Id",
   TAB_Raw_Data = "Full_Raw_Data_Id",
   TAB_Sequencer = "Name",
   TAB_Tag = "Name",
  TAB_Project = "Name"
  )

  if (!entity_type %in% names(entity_map))
    stop(
      cat("[sidora.cli] error: your supplied table is not recognised. Options:", 
      paste(names(entity_map), collapse = ", "),
      sep = "\n")
  )

  selected_entity = entity_map[entity_type]
  selected_col = id_col_map[selected_entity] %>% as.character()
  
  table <- sidora.core::get_df(con, 
                               tab = selected_entity, 
                               cache_dir = cache_dir)
  
  ## Use cat() to ensure pretty printing in terminal
  table %>% 
    dplyr::select(selected_col) %>% 
    dplyr::pull(id_col_map[selected_entity]) %>% 
    cat(sep = "\n")
  
}
