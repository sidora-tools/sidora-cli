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
  description = "MPI-SHH Pandora DB command line interface test",
  hide.opts = T
)

# general interface
p <- argparser::add_argument(
  p, "module",
  help = "One of: summary, list, view, projects, tags"
)
p <- argparser::add_argument(
  p, "--entity_type", short = "-t",
  help = "For module: summary, list, view - One of: project, tag, site, individual",
  nargs = 1
)
p <- argparser::add_argument(
  p, "--entity_id", short = "-i",
  help = "For module: summary, list, view - Identifier of one or multiple: projects, tags, sites, individuals"
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
module <- argv$module
entity_type <- argv$entity_type
entity_id <- argv$entity_id

cred_file <- argv$credentials
cache_dir <- argv$cache_dir

# input argument checks
# TODO

#### connect to PANDORA ####

con <- sidora.core::get_pandora_connection()

#### call modules ####

# module projects
if (module == "projects") {
  "Not implemented"
# module tags
} else if (module == "tags") {
  "Not implemented"
# module summary
} else if (module = "summary") {
  if (entity_type == "project") {
    "Not implemented"
  } else if (entity_type == "tag") {
    "Not implemented"
  } else if (entity_type == "site") {
    source("site.R", local = T, print.eval = T)
  } else if (entity_type == "individual") {
    "Not implemented"
  }
# module list
} else if (module == "list") {
  if (entity_type == "project") {
    "Not implemented"
  } else if (entity_type == "tag") {
    "Not implemented"
  } else if (entity_type == "site") {
    source("site.R", local = T, print.eval = T)
  } else if (entity_type == "individual") {
    "Not implemented"
  }
# module view
} else if (module == "view") {
  if (entity_type == "project") {
    "Not implemented"
  } else if (entity_type == "tag") {
    "Not implemented"
  } else if (entity_type == "site") {
    "Not implemented"
  } else if (entity_type == "individual") {
    "Not implemented"
  }
}
