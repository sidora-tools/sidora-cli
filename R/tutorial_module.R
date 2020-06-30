#' tutorial_module
#'
#' This module guides you through a series of example applications
#' 
#' @param con test
#' @param cache_dir test
#'
#' @export
tutorial_module <- function(con, cache_dir) {
  
  cat("Welcome to the wonderful world of sidora, the shiny command line interface to Pandora.\n")
  cat("\n")
  schtop()
  cat("You can open the sidora manual to learn everything about the different modules sidora provides with:\n")
  cat(crayon::bold("$ sidora -h.\n"))
  cat("\n")
  schtop()
  cat("The [examples] module: A quick reminder about the most important functions\n")
  cat(crayon::bold("$ sidora examples\n"))
  cat("\n")
  schtop()
  sidora.cli::examples_module(quit_after = FALSE)
  cat("\n")
  cat("The [glance] module: Which columns does a certain pandora table have?\n")
  cat(crayon::bold("$ sidora glance -t site\n"))
  cat("\n")
  schtop()
  sidora.cli::glance_module(entity_type = "site", con = con, cache_dir) 
  cat("\n")
  
  quit(save = "no")
  
}

schtop <- function() {
  cat(crayon::silver("[Enter] to continue or [q] + [Enter] to quit "))
  user_input <- scan("stdin", character(), nlines = 1, quiet = TRUE)
  if (length(user_input) != 0 && user_input == "q") { quit(save = "no") }
}