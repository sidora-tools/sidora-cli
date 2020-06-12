#' fuzzy_search
#'
#' fuzzy text search for entities to provide alternative suggestions
#'
#' @param pattern test
#' @param search_vector test
#'
#' @export
fuzzy_search <- function(pattern, search_vector) {
  cat("There is no entity with that entity_id. Did you mean one of the following entities?\n- ")
  cat(agrep(pattern, search_vector, value = T)[1:5], sep = "\n- ")
}

#' ascii_world_map
#'
#' plot world map on the console
#'
#' @param lon test
#' @param lat test
#'
#' @export
ascii_world_map <- function(lon = c(), lat = c()) {
  
  if (length(lon) == 0 | length(lat) == 0) {
    
    plot_grid <- sidora.cli::world_map_data$plot_grid %>%
      dplyr::mutate(
        position = FALSE
      )
    
  } else {
  
    points_of_interest_cells_plot <- tibble::tibble(
        x = as.integer(cut(
          lon, breaks = c(
            sidora.cli::world_map_data$x_breaks$x_coord_start[1], 
            sidora.cli::world_map_data$x_breaks$x_coord_stop
          ), 
          labels = 1:sidora.cli::world_map_data$plot_width
        )),
        y = as.integer(cut(
          lat, breaks = c(
            sidora.cli::world_map_data$y_breaks$y_coord_start[1],
            sidora.cli::world_map_data$y_breaks$y_coord_stop
          ), 
          labels = 1:sidora.cli::world_map_data$plot_height
        )),
        position = TRUE
      ) %>%
      dplyr::group_by(.data[["x"]], .data[["y"]]) %>%
      dplyr::summarise(
        number_of_samples = sum(.data[["position"]]),
        position = any(.data[["position"]])
      ) %>%
      dplyr::ungroup()
    
    # compiling plot grid
    plot_grid <- sidora.cli::world_map_data$plot_grid %>%
      dplyr::left_join(
        points_of_interest_cells_plot, by = c("x", "y")
      ) %>%
      dplyr::mutate(
        number_of_samples = tidyr::replace_na(.data[["number_of_samples"]], FALSE),
        position = tidyr::replace_na(.data[["position"]], FALSE)
      )
  
  }
  
  # ascii plot
  cat("\u2554")
  cat(rep("\u2550", sidora.cli::world_map_data$plot_width + 2), sep = "")
  cat("\u2557")
  cat("\n")
  for (ro in seq(sidora.cli::world_map_data$plot_height, 1, -1)) {
    cat("\u2551 ")
    row_number_of_samples <- 0
    for (co in 1:sidora.cli::world_map_data$plot_width) {
      cur <- plot_grid[plot_grid$x == co & plot_grid$y == ro,]
      if (!cur$land & !cur$position) {
        cat(" ")
      } else if (cur$land & !cur$position) {
        cat("\u2591")
      } else if (cur$position) {
        cat("\u25CF")
        row_number_of_samples <- row_number_of_samples + cur$number_of_samples
      }
    }
    cat(" \u2551")
    if (row_number_of_samples > 0) {
      cat(" \u25C0", row_number_of_samples)
    }
    cat("\n")
  }
  cat("\u255A")
  cat(rep("\u2550", sidora.cli::world_map_data$plot_width + 2), sep = "")
  cat("\u255D")
  cat("\n")
  
}

#' convert_option_to_pandora_table
#'
#' Given a command line `-t` options, retrieve the corresponding PANDORA table name and (full) ID column
#'
#' @param entity_type a valid entity type (e.g. site, sample, individual etc.)
#'
#' @export

convert_option_to_pandora_table <- function(entity_type = NA) {
  
  if (is.na(entity_type))
    stop("[sidora.cli] error: no entity type supplied.")
  
  entity_map <- c(
    site = "TAB_Site",
    individual = "TAB_Individual",
    sample = "TAB_Sample",
    extract = "TAB_Extract",
    library = "TAB_Library",
    capture = "TAB_Capture",
    sequencing = "TAB_Sequencing",
    raw_data = "TAB_Raw_Data",
    sequencer = "TAB_Sequencing_Sequencer",
    tag = "TAB_Tag",
    project = "TAB_Project"
  )
  
  id_col_map <- c(
    TAB_Site = "site.Full_Site_Id",
    TAB_Individual = "individual.Full_Individual_Id",
    TAB_Sample = "sample.Full_Sample_Id",
    TAB_Extract = "extract.Full_Extract_Id",
    TAB_Library = "library.Full_Library_Id",
    TAB_Capture  = "capture.Full_Capture_Id",
    TAB_Sequencing = "sequencing.Full_Sequencing_Id",
    TAB_Raw_Data = "raw_data.Full_Raw_Data_Id",
    TAB_Sequencing_Sequencer = "sequencer.Name",
    TAB_Tag = "tag.Name",
    TAB_Project = "project.Name"
  )
  
  if (!entity_type %in% names(entity_map))
    stop(
      cat("[sidora.cli] error: your supplied table is not recognised. Options:", 
          paste(names(entity_map), collapse = ", "),
          "",
          sep = "\n")
    )
  
  selected_entity = entity_map[entity_type]
  selected_col = id_col_map[selected_entity] %>% as.character()
  
  result <- list(pandora_table = selected_entity, id_column = selected_col)
  
  return(result)
  
}


