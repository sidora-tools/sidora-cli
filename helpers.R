fuzzy_search <- function(pattern, search_vector) {
  cat("There is no entity with that entity_id. Did you mean one of the following entities?\n- ")
  cat(agrep(pattern, search_vector, value = T)[1:5], sep = "\n- ")
}
