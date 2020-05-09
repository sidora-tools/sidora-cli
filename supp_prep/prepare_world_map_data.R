hu <- rnaturalearthdata::countries110 %>% sf::st_as_sf()

pu <- fasterize::fasterize(hu, raster::raster(xmn = -180, xmx = 180, ymn = -90, ymx = 90, nrow = 20, ncol = 80)) 

schu <- t(raster::as.matrix(pu))

raster::xyFromCell(pu, cell = which(!is.na(schu))) %>% 
  tibble::as_tibble() -> gnu

plot_width <- 80
x_breaks <- tibble::tibble(
  x_plot_pos = 1:plot_width
) %>%
  dplyr::mutate(
    x_coord_start = -180 + 360/plot_width * (x_plot_pos - 1),
    x_coord_stop = -180 + 360/plot_width * x_plot_pos
  )

plot_height <- 20
y_breaks <- tibble::tibble(
  y_plot_pos = 1:plot_height
) %>%
  dplyr::mutate(
    y_coord_start = -90 + 180/plot_height * (y_plot_pos - 1),
    y_coord_stop = -90 + 180/plot_height * y_plot_pos
  )

ju <- gnu %>%
  dplyr::mutate(
    x = as.integer(cut(x, breaks = c(x_breaks$x_coord_start[1], x_breaks$x_coord_stop), labels = 1:plot_width)),
    y = as.integer(cut(y, breaks =  c(y_breaks$y_coord_start[1], y_breaks$y_coord_stop), labels = 1:plot_height)),
    land = 1
  )

gu <- expand.grid(
  x = 1:plot_width,
  y = 1:plot_height
) %>% 
  dplyr::left_join(
    ju, by = c("x", "y")
  ) %>%
  dplyr::mutate(
    z = land
  )

for (ro in seq(20, 1, -1)) {
  for (co in 1:80) {
    cur <- gu$z[gu$x == co & gu$y == ro]
    if (is.na(cur)) {
      cat(" ")
    } else if (cur == 1) {
      cat(".")
    } else if (cur == 2) {
      cat("X")
    }
  }
  cat("\n")
}



