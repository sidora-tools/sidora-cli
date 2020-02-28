#' Run a quick demo 
#' @export
run_demo <- function() {
  con <- get_pandora_connection()
  pr <- "IronAge_Celts"
  joint_table <- make_joint_table(con, pr)
  progress_table <- make_progress_table(joint_table)
  print(progress_table)
}  
