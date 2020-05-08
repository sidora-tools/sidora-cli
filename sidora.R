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

# how-flags
p <- argparser::add_argument(
  p, "--view", short = "-v", 
  help = "return information on an individual object", 
  flag = T
)
p <- argparser::add_argument(
  p, "--list", short = "-l", 
  help = "return a list with information for multiple objects", 
  flag = T
)

# what-arguments
p <- argparser::add_argument(
  p, "--projects", help = "selected projects",
  nargs = Inf
)
p <- argparser::add_argument(
  p, "--tags", help = "selected tags",
  nargs = Inf
)
p <- argparser::add_argument(
  p, "--sites", help = "selected tags",
  nargs = Inf
)
p <- argparser::add_argument(
  p, "--individuals", help = "selected tags",
  nargs = Inf
)

# technical arguments
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

# parse the command line arguments
argv <- argparser::parse_args(p)

# write cli args to individual variables
flag_view <- argv$view
flag_list <- argv$list

projects <- argv$projects
tags <- argv$tags
sites <- argv$sites
individuals <- argv$individuals

cred_file <- argv$credentials
cache_dir <- argv$cache_dir

# check that only one is selected among the exclusive arguments
if (flag_view & flag_list | !flag_view & !flag_list) {
  stop("Select either --list or --view")
}

#### connect to PANDORA ####

con <- sidora.core::get_pandora_connection()

#### call modules ####

paste(length(projects))

if (flag_view) {
  if (!is.na(projects)) {
    "Not implemented"
  } else if (!is.na(tags)) {
    "Not implemented"
  } else if (!is.na(sites)) {
    source("sites.R", local = T, print.eval = T)
  } else if (!is.na(individuals)) {
    "Not implemented"
  }
} else if (flag_list) {
  if (!is.na(projects)) {
    source("progress_table.R", local = T, print.eval = T)
  } else if (!is.na(tags)) {
    "Not implemented"
  } else if (!is.na(sites)) {
    source("sites.R", local = T, print.eval = T)
  } else if (!is.na(individuals)) {
    "Not implemented"
  }
}
