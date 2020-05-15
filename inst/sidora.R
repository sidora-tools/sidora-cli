#!/usr/bin/env Rscript

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
  help = "One of: view, summary, list, tabulate"
)
p <- argparser::add_argument(
  p, "--entity_type", short = "-t",
  help = "For module: view, summary, list, tabulate - One of: project, tag, site, individual",
  nargs = 1
)
p <- argparser::add_argument(
  p, "--entity_id", short = "-i",
  help = "For module: view, summary, list, tabulate - Identifier of one or multiple: projects, tags, sites, individuals"
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

# module list
if (module == "list") {
  cat("Not implemented\n")
# module view
} else if (module == "view") {
  if (entity_type == "project") {
    cat("Not implemented\n")
  } else if (entity_type == "tag") {
    cat("Not implemented\n")
  } else if (entity_type == "site") {
    sidora.cli::view_site(con, entity_id, cache_dir)
  } else if (entity_type == "individual") {
    cat("Not implemented\n")
  }
# module summary
} else if (module == "summary") {
  if (entity_type == "project") {
    cat("Not implemented\n")
  } else if (entity_type == "tag") {
    cat("Not implemented\n")
  } else if (entity_type == "site") {
    sidora.cli::summary_site(con, entity_id, cache_dir)
  } else if (entity_type == "individual") {
    cat("Not implemented\n")
  }
# module tabulate
} else if (module == "tabulate") {
  if (entity_type == "project") {
    cat("Not implemented\n")
  } else if (entity_type == "tag") {
    cat("Not implemented\n")
  } else if (entity_type == "site") {
    sidora.cli::tabulate_site(con, entity_id, as_tsv, cache_dir)
  } else if (entity_type == "individual") {
    cat("Not implemented\n")
  }
}
