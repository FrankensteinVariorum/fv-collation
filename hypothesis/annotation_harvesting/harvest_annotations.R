library(httr)
#library(rapiclient)
library(jsonlite)
library(glue)
library(purrr)

hyp_token <- readLines("hypothesis/annotation_harvesting/.hypothesis_token")

# I'd use the very clevery `rapiclient` package, except that it seems to get
# confused when writing the function for the /search path, and ends up
# duplicating the "group" argument which we very much need. Will revisit if I
# can, but for now we just build the GET calls manually.

# hyp_api <- get_api("hypothesis/annotation_harvesting/hypothesis.json")
# hyp_ops <- get_operations(hyp_api, .headers = c(Authorization = paste("Bearer", hyp_token)), path = "search")

fraken_group <- "GwWrAWaw"

get_annotation_set <- function(offset = 0, limit = 200, group, token) {
  message(glue("Fetching offset {offset}..."))
  content(GET(glue("https://hypothes.is/api/search?offset={offset}&limit={limit}&group={fraken_group}&sort=id"), add_headers(Authorization = glue("Bearer {token}"))))
}

get_all_annotations <- function(group, token) {
  total_annotations <- get_annotation_set(limit = 1, group = group, token = token)[[2]]
  page_sequence <- seq(0, total_annotations, by = 200)
  map(page_sequence, get_annotation_set, group = group, token = token) %>% 
    map(1) %>% 
    flatten()
}

frankenstein_annotations <- get_all_annotations(fraken_group, hyp_token)

write_json(frankenstein_annotations, path = "hypothesis/annotation_harvesting/annotations.json", pretty = TRUE, auto_unbox = TRUE)
