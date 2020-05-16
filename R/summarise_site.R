#' summarise_site
#'
#' @param con test
#' @param entity_id test
#' @param cache_dir test
#'
#' @rdname summarise
#' @export
summarise_site <- function(
  con = sidora.core::get_pandora_connection(), 
  entity_id = "Futuna", 
  cache_dir = "/tmp/sidora.cli_table_cache"
) {

  # get data
  sites <- sidora.core::get_df(tab = "TAB_Site", con = con, cache_dir = cache_dir)
  # filter
  sel_basic <- sites %>% dplyr::filter(.data[["Site_Id"]] == entity_id[1] | .data[["Name"]] == entity_id[1])

  
  if (nrow(sel_basic) > 0) {
    
    # get additional data and merge
    sel_merged <- sidora.core::join_pandora_tables(x = list(
      "TAB_Site" = sel_basic, 
      "TAB_Individual" = sidora.core::get_df(tab = "TAB_Individual", con = con, cache_dir = cache_dir)
    ))

    # Site name
    cat("---\n")
    cat(
      crayon::underline("Site:") %+% " " %+% 
      crayon::green(
        crayon::bold(sel_basic$Name), 
        paste0("(", sel_basic$Site_Id ,")"),
        "in", sel_basic$Country
      ) %+% 
      "\n"
    )
    cat("---\n")
    
    # Individuals from this site
    cat(
      crayon::underline("Individuals:") %+% " " %+% crayon::yellow(paste0(
        sel_merged$Full_Individual_Id, 
        collapse = ", "
      )) %+% 
      "\n"
    )
    
    # Dating
    if (!all(is.na(sel_merged$C14_Calibrated_From))) {
      starts <- sel_merged$C14_Calibrated_From %>% na.omit() %>% as.vector()
      stops <- sel_merged$C14_Calibrated_To %>% na.omit() %>% as.vector()
      touched_millenia <- c(starts, stops) %>% `/`(., 1000) %>% floor() %>% table() %>% 
        tibble::as_tibble() %>%
        `colnames<-`(c("mill", "n")) %>%
        dplyr::mutate(
          n_prop = paste0(round(n/sum(n) * 100, 0), "%"),
          mill_text = dplyr::case_when(
            mill < 0 ~ paste(-as.numeric(mill), "mill. BC"),
            mill >= 0 ~ paste(as.numeric(mill) + 1, "mill. AD")
          )
        )
      
      cat(
        crayon::underline("Dating (based only on C14 dates):") %+% " " %+% crayon::cyan(paste0(
          crayon::bold(touched_millenia$mill_text), 
          paste0(" (", touched_millenia$n_prop, ")"),
          collapse = ", "
        )) %+% 
          "\n"
      )
    }
    
    # Map  
    if (!all(is.na(sel_basic$Longitude))) {
      sidora.cli::ascii_world_map(sel_basic$Longitude, sel_basic$Latitude)
    }
      
  } else {
    sidora.cli::fuzzy_search(entity_id[1], c(sites$Site_Id, sites$Name))
  }
  
}