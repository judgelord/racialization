library(tidyverse)



read <- function(file){
  d <- here::here(folder, file) |>
    read_csv() |>
    mutate(agency = file |> str_remove(" .*"),
           year = str_sub(Date, 1, 4)) |>
   count(agency, year)

   return(d)
}

folder <- here::here("data", "ProQuest", "2026", "nyt racial counts" )
files <-  list.files(folder)
files

nyt_racial <- map_dfr(files, read)
save(nyt_racial, file = here::here("data", "nyt_racial.rda"))

folder <- here::here("data", "ProQuest", "2026", "nyt total counts" )
files <-  list.files(folder)
files

nyt_total <- map_dfr(files, read)
save(nyt_total, file = here::here("data", "nyt_total.rda"))


