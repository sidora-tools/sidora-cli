#' Run a quick demo 
#' @export
print_progress_table <- function() {
  con <- get_pandora_connection()
  pr <- "IronAge_Celts"
  tag <- "Deep_Evolution"
  make_joint_table(con) %>%
    filter_tag(tag) %>%
    make_progress_table %>%
    knitr::kable()
}  
