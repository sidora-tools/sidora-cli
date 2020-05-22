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
  help = "One of: view, summarise, list, tabulate"
)
p <- argparser::add_argument(
  p, "--entity_type", short = "-t",
  help = "For module: view, summarise, list, tabulate - One of: project, tag, site, individual",
  nargs = 1
)
p <- argparser::add_argument(
  p, "--entity_id", short = "-i",
  help = "For module: view, summarise, list, tabulate - Identifier of one or multiple: projects, tags, sites, individuals"
)

# filter interface
p <- argparser::add_argument(
  p, "--filter_entity_type", short = "-f",
  help = "For module: list, tabulate - One of: project, tag, site, individual, ...",
  nargs = 1
)
p <- argparser::add_argument(
  p, "--filter_string", short = "-s",
  help = "..."
)

# specific options
p <- argparser::add_argument(
  p, "--as_tsv",
  help = "For module: tabulate - Return the list as tab-separated data", 
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

filter_entity_type <- argv$filter_entity_type
filter_string <- argv$filter_string

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
  sidora.cli::list_module(con, entity_type, cache_dir)
# module view
} else if (module == "view") {
  sidora.cli::view_module(con, entity_type, entity_id, cache_dir)
# module summarise
} else if (module == "summarise") {
  if (entity_type == "project") {
    cat("Not implemented\n")
  } else if (entity_type == "tag") {
    cat("Not implemented\n")
  } else if (entity_type == "site") {
    sidora.cli::summarise_site(con, entity_id, cache_dir)
  } else if (entity_type == "individual") {
    sidora.cli::summarise_individual(con, entity_id, cache_dir)
  } else if (entity_type == "sample") {
    sidora.cli::summarise_sample(con, entity_id, cache_dir)
  } else if (entity_type == "extract") {
    sidora.cli::summarise_extract(con, entity_id, cache_dir)
  } else if (entity_type == "library") {
    sidora.cli::summarise_library(con, entity_id, cache_dir)
  }
# module tabulate
} else if (module == "tabulate") {
  sidora.cli::tabulate_module(con, entity_type, filter_entity_type, filter_string, as_tsv, cache_dir)
}
