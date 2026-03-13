##################
#Proquest Search Syntax
#Magana, Karla
#Last Edited: 2/11/2026
#################

# Terms Dictionary

print(terms)

# Remove duplicates
terms_clean <- unique(terms)

# Fix typo manually
terms_clean <- gsub("Childen", "Children", terms_clean)

print(terms_clean)

# Add new terms
terms_clean <- unique(c(
  terms_clean,
  "Native American",
  "Black people",
  "Black man"
))

racial_terms <- c(
  "Affirmative Action",
  "African American",
  "African Americans",
  "Africans",
  "Alaskan Native",
  "Alien",
  "American Indian",
  "Anti-Discrimination",
  "Anti-Racism",
  "Anti-Racist",
  "Antidiscrimination",
  "Antiracism",
  "Antiracist",
  "Arab American",
  "Arabs",
  "Asian American",
  "Asians",
  "BIPOC",
  "Biracial",
  "Black American",
  "Black Americans",
  "Black Children",
  "Black Lives",
  "Black Man",
  "Black Men",
  "Black People",
  "Black Person",
  "Black Students",
  "Black Woman",
  "Black Women",
  "Border Crisis",
  "Citizenship",
  "Civil Rights",
  "Color Of Their Skin",
  "Colorism",
  "Communities Of Color",
  "Critical Race Theory",
  "Cultural Competence",
  "Culturally Competent",
  "D.E.I.",
  "DACA",
  "DEI",
  "Diversity And Inclusion",
  "Diversity Equity",
  "Diversity Lottery",
  "Diversity Objectives",
  "Diversity Officer",
  "Diversity Visa",
  "Diversity, Equity",
  "Diversity, Equity, And Inclusion",
  "Drug Cartel",
  "Enslavement",
  "Equal Opportunity",
  "Equity Agenda",
  "Ethnic",
  "Ethnic Diversity",
  "Ethnicity",
  "Gang",
  "HBCU",
  "Hispanic",
  "Historically Black College And University",
  "Illegal Alien",
  "Illegal Aliens",
  "Illegal Immigrant",
  "Illegal Immigrants",
  "Illegal Immigration",
  "Illegal Migration",
  "Immigrant",
  "Immigration",
  "Indian Education",
  "Indigenous Groups",
  "Indigenous People",
  "Indigenous Peoples",
  "Indigenous Person",
  "Inequality",
  "Inequitable",
  "Intersectionality",
  "Latina",
  "Latinas",
  "Latino",
  "Latinos",
  "Latinx",
  "Men Of Color",
  "Meritocracy",
  "Mexican Cartel",
  "Mexican Drug Cartel",
  "Mexicans",
  "Middle Eastern Or North African Ancestry",
  "Migrant",
  "Minority Populations",
  "Minority Status",
  "Minority-Serving",
  "Mixed Race",
  "Mixed-Race",
  "Multicultural",
  "Multiracial",
  "Muslim",
  "Nationality",
  "Native American",
  "Native-Serving",
  "Non-White",
  "Nonminority",
  "Oppression",
  "Oppressors",
  "Pacific Islander",
  "People Of Color",
  "People Of Minority Status",
  "Person Of Color",
  "Predominately White",
  "Prejudice",
  "Puerto Ricans",
  "Racial",
  "Racial Diversity",
  "Racial Identity",
  "Racial Inequality",
  "Racial Inequities",
  "Racial Injustices",
  "Racial Justice",
  "Racially",
  "Racism",
  "Racist",
  "Secure Border",
  "Secure The Border",
  "Securing The Border",
  "Skin Color",
  "Slavery",
  "Social Justice",
  "Socioeconomic",
  "Socioeconomically",
  "South Asian American",
  "South Asians",
  "Stereotypes",
  "Structural Racism",
  "Systemic Racism",
  "Tribal",
  "Tribe",
  "Tribes",
  "Unaccompanied Alien Children",
  "Underrepresented Communities",
  "Underrepresented Minorities",
  "Underserved Communities",
  "Underserved Populations",
  "Vulnerable Populations",
  "White American",
  "White Americans",
  "White Institutions",
  "White People",
  "White Person",
  "White Privilege",
  "White Students",
  "White Supremacist",
  "White Supremacy",
  "Woke",
  "Wokeism",
  "Women Of Color",
  "Xenophobia",
  "Xenophobic"
)

# Federal agencies
agencies <- c(
  "Department of Agriculture",
  "Department of Commerce",
  "Department of Defense",
  "Department of Education",
  "Department of Energy",
  "Department of Health and Human Services",
  "Department of Homeland Security",
  "Department of Housing and Urban Development",
  "Department of Interior",
  "Department of Justice",
  "Department of Labor",
  "Department of State",
  "Department of the Treasury",
  "Department of Transportation",
  "Department of Veterans Affairs",
  "United States Postal Service",
  "Federal Energy Regulatory Commission",
  "Executive Office of the President",
  "Environmental Protection Agency",
  "Office of National Drug Control Policy",
  "Office of Personnel Management",
  "Federal Trade Commission"
)

term_block <- paste0(
  "(",
  paste0('"', racial_terms, '"', collapse = " OR "),
  ")"
)

cat(term_block)

proquest_searches <- paste0(
  term_block,
  ' AND ("',
  agencies,
  '")'
)


search <- data.frame(
  agency = agencies,
  query = proquest_searches,
  stringsAsFactors = FALSE
)

write.csv(search, "proquest_searches.csv", row.names = FALSE)




