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
p <- argparser::add_argument(p, "--credentials", help = "path to the credentials file", type = "character", default = ".credentials", short = "-c")
p <- argparser::add_argument(p, "--cache_dir", help = "path to table cache directory", type = "character", default = "/tmp/sidora.cli_table_cache", short = "-d")
p <- argparser::add_argument(p, "--tag", help = "...", default = "Deep_Evolution")

# parse the command line arguments
argv <- argparser::parse_args(p)

# write cli args to individual variablels 
cred_file <- argv$credentials
cache_dir <- argv$cache_dir
tag <- argv$tag

#### connect to PANDORA ####

if(!file.exists(cred_file)) {
  stop(paste(
    "Can't find .credentials file. Please create one ",
    "containing three lines: the Database Host, the username, ",
    "the password."
  ))
}
creds <- readLines(cred_file)
con <- DBI::dbConnect(
  RMariaDB::MariaDB(),
  host = creds[1],
  user = creds[2],
  password = creds[3],
  db = "pandora"
)

#### download and cache data ####

make_joint_table <- function(con) {
  table_names <- c("TAB_Site", "TAB_Individual", "TAB_Sample", "TAB_Extract", "TAB_Library",
                   "TAB_Capture", "TAB_Sequencing")#, "TAB_Raw_Data", "TAB_Analysis", "TAB_Analysis_Result_String")
  tables <- sidora.core::get_df_list(con, tab = table_names, cache_dir = cache_dir)
  return(sidora.core::join_pandora_tables(tables))
}

pandora_data <- make_joint_table(con) 

#### apply filter operations ####

filter_tag <- function(joint_table, tag) {
  dplyr::filter(joint_table, grepl(tag, .data$Tags.Individual))
}

pandora_data_filtered <- filter_tag(pandora_data, tag) 

#### prepare progress table (or do other stuff) ####

make_progress_table <- function(joint_table) {
  joint_table %>%
    dplyr::mutate(
      sg_sequencing_id = ifelse(.data$Probe_Set == 16, .data$Full_Sequencing_Id, NA),
      non_sg_capture_id = ifelse(.data$Probe_Set != 16, .data$Full_Capture_Id, NA),
      non_sg_sequencing_id = ifelse(.data$Probe_Set != 16, .data$Full_Sequencing_Id, NA)
    ) %>%
    dplyr::group_by(.data$Full_Individual_Id) %>%
    dplyr::summarise(
      country = dplyr::first(.data$Country),
      site_name = dplyr::first(.data$Name),
      nr_samples = dplyr::n_distinct(.data$Full_Sample_Id, na.rm = TRUE),
      nr_extracts = dplyr::n_distinct(.data$Full_Extract_Id, na.rm = TRUE),
      nr_libraries = dplyr::n_distinct(.data$Full_Library_Id, na.rm = TRUE),
      nr_shotgun_screenings = dplyr::n_distinct(.data$sg_sequencing_id, na.rm = TRUE),
      nr_captures = dplyr::n_distinct(.data$non_sg_capture_id, na.rm = TRUE),
      nr_sequencings = dplyr::n_distinct(.data$non_sg_sequencing_id, na.rm = TRUE)
    )
}

pandora_data_progress_table <- make_progress_table(pandora_data_filtered)

#### nice output ####

knitr::kable(pandora_data_progress_table)
