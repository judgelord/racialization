
######################
# COMMENTS
#######################



# THEN COMBINE THE DATA
p <- function(term){

  path <- here::here(directory, term, paste0(term, "_commentss.rda"))

  load(path)

  return(comments)
}

c <- map_dfr(terms, p)

