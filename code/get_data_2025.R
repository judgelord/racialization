

file <- here::here("data", "p2025_Affirmative action, etc..rda")

file.exists(file |> str_replace("racialization", "2025"))

file.copy(from = file |> str_replace("racialization", "2025"),
          to = file,
          overwrite = T)

