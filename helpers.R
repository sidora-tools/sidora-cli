# fuzzy text search for entities to provide alternative suggestions
fuzzy_search <- function(pattern, search_vector) {
  cat("There is no entity with that entity_id. Did you mean one of the following entities?\n- ")
  cat(agrep(pattern, search_vector, value = T)[1:5], sep = "\n- ")
}

# plot world map on the console
ascii_world_map <- function(lon, lat) {
  
  points_of_interest_cells_plot <- tibble::tibble(
      x = as.integer(cut(lon, breaks = c(x_breaks$x_coord_start[1], x_breaks$x_coord_stop), labels = 1:plot_width)),
      y = as.integer(cut(lat, breaks =  c(y_breaks$y_coord_start[1], y_breaks$y_coord_stop), labels = 1:plot_height)),
      position = TRUE
    )
  
  # compiling plot grid
  plot_grid <- plot_grid %>%
    dplyr::left_join(
      points_of_interest_cells_plot, by = c("x", "y")
    ) %>%
    dplyr::mutate(
      position =  tidyr::replace_na(position, FALSE)
    )
  
  # ascii plot
  for (ro in seq(plot_height, 1, -1)) {
    for (co in 1:plot_width) {
      cur <- plot_grid[plot_grid$x == co & plot_grid$y == ro,]
      if (!cur$land & !cur$position) {
        cat(" ")
      } else if (cur$land & !cur$position) {
        cat(".")
      } else if (cur$position) {
        cat("X")
      }
    }
    cat("\n")
  }
  
}
