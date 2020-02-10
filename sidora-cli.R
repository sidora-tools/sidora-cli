library(sidora.core)
library(tidyverse)

creds <- readLines(".credentials")
con <- DBI::dbConnect(
  RMySQL::MySQL(), 
  host = creds[1],
  user = creds[2],
  password = creds[3],
  db = "pandora"
)

pr = "SouthAfrica_Sutherland"

site_con <- get_con("TAB_Site", con) %>% filter(Projects==pr)
ind_con <- get_con("TAB_Individual", con) %>% filter(Projects==pr)
sample_con <- get_con("TAB_Sample", con) %>% filter(Projects==pr)

con_list = list("TAB_Site"=site_con, "TAB_Individual"=ind_con, "TAB_Sample"=sample_con)

p <- join_df_list(con_list) %>% as_tibble()

print(p)
