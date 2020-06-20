#' check_input_module
#'
#' @param x test
#'
#' @export
check_input_module <- function(x) {
  modules <- c("view", "summarise", "list", "tabulate", "glance", "help")
  if (!(x %in% modules)) {
    stop(
      "The first argument names the module you want to use and must be one of: ", 
      paste(modules, collapse = ", "), 
      ". See the help module or the more comprehensive -h for more information."
    )
  }
}

