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
  
  cat("You can open the manual to learn everything about the different sidora.cli modules\n")
  cat(crayon::bold("$ sidora -h.\n"))
  cat("\n")
  schtop()
  
  cat("The", crayon::yellow("[examples]"), "module quickly reminds you of the most important features\n")
  cat(crayon::bold("$ sidora examples\n"))
  cat("\n")
  schtop()
  sidora.cli::examples_module(quit_after = FALSE)
  cat("\n")
  
  cat("I often ask myself which columns a certain pandora table has? The", crayon::yellow("[glance]"), "module answers that\n")
  cat(crayon::bold("$ sidora glance -t site\n"))
  cat("\n")
  schtop()
  sidora.cli::glance_module(entity_type = "site", con = con, cache_dir = cache_dir) 
  cat("\n")
  
  cat("The", crayon::yellow("[view]"), "module now shows you one particular entity\n")
  cat(crayon::bold("$ sidora view -t site -i VOI\n"))
  cat("\n")
  schtop()
  sidora.cli::view_module(entity_type = "site", entity_id = "VOI", con = con, cache_dir = cache_dir) 
  cat("\n")
  
  cat("You can call the (experimental)", crayon::yellow("[summarise]"), "module to do the same, but in a slightly more fancy way\n")
  cat(crayon::bold("$ sidora summarise -t site -i FUT\n"))
  cat("\n")
  schtop()
  sidora.cli::summarise_site(entity_id = "FUT", con = con, cache_dir = cache_dir) 
  cat("\n")
  
  cat("The", crayon::yellow("[tabulate]"), "module now adds the important ability to show a table with multiple entities\n")
  cat(crayon::bold("$ sidora tabulate -t site -i FUT,CMC,VOI\n"))
  cat("\n")
  schtop()
  sidora.cli::tabulate_module(entity_type = "site", entity_id = c("FUT", "CMC", "VOI"), con = con, cache_dir = cache_dir) 
  cat("\n")
  
  cat("It also has a tsv output option for easy command line processing\n")
  cat(crayon::bold("$ sidora tabulate -t site -i FUT,CMC,VOI --as_tsv\n"))
  cat("\n")
  schtop()
  sidora.cli::tabulate_module(entity_type = "site", entity_id = c("FUT", "CMC", "VOI"), as_tsv = T, con = con, cache_dir = cache_dir) 
  cat("\n")
  
  cat(crayon::yellow("[tabulate]"), "can also be used to query meaningful subsets of Pandora tables. You do this by selecting a filter table with -f and defining a filter string with -s. The latter is \"injected\" R code. In this example we get every site north of the Polar circle\n")
  cat(crayon::bold("$ sidora tabulate -t site -f site -s \"site.Latitude > 66.56\"\n"))
  cat("\n")
  schtop()
  sidora.cli::tabulate_module(entity_type = "site", filter_entity_type = "site", filter_string = "site.Latitude > 66.56", con = con, cache_dir = cache_dir) 
  cat("\n")
  
  cat("More complex queries across two tables are possible as well. For example: All samples north of the Polar circle and in Russia\n")
  cat(crayon::bold("$ sidora tabulate -t sample -f site -s \"site.Latitude > 66.56 & grepl('Russia', site.Country)\"\n"))
  cat("\n")
  schtop()
  sidora.cli::tabulate_module(entity_type = "sample", filter_entity_type = "site", filter_string = "site.Latitude > 66.56 & grepl('Russia', site.Country)", con = con, cache_dir = cache_dir) 
  cat("\n")
  
  quit(save = "no")
  
}

schtop <- function() {
  cat(crayon::silver("[Enter] to continue or [q] + [Enter] to quit "))
  user_input <- scan("stdin", character(), nlines = 1, quiet = TRUE)
  if (length(user_input) != 0 && user_input == "q") { quit(save = "no") }
}