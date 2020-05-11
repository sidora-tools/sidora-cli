#' quick_install
#'
#' @param path test
#'
#' @export
quick_install <- function(path = "~")  {
  
  path_to_script <- system.file("sidora.R", package = "sidora.cli")
  
  file.copy(
    from = path_to_script,
    to = file.path(path, "sidora.R"),
    overwrite = T
  )
  
}
