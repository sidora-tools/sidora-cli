#!/usr/bin/env Rscript

#### install necessary R packages if not available yet ####

necessary_packages <- c("magrittr", "argparser", "devtools", "sidora.core")
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
  p, "tool", 
  help = "select sidora.cli function", 
  type = "character",
  flag = TRUE
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
  p, "--tag", help = "...", 
  default = "Deep_Evolution"
)

# parse the command line arguments
argv <- argparser::parse_args(p)

# stop if tool not selected
if (!argv$tool) {
  stop("Please select a sidora.cli tool.")
}

# write cli args to individual variablels 
cred_file <- argv$credentials
cache_dir <- argv$cache_dir
tag <- argv$tag

#### connect to PANDORA ####

con <- sidora.core::get_pandora_connection()

#### download and cache data ####

table_names <- c(
  "TAB_Site", "TAB_Individual", "TAB_Sample", "TAB_Extract", "TAB_Library",
  "TAB_Capture", "TAB_Sequencing"
)#, "TAB_Raw_Data", "TAB_Analysis", "TAB_Analysis_Result_String")

tables <- sidora.core::get_df_list(con, tab = table_names, cache_dir = cache_dir)

pandora_data <- sidora.core::join_pandora_tables(tables)

#### apply filter operations ####

pandora_data_filtered <- sidora.core::filter_pr_tag(pandora_data, col = "Tags.Individual", ins = tag) 

#### prepare progress table (or do other stuff) ####

pandora_data_progress_table <- sidora.core::make_progress_table(pandora_data_filtered)

#### nice output ####

knitr::kable(pandora_data_progress_table)
