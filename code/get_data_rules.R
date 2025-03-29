


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

# term <- terms[18]

# FIRST CORRECT MIS-LABELED OBJECTS (documents called "comments")
p <- function(term){

  path <- here::here(directory, term, paste0(term, "_documents.rda")) |> str_remove("racialization")

  load(path)
  message(ls() |> str_remove_all("path|term"), "|", term, "|") #, unique(d$searchTerm) )



  #documents <- d

  #save(documents, file = path)
}

walk(terms, p)

# THEN COMBIND THE DATA
p <- function(term){

  path <- here::here(directory, term, paste0(term, "_documents.rda")) |> str_remove("racialization")

  load(path)

  return(documents)
}

d <- map_dfr(terms, p)

rules_racial_all <- d

save(rules_racial_all,
     file = here::here("data", "rules_racial_all.rda"))


rules_racial_distinct <- d |> distinct(id, agencyId, postedDate, documentType)


save(rules_racial_distinct,
     file = here::here("data", "rules_racial_distinct.rda"))

save(terms, file=here::here("data", "rules_terms.rda"))

