plot_width <- 120
plot_height <- 30

points_of_interest <- tibble::tibble(
  x = c(9, 30, -70),
  y = c(45, 45, -50)
)

world_map_raster <- raster::rasterize(
  rnaturalearthdata::countries110, 
  raster::raster(xmn = -180, xmx = 180, ymn = -90, ymx = 90, nrow = plot_height, ncol = plot_width)
)

world_map_matrix <- t(raster::as.matrix(world_map_raster))

landmass_cells <- raster::xyFromCell(
  world_map_raster, 
  cell = which(!is.na(world_map_matrix))
) %>% 
  tibble::as_tibble()

x_breaks <- tibble::tibble(
  x_plot_pos = 1:plot_width
) %>%
  dplyr::mutate(
    x_coord_start = -180 + 360/plot_width * (x_plot_pos - 1),
    x_coord_stop = -180 + 360/plot_width * x_plot_pos
  )

y_breaks <- tibble::tibble(
  y_plot_pos = 1:plot_height
) %>%
  dplyr::mutate(
    y_coord_start = -90 + 180/plot_height * (y_plot_pos - 1),
    y_coord_stop = -90 + 180/plot_height * y_plot_pos
  )

landmass_cells_plot <- landmass_cells %>%
  dplyr::mutate(
    x = as.integer(cut(x, breaks = c(x_breaks$x_coord_start[1], x_breaks$x_coord_stop), labels = 1:plot_width)),
    y = as.integer(cut(y, breaks =  c(y_breaks$y_coord_start[1], y_breaks$y_coord_stop), labels = 1:plot_height)),
    land = TRUE
  )

points_of_interest_cells_plot <- points_of_interest %>%
  dplyr::mutate(
    x = as.integer(cut(x, breaks = c(x_breaks$x_coord_start[1], x_breaks$x_coord_stop), labels = 1:plot_width)),
    y = as.integer(cut(y, breaks =  c(y_breaks$y_coord_start[1], y_breaks$y_coord_stop), labels = 1:plot_height)),
    position = TRUE
  )

plot_grid <- expand.grid(
  x = 1:plot_width,
  y = 1:plot_height
) %>% 
  dplyr::left_join(
    landmass_cells_plot, by = c("x", "y")
  ) %>%
  dplyr::left_join(
    points_of_interest_cells_plot, by = c("x", "y")
  ) %>%
  dplyr::mutate(
    land =  tidyr::replace_na(land, FALSE),
    position =  tidyr::replace_na(position, FALSE)
  )

for (ro in seq(plot_height, 1, -1)) {
  for (co in 1:plot_width) {
    cur <- plot_grid[plot_grid$x == co & plot_grid$y == ro,]
    if (!cur$land) {
      cat(" ")
    } else if (cur$land & !cur$position) {
      cat(".")
    } else if (cur$position) {
      cat("X")
    }
  }
  cat("\n")
}



