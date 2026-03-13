

file <- here::here("data", "p2025_Affirmative action, etc..rda")

file.exists(file |> str_replace("racialization", "2025"))

file.copy(from = file |> str_replace("racialization", "2025"),
          to = file,
          overwrite = T)

load(here::here("data", "p2025_Affirmative action, etc..rda"))

mfl <- p2025
mfl_terms <- mfl$terms[1]
mfl <- mfl |> select(-terms, -Terms)
kablebox(mfl)

# only IHS has
# mfl |> filter(n> paragraphs)

mfl %<>% mutate(year = 2024,
                agency = str_remove(department_agency_acronym, "_.*") ,
                total = paragraphs)

mfl_depts <- mfl %>%
  filter(str_detect(department_agency_acronym, "_") )


mfl_depts <- mfl %>%
  filter(agency %in% mfl_depts$agency )


mfl_ind <- mfl |> filter(# subagencies or independent
  str_detect(department_agency_acronym, "_") | !agency %in% mfl_depts$agency)


mfl_depts %<>%
  # total per department
  group_by(agency) %>%
  mutate(total = sum(total, na.rm = T),
         n = sum(n, na.rm = T) ) %>%
  ungroup() %>%
  filter(department_agency_acronym == agency)



mfl <-  full_join(mfl_depts, mfl_ind) %>%
  mutate(MFL_n = n,
         MFL_total = total,
         MFL_percent = n/total,
         # standardize variance of counts
         n =  sqrt(n),
         total = sqrt(total),
         # normalize mean 0, sd 1
         MFL_norm = (n - mean(n, na.rm = T))/sd(n, na.rm = T),
         percent = n/total,
         MFL_percent_norm =  (percent - mean(percent, na.rm = T))/sd(percent, na.rm = T))  %>%
  select(year, agency, department_agency_acronym,
         MFL_n,  MFL_total, MFL_percent,
         MFL_norm, MFL_percent_norm)

save(mfl, file = here::here("data", "mfl.rda"))

