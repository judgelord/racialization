
library(tidyverse)
library(magrittr)

library(googlesheets4)
bonica <- read_sheet("https://docs.google.com/spreadsheets/d/1l80SG27cxUOAHknYvmp-LV6Ag5phGlBVJbqG2U066AI/edit?gid=0#gid=0")

crosswalk <- read_sheet("https://docs.google.com/spreadsheets/d/1lxKi3EsOREE-YoOjPE6nIxzwfyJJYbao2YUji__UR7c/edit?gid=0#gid=0") |>
  mutate(other_names = other_names |> str_remove("\\|.*"))

bonica$Agency <- str_remove(bonica$Agency, " \\(.*")

bonica %<>% left_join(crosswalk |>
                        select(regulationsdotgov_agency, department_agency_acronym),
                      by= c("Agency" = "regulationsdotgov_agency"))

bonica %<>% left_join(crosswalk|>
                        select(agency_short, department_agency_acronym),
                      by= c("Agency" = "agency_short")) %>%
  mutate(department_agency_acronym = coalesce(department_agency_acronym.x, department_agency_acronym.y) ) %>%
  select(-department_agency_acronym.x, -department_agency_acronym.y)

bonica %<>% left_join(crosswalk|>
                        select(other_names, department_agency_acronym),
                      by= c("Agency" = "other_names")) %>%
  mutate(department_agency_acronym = coalesce(department_agency_acronym.x, department_agency_acronym.y) )%>%
  select(-department_agency_acronym.x, -department_agency_acronym.y)



bonica %>%
  filter(is.na(department_agency_acronym)) |>
  pull(Agency)

bonica %>% count(Agency, sort = T)

bonica %>% count(department_agency_acronym, sort = T)

bonica |> save(file = here::here("data", "bonica.rda"))
