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