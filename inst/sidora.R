#!/usr/bin/env Rscript

library(magrittr)

#### command line input parsing ####

# create cli arg parser
p <- argparser::arg_parser(
  name = "sidora.cli", 
  description = c(
    "MPI-SHH DAG Pandora DB command line interface.", 
    "See https://github.com/sidora-tools/sidora.cli for more information."
  ),
  hide.opts = T
)

# general interface
p <- argparser::add_argument(
  p, "module",
  help = paste(c(
    "sidora-cli operation you want to perform. One of: view, summarise, list, tabulate.",
    "The modules allow to access Pandora data in different ways and therefore have different",
    "command line options.",
    "[view]: Show basic information for an individual entry of Pandora.",
    "[summarise]: Show more sophisticated (cross-table) information for an individual entry.",
    "[list]: Show a (filtered) list of identifiers for multiple entries.",
    "[tabulate]: Show a table with information for multiple entries."
  ), collapse = "\n")
)
p <- argparser::add_argument(
  p, "--entity_type", short = "-t",
  help = "|[view], [summarise], [list], [tabulate]| Pandora entity type (table) you want to access. e.g. \"project\", \"site\", \"individual\"",
  nargs = 1
)
p <- argparser::add_argument(
  p, "--entity_id", short = "-i",
  help = "|[view], [summarise], [list], [tabulate]| Identifier of one or multiple (separated by \",\") pandora entries depending on the selected entity_type. e.g. \"Futuna\", \"FUT001\", \"FUT001.A0101\""
)

# filter interface
p <- argparser::add_argument(
  p, "--filter_entity_type", short = "-f",
  help = "|[list], [tabulate]| Pandora entity type you want to use to filter the input entity_type: e.g. \"project\", \"site\", \"individual\"",
  nargs = 1
)
p <- argparser::add_argument(
  p, "--filter_string", short = "-s",
  help = "|[list], [tabulate]| Filter operation you want to perform on the columns of the filter_entity_type: e.g. \"site.Country == 'Germany'\", \"site.Latitude > 46 & site.Latitude < 55 & site.Longitude > 6 & site.Longitude < 16\""
)

# specific options
p <- argparser::add_argument(
  p, "--as_tsv",
  help = "|[tabulate]| Return the table as tab-separated data", 
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

con <- sidora.core::get_pandora_connection(cred_file)

#### call modules and load data ####

# module list
if (module == "list") {
  sidora.cli::list_module(con, entity_type, entity_id, filter_entity_type, filter_string, cache_dir)
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
  sidora.cli::tabulate_module(con, entity_type, entity_id, filter_entity_type, filter_string, as_tsv, as_id_list = F, cache_dir)
}
