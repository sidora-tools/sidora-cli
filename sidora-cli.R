creds <- readLines(".credentials")
con <- DBI::dbConnect(
  RMySQL::MySQL(), 
  host = creds[1],
  user = creds[2],
  password = creds[3],
  db = "pandora"
)

pr = "SouthAfrica_Sutherland"

`%>%` <- dplyr::`%>%`
tableNames <- c("TAB_Site", "TAB_Individual", "TAB_Sample", "TAB_Extract", "TAB_Library")
table_cons <- lapply(tableNames,
                     function(n) {
                       sidora.core::get_con(n, con) %>% dplyr::filter(Projects==pr)
                     }
                    )
names(table_cons) <- tableNames

p <- sidora.core::join_df_list(table_cons) %>% dplyr::as_tibble()
print(p)
