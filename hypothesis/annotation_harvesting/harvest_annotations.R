library(httr)
#library(rapiclient)
library(jsonlite)

hyp_token <- readLines("hypothesis/annotation_harvesting/.hypothesis_token")

# I'd use the very clevery `rapiclient` package, except that it seems to get
# confused when writing the function for the /search path, and ends up
# duplicating the "group" argument which we very much need. Will revisit if I
# can, but for now we just build the GET calls manually.

# hyp_api <- get_api("hypothesis/annotation_harvesting/hypothesis.json")
# hyp_ops <- get_operations(hyp_api, .headers = c(Authorization = paste("Bearer", hyp_token)), path = "search")

fraken_group <- "GwWrAWaw"

frankenstein_annotations_1 <- content(GET("https://hypothes.is/api/search?limit=200&group=GwWrAWaw", add_headers(Authorization = paste("Bearer", hyp_token))))
frankenstein_annotations_2 <- content(GET("https://hypothes.is/api/search?limit=200&offset=200&group=GwWrAWaw", add_headers(Authorization = paste("Bearer", hyp_token))))
frankenstein_annotations <- c(frankenstein_annotations_1[[1]], frankenstein_annotations_2[[1]])

write_json(frankenstein_annotations, path = "hypothesis/annotation_harvesting/annotations.json", pretty = TRUE, auto_unbox = TRUE)
