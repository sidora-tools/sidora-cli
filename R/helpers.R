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

