


directory <- here::here("data", "search") |> str_replace("racialization", "regulationsdotgov-data")

terms <- list.dirs(directory, full.names = F)

terms <- terms[!terms %in% c("", "comment_details", "documents", "comments")]

terms |>  str_c(collapse = '","') |> knitr::kable()

terms <- c(#"adversely",
           "Affirmative Action",#"affirmatively",
           "African American",
            "alien","Antiracist","Arab American","Asian American","Black american",
            "Colorblindness",#"community",
           "Critical Race Theory","D.E.I.",
            "DACA",
           #"disparate","Diverse",
           #"diversity",
           "Diversity equity",
            "Diversity, equity","Drug Cartel",
"Black men","Black woman","Black women","Border Crisis",
"Equity","Ethnicity","Gang","Hispanic",
"Unaccompanied Alien Childen","underserved","Undocumented","White Privilege",
"Illegal Alien","Immigrant","Immigration",
"Intersectional","latina","latino",
"MENA","Meritocracy","Mexican Cartel","Multicultural","Muslim",
"racial","Racial inequities","Racial injustices","Racial Justice",
"Racism","Racist","Secure Border","Secure the border","Slavery",
"Unaccompanied Alien Childen","underserved","Undocumented","White Privilege",
"Citizenship","Civil Rights")

if(F){
gender <- c("Assigned male at birth","biologically female","biologically male",
            "Gender","gender identity","genderqueer")

native <- c("cherokee nation")

environment <- c("clean energy","climate change","climate crisis",
                 "climate justice","climate science",
                 "environmental justice","environmental quality")

tbd <- c("Hate speech","Historically",
                 "inequality","inequity","Institutional",
                 "LGBT",
                 "national congress of american indians",
                 "Native American",
                 "Nonbinary","Oppression",
                 "pollution",
                 "Pregnant people","pregnant person",
                 "racial","Racial inequities","Racial injustices","Racial Justice","Racism","Racist","Secure Border","Secure the border","Slavery",
                 "systemic",
                 "Terrorist",
                 "Transgender","transsexual","Trauma")
}

# term <- terms[18]

# load("/Users/judgelor/University of Michigan Dropbox/Devin Judge-Lord/regulationsdotgov-data/data/search/underserved/underserved_documents.rda")
# documents <- comments
# save(documents , file = "/Users/judgelor/University of Michigan Dropbox/Devin Judge-Lord/regulationsdotgov-data/data/search/underserved/underserved_documents.rda")

# FIRST CORRECT MIS-LABELED OBJECTS (documents called "comments")
p <- function(term){

  path <- here::here(directory, term, paste0(term, "_documents.rda")) |> str_remove("racialization")

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

# THEN COMBIND THE DATA
p <- function(term){

  path <- here::here(directory, term, paste0(term, "_documents.rda")) |> str_remove("racialization")

  load(path)

  return(documents)
}

d <- map_dfr(terms, p)


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


save(rules_racial_all,
     file = here::here("data", "rules_racial_all.rda"))


rules_racial_distinct <- rules_racial_all |>
  distinct(id, agencyId, department_agency_acronym, postedDate, documentType) |>
  drop_na(agencyId)

save(rules_racial_distinct,
     file = here::here("data", "rules_racial_distinct.rda"))


rules_racial_distinct_totals <- rules_racial_distinct |>
  drop_na(department_agency_acronym) |>
  group_by(agencyId, department_agency_acronym, documentType) |>
  summarise(n = n() ) |>
  ungroup()

save(rules_racial_distinct_totals,
     file = here::here("data", "rules_racial_distinct_totals.rda"))


save(terms, file=here::here("data", "rules_terms.rda"))

