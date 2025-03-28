source("setup.R")

library(tidyverse)

dir <- here::here("data", "search") |> str_replace("racialization", "regulationsdotgov-data")

terms <- list.dirs(dir, full.names = F)

# term <- terms[2]

p <- function(term){

path <- here::here(dir, term, paste0(term, "_documents.rda"))

load(path)

df <- d |>  #comments |>
  mutate(year = str_sub(postedDate, 1,4) |> as.numeric()) |>
  count(agencyId, year) |>
  group_by(agencyId) |>
  mutate(perAgency = sum(n)) |>
  mutate(president = case_when(
    year < 2009 ~ "Bush",
    year > 2008 & year < 2017 ~ "Obama",
    year > 2016 & year < 2021 ~  "Trump",
    year > 2020 & year < 2025 ~ "Biden"
  ))

df |>
  filter(perAgency > 200,
         year > 2004,
         year < 2025) |>
  ggplot() +
  aes(x = year, y = n, color = president) +
  geom_point() +
  labs(title = term) +
  geom_smooth(#method = "lm",
              se = F) +
  facet_wrap("agencyId",
             scales = "free_y")

}
