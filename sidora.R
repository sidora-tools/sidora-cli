#!/usr/bin/env Rscript

#### install necessary R packages if not available yet ####

necessary_packages <- c("magrittr", "argparser", "devtools", "sidora.core", "tibble", "txtplot", "dplyr")
missing_packages <- necessary_packages[!(necessary_packages %in% rownames(installed.packages()))]

if (length(missing_packages) > 0) {
  cat("There are R packages missing (", paste(missing_packages, collapse = ", "), "). Do you want to install them? [y/n]: ") 
  user_input_install <- readLines(con = "stdin", 1)
  if (tolower(user_input_install) == "y") {
    install.packages(missing_packages[missing_packages != "sidora.core"])
    if(!require("sidora.core")) { devtools::install_github("sidora-tools/sidora.core") }
  }
}

library(magrittr)

#### command line input parsing ####

# create cli arg parser
p <- argparser::arg_parser(
  name = "sidora.cli", 
  description = "MPI-SHH Pandora DB command line interface",
  hide.opts = T
)

# add command line arguments
p <- argparser::add_argument(
  p, "--module", short = "-m", 
  help = "sidora.cli module", 
  type = "character"
)
p <- argparser::add_argument(
  p, "--credentials", short = "-c", 
  help = "path to the credentials file", 
  type = "character", default = ".credentials"
)
p <- argparser::add_argument(
  p, "--cache_dir", short = "-d", 
  help = "path to table cache directory", 
  type = "character", default = "/tmp/sidora.cli_table_cache"
)
p <- argparser::add_argument(
  p, "--projects", help = "selected projects",
  nargs = Inf
)
p <- argparser::add_argument(
  p, "--tags", help = "selected tags",
  nargs = Inf
)

# parse the command line arguments
argv <- argparser::parse_args(p)

# write cli args to individual variablels
module <-argv$module
cred_file <- argv$credentials
cache_dir <- argv$cache_dir
projects <- argv$projects
tags <- argv$tags

# check if module is selected
if (!(module %in% c("progress_table", "sites"))) {
  stop("Unknown module or no module selected (-m)")
}

#### connect to PANDORA ####

con <- sidora.core::get_pandora_connection()

#### call modules ####

if (module == "progress_table") {
  source("progress_table.R", local = T, print.eval = T)
} else if (module == "sites") {
  source("sites.R", local = T, print.eval = T)
}
