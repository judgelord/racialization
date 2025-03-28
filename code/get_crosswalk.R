library(googlesheets4)
crosswalk <- read_sheet("https://docs.google.com/spreadsheets/d/1lxKi3EsOREE-YoOjPE6nIxzwfyJJYbao2YUji__UR7c/edit?gid=0#gid=0") |>
  mutate(other_names = other_names |> str_remove("\\|.*"))

crosswalk <- crosswalk |>
  mutate(agency_short = coalesce(agency_short, regulationsdotgov_agency, other_names, department)) |>
  select(department, agency_short, department_agency_acronym, department_acronym, other_acronyms, other_names)

save(crosswalk, file = here::here("data", "crosswalk.rda"))
