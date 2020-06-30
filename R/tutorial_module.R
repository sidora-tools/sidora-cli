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
  
  cat("The", crayon::yellow("[examples]"), "module: A quick reminder about the most important functions\n")
  cat(crayon::bold("$ sidora examples\n"))
  cat("\n")
  schtop()
  sidora.cli::examples_module(quit_after = FALSE)
  cat("\n")
  
  cat("The", crayon::yellow("[glance]"), "module: Which columns does a certain pandora table have?\n")
  cat(crayon::bold("$ sidora glance -t site\n"))
  cat("\n")
  schtop()
  sidora.cli::glance_module(entity_type = "site", con = con, cache_dir = cache_dir) 
  cat("\n")
  
  cat("The", crayon::yellow("[view]"), "module: Show one particular entity\n")
  cat(crayon::bold("$ sidora view -t site -i FUT\n"))
  cat("\n")
  schtop()
  sidora.cli::view_module(entity_type = "site", entity_id = "FUT", con = con, cache_dir = cache_dir) 
  cat("\n")
  
  cat("The", crayon::yellow("[summarise]"), "module: Show one particular entity, but with some context\n")
  cat(crayon::bold("$ sidora summarise -t site -i FUT\n"))
  cat("\n")
  schtop()
  sidora.cli::summarise_site(entity_id = "FUT", con = con, cache_dir = cache_dir) 
  cat("\n")
  
  cat("The", crayon::yellow("[tabulate]"), "module: Show a table with multiple entities\n")
  cat(crayon::bold("$ sidora tabulate -t site -i FUT,CMC,FUP\n"))
  cat("\n")
  schtop()
  sidora.cli::tabulate_module(entity_type = "site", entity_id = c("FUT", "CMC", "FUP"), con = con, cache_dir = cache_dir) 
  cat("\n")
  
  cat("The", crayon::yellow("[tabulate]"), "module has tsv outout for easy command line processing\n")
  cat(crayon::bold("$ sidora tabulate -t site -i FUT,CMC,FUP --as_tsv\n"))
  cat("\n")
  schtop()
  sidora.cli::tabulate_module(entity_type = "site", entity_id = c("FUT", "CMC", "FUP"), as_tsv = T, con = con, cache_dir = cache_dir) 
  cat("\n")
  
  quit(save = "no")
  
}

schtop <- function() {
  cat(crayon::silver("[Enter] to continue or [q] + [Enter] to quit "))
  user_input <- scan("stdin", character(), nlines = 1, quiet = TRUE)
  if (length(user_input) != 0 && user_input == "q") { quit(save = "no") }
}