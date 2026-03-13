library(googlesheets4)
googlesheets4::gs4_deauth()
gs4_auth(email = "devin.jl@gmail.com")

library(tidyverse)


searchTerms = read_sheet("1LLKWDHiwnVEpvlqurI1t7NNHmdrk2liXPd-FZkNrvW0", sheet = "Racialized Terms")|>
  drop_na(term) |>
  filter(!str_detect(term, "/")) |>
  pull(term) |>
  unique()

# temp fixes
terms <- searchTerms[!searchTerms %in% c("Heritage American", "Reverse discrimination")]


# collected
directory <- here::here("data", "search") |> str_replace("racialization", "regulationsdotgov-data")

terms_collected <- list.dirs(directory, full.names = F)

terms_collected <- terms_collected[!terms %in% c("", "comment_details", "documents", "comments")]

terms_collected |>  str_c(collapse = '","') |> knitr::kable()


# term <- searchTerm[18]

# FIRST CORRECT MIS-LABELED OBJECTS (documents called "comments")
p <- function(term){

  path <- here::here(directory, term, paste0(term, "_documents.rda"))

  load(path)
  message(ls() |> str_remove_all("path|term"), "|", term, "|"  , unique(documents$searchTerm) )

if(exists("d") & !exists("documents")){
  documents <- d
  save(documents, file = path)
}

  if(exists("comments") & !exists("documents")){
    documents <- comments
    save(documents, file = path)
  }

}

walk(terms, p)


######################
# DOCUMENTS
#######################

# THEN COMBINE THE DATA
p <- function(term){

  path <- here::here(directory, term, paste0(term, "_documents.rda"))

  load(path)

  return(documents)
}

d <- map_dfr(terms, p)

# crosswalk
load(here::here("data", "crosswalk.rda"))

rules_racial_all <- d |>
  # CORRECTIONS DUE TO DUPLICATE IDS IN REGULATIONS DOT GOV
  mutate(agencyId = agencyId |>
           str_replace("CORP", "CNCS") |>
           str_replace("USEIB", "EIB")
           ) |>
  left_join(crosswalk |> drop_na(regulationsdotgov_acronym),
            by = c("agencyId" = "regulationsdotgov_acronym"))


rules_racial_all |>
  filter(is.na(department_agency_acronym)) |>
  count(agencyId)

inspect <- rules_racial_all |>
  filter(is.na(department_agency_acronym))


save(rules_racial_all,
     file = here::here("data", "rules_racial_all.rda"))


rules_racial_distinct <- rules_racial_all |>
  distinct(id, agencyId, department_agency_acronym, postedDate, documentType, docketId) |>
  drop_na(agencyId)

save(rules_racial_distinct,
     file = here::here("data", "rules_racial_distinct.rda"))

rules_racial_distinct_totals <- rules_racial_distinct |>
  drop_na(department_agency_acronym) |>
  mutate(year = str_sub(postedDate, 1,4)) |>
  distinct(id, documentType, year, agencyId, docketId, department_agency_acronym) |>
  group_by(documentType, year, agencyId, docketId, department_agency_acronym) |>
  count() |>
  ungroup()

save(rules_racial_distinct_totals,
     file = here::here("data", "rules_racial_distinct_totals.rda"))


save(terms, file=here::here("data", "rules_terms.rda"))





# TOTALS
load(here::here("data", "metadata", "documents_count.rda") |> str_replace("racialization", "regulationsdotgov-data") )

rules_total <- documents_count |>
  # CORRECTIONS DUE TO DUPLICATE IDS IN REGULATIONS DOT GOV
  mutate(agencyId = agencyId |>
           str_replace("CORP", "CNCS") |>
           str_replace("USEIB", "EIB")
  ) |>
  left_join(crosswalk |> drop_na(regulationsdotgov_acronym),
            by = c("agencyId" = "regulationsdotgov_acronym"))

rules_total |> filter(is.na(regulationsdotgov_agency))

save(rules_total, file=here::here("data", "rules_total.rda"))


# COMBINED

rules_total  <- rules_total |>
  distinct(docketId, documentType, department_agency_acronym, year) |>
  filter(
    year > 2004,
    documentType %in% c("Proposed Rule", "Rule")  ) |>
  group_by(department_agency_acronym) |>
  count(name = "n") |>
  filter(n > 10) |>
  ungroup()

n_rules <- sum(rules_total$n, na.rm = T)

rules_racial <- rules_racial_distinct_totals |>
  distinct(docketId, documentType, department_agency_acronym, year) |>
  filter(
    year > 2004,
    documentType %in% c("Proposed Rule", "Rule")  ) |>
  group_by(department_agency_acronym) |>
  count(name = "n_racial") |>
  ungroup()

n_rules_racial <- sum(rules_racial$n_racial)

rules <- full_join(rules_total, rules_racial) |>
  mutate(n_racial = replace_na(n_racial, 0), # if not in racial data, assume 0 racialized rules
         sub = str_remove(department_agency_acronym, ".*_"),
         main = str_remove(department_agency_acronym, "_.*"))


n_rules_agencies <- distinct(rules, department_agency_acronym) |> nrow()



# rules_depts <- rules %>%
#   filter(str_detect(department_agency_acronym, "_") )
#
#
# rules_depts <- rules %>%
#   filter(main %in% rules_depts$main )
#
#
# rules_ind <- rules |> filter(# subagencies or independent
#   str_detect(department_agency_acronym, "_") | !main %in% rules_depts$main)
#
#
# rules_depts %<>%
#   # total per department
#   group_by(main) %>%
#             mutate(#total = sum(total, na.rm = T),
#                   n = sum(n, na.rm = T) ) %>%
#   ungroup() %>%
#   filter(department_agency_acronym == main)
#
#
#
# rules <-  full_join(rules_depts, rules_ind)

rules %<>%
  ungroup() %>%
  mutate(
    rules_percent = n_racial/n,
    rules_n = n_racial,
    sqrt_n = sqrt(n),
    sqrt_racial = sqrt(n_racial),
    rules_norm = (sqrt_racial - mean(sqrt_racial))/sd(sqrt_racial),
    sqrt_ratio = sqrt_racial/sqrt_n,
    rules_percent_norm =  (sqrt_ratio - mean(sqrt_ratio, na.rm = T))/sd(sqrt_ratio, na.rm = T)
  )


# add vars from crosswalk
rules %<>% left_join(crosswalk)

missing <- filter(rules, is.na(n)) |>
  select(min_missing = n_racial, regulationsdotgov_agency, regulationsdotgov_acronym) |>
  arrange(-min_missing)

missing$regulationsdotgov_acronym |> paste(collapse = "', '")

save(missing, file = here::here("data", "missing_agency_data.rda"))

# subset
rules %<>%
  distinct(rules_n,
           rules_percent,
           rules_norm,
           rules_percent_norm,
           department_agency_acronym) %>%
  ungroup()

save(rules, n_rules, n_rules_racial, n_rules_agencies, file = here::here("data", "rules.Rdata"))

