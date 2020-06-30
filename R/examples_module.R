#' examples_module
#'
#' This module gives you a quick overview of the sidora.cli interface 
#'
#' @export
examples_module <- function() {
  
  cat("╔═════════════════════════════════════════════════════╗\n")
  cat("║ sidora -h | examples | tutorial                     ║\n") 
  cat("╠═════════════════════════════════════════════════════╣\n")
  cat("║ sidora view      -t site       ║ -i FUT             ║\n") 
  cat("║        summarise    individual ║    FUT001          ║\n") 
  cat("║        list         sample     ║    FUT001.A        ║\n") 
  cat("║        tabulate     extract    ║    FUT001.A01      ║\n") 
  cat("║        glance       library    ║    FUT001.A0101    ║\n") 
  cat("║        ...          ...        ║    FUT,CMC,...     ║\n")         
  cat("║                                ║    ...             ║\n")          
  cat("╠════════════════════════════════╩════════════════════╣\n")
  cat("║ -f site -s \"site.Latitude > 46\"                     ║\n")
  cat("║ -f sample -s \"grepl(\'Deep_Evolution\', sample.Tags)\" ║\n")
  cat("╠═════════════════════════════════════════════════════╣\n")
  cat("║ --as_tsv                                            ║\n")  
  cat("║ --credentials                                       ║\n")  
  cat("║ --cache_dir --empty_cache                           ║\n")  
  cat("╚═════════════════════════════════════════════════════╝\n")
  cat("see .sidora.R -h for a more comprehensive manual\n")
  cat(".sidora.R glance is useful to quickly see the columns in a table\n")
  quit(save = "no")
  
}