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

# "sugar" flags
p <- argparser::add_argument(
  p, "--projects", help = "return list of projects",
  flag = T
)
p <- argparser::add_argument(
  p, "--tags", help = "return list of tags",
  flag = T
)

# "how" flags
p <- argparser::add_argument(
  p, "--summary", short = "-v", 
  help = "return information on an individual object", 
  flag = T
)
p <- argparser::add_argument(
  p, "--list", short = "-l", 
  help = "return a list with information for multiple objects", 
  flag = T
)

# "what" flags and arguments
p <- argparser::add_argument(
  p, "--project", help = "selected projects",
  nargs = Inf
)
p <- argparser::add_argument(
  p, "--tag", help = "selected tags",
  nargs = Inf
)
p <- argparser::add_argument(
  p, "--site", help = "selected sites",
  nargs = Inf
)
p <- argparser::add_argument(
  p, "--individual", help = "selected individuals",
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
projects <- argv$projects
tags <- argv$tags

flag_summary <- argv$summary
flag_list <- argv$list

project <- argv$project
tag <- argv$tag
site <- argv$site
individual <- argv$individual

cred_file <- argv$credentials
cache_dir <- argv$cache_dir

# check that only one is selected among the exclusive arguments
# if (flag_summary & flag_list | !flag_summary & !flag_list) {
#   stop("Select either --list or --summary")
# }

#### connect to PANDORA ####

con <- sidora.core::get_pandora_connection()

#### call modules ####

if (projects) {
  "Not implemented"
} else if (tags) {
  "Not implemented"
} else if (flag_summary) {
  if (!is.na(project)) {
    "Not implemented"
  } else if (!is.na(tag)) {
    "Not implemented"
  } else if (!is.na(site)) {
    source("site.R", local = T, print.eval = T)
  } else if (!is.na(individual)) {
    "Not implemented"
  }
} else if (flag_list) {
  if (!is.na(project)) {
    source("progress_table.R", local = T, print.eval = T)
  } else if (!is.na(tag)) {
    "Not implemented"
  } else if (!is.na(site)) {
    source("site.R", local = T, print.eval = T)
  } else if (!is.na(individual)) {
    "Not implemented"
  } else if (projects) {
    "Not implemented"
  } else if (tags) {
    "Not implemented"
  }
}
