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



# combined
nyt <- full_join(
  nyt_total |> rename(total = n),
  nyt_racial |> rename(term_count = n)
) |>
  mutate(term_count = tidyr::replace_na(term_count, 0),
         ratio = (term_count/total),
         term = "All racialized terms"
  ) |>
  # add covariates
  mutate(president = case_when(
    year > 2004 & year < 2009 ~ "Bush2",
    year > 2008 & year < 2013 ~ "Obama",
    year > 2012 & year < 2017 ~ "Obama2",
    year > 2016 & year < 2021 ~  "Trump",
    year > 2020 & year < 2025 ~ "Biden",
    year > 2024 & year < 2029 ~ "Trump2" )) |>
  filter(year > 2004,
         year < 2026)

# corrections (diff between regulations.gov and canonical crosswalk)
nyt %<>% mutate(agency = agency |>
                  str_replace("FERC", "DOE_FERC") |>
                  str_replace("TREAS", "Treasury"),
                department_agency_acronym = agency,
                agency = str_remove(agency, "_.*"))

save(nyt, file = here::here("data", "nyt.rda"))

