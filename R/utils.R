#' @importFrom magrittr '%>%'
NULL

#' Get the connection object for the Pandora DB 
#' @param cred_file A credentials file containing three lines
#'   listing host, user and password, respectively
#' @return The Pandora DB connection object.
get_pandora_connection <- function (cred_file = ".credentials") {
  if(!file.exists(cred_file))
    stop(paste("Can't find .credentials file. Please create one ",
               "containing three lines: the Database Host, the username, ",
               "the password."))
  creds <- readLines(cred_file)
  con <- DBI::dbConnect(
    RMariaDB::MariaDB(), 
    host = creds[1],
    user = creds[2],
    password = creds[3],
    db = "pandora"
  )
  return(con)    
}

#' Get the joint table from Pandora, restricted to a specific project
#' 
#' @param con The DB connection object
#' @param pr The name of the Project
#' @return A tibble joining sites, individuals, samples,
#'   extracts and libraries
make_joint_table <- function(con, pr) {
  table_names <- c("TAB_Site", "TAB_Individual", "TAB_Sample", "TAB_Extract", "TAB_Library")
  tables <- sidora.core::get_con_list(con, tab=table_names)
  tables_filtered <- lapply(tables, function(t) {t %>% dplyr::filter(.data$Projects==pr)})
  return(sidora.core::join_pandora_tables(tables_filtered) %>% dplyr::as_tibble())
}

#' Make an individual-based progress table
#' 
#' @param joint_table The joint table object generated with \code{\link{make_joint_table}}
#' @return A tibble containing the progress table.
make_progress_table <- function(joint_table) {
  joint_table %>%
    dplyr::group_by(.data$Full_Individual_Id) %>%
    dplyr::summarise(
      country = dplyr::first(.data$Country),
      site_name = dplyr::first(.data$Name),
      nr_samples = dplyr::n_distinct(.data$Full_Sample_Id, na.rm = TRUE),
      nr_extracts = dplyr::n_distinct(.data$Full_Extract_Id, na.rm = TRUE),
      nr_libraries = dplyr::n_distinct(.data$Full_Library_Id, na.rm = TRUE)
    )
}