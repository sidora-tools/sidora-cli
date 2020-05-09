#!/usr/bin/env Rscript

#### install necessary R packages if not available yet ####

necessary_packages <- c("magrittr", "argparser", "devtools", "sidora.core", "tibble", "txtplot", "dplyr", "readr")
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

# specific options
p <- argparser::add_argument(
  p, "--as_tsv",
  help = "For module: list - Return the list as tab-separated data", 
  flag = T
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
entity_id <- unlist(strsplit(argv$entity_id, ","))

as_tsv <- argv$as_tsv

cred_file <- argv$credentials
cache_dir <- argv$cache_dir

# input argument checks
# TODO

#### connect to PANDORA ####

con <- sidora.core::get_pandora_connection()

#### call modules and load data ####
source("helpers.R", local = T, print.eval = T)

# module projects
if (module == "projects") {
  cat("Not implemented\n")
# module tags
} else if (module == "tags") {
  cat("Not implemented\n")
# module summary
} else if (module == "summary") {
  load("supp_data/world_map_data.RData")
  if (entity_type == "project") {
    cat("Not implemented\n")
  } else if (entity_type == "tag") {
    cat("Not implemented\n")
  } else if (entity_type == "site") {
    source("summary_site.R", local = T, print.eval = T)
  } else if (entity_type == "individual") {
    cat("Not implemented\n")
  }
# module list
} else if (module == "list") {
  if (entity_type == "project") {
    cat("Not implemented\n")
  } else if (entity_type == "tag") {
    cat("Not implemented\n")
  } else if (entity_type == "site") {
    source("list_site.R", local = T, print.eval = T)
  } else if (entity_type == "individual") {
    cat("Not implemented\n")
  }
# module view
} else if (module == "view") {
  if (entity_type == "project") {
    cat("Not implemented\n")
  } else if (entity_type == "tag") {
    cat("Not implemented\n")
  } else if (entity_type == "site") {
    source("view_site.R", local = T, print.eval = T)
  } else if (entity_type == "individual") {
    cat("Not implemented\n")
  }
}
