## Prepare the `games` dataset -
## Source: BoardGameGeek, via Kaggle (jvanelteren), via TidyTuesday 2022-01-25.
## Run this whole script to rebuild data/games.rda from scratch.

library(dplyr)
library(readr)
library(stringr)

base_url <- paste0(
  "https://raw.githubusercontent.com/rfordatascience/tidytuesday/",
  "main/data/2022/2022-01-25/"
)

ratings_raw <- read_csv(paste0(base_url, "ratings.csv"), show_col_types = FALSE)
details_raw <- read_csv(paste0(base_url, "details.csv"), show_col_types = FALSE)

games <- ratings_raw |>
  # Keep only games that have both ratings and details (drops ~200 games)
  inner_join(details_raw, by = "id") |>
  transmute(
    id,
    name,
    # Ancient games store BC dates as positive years
    # and traditional games use 0, so treat anything outside 1-2022 as unknown
    year = if_else(year > 0 & year <= 2022, year, NA_real_),
    # BGG uses 0 to mean "not recorded", not a real value
    min_players  = na_if(minplayers, 0),
    max_players  = na_if(maxplayers, 0),
    playing_time = na_if(playingtime, 0),
    min_age      = na_if(minage, 0),
    # Bayes average pulls games with few ratings towards the site average,
    # so a game rated 9 by 40 people doesn't outrank one rated 8 by 40,000
    rating         = bayes_average,
    average_rating = average,
    users_rated,
    cooperative = coalesce(str_detect(boardgamemechanic, "Cooperative Game"), FALSE),
    url = paste0("https://boardgamegeek.com", url)
  ) |>
  # Player counts and playing time are essential for the app's question,
  # so drop games where they are missing or implausible:
  # - removes placeholder entries like "Unpublished Prototype"
  # - removes "unlimited" games coded as 999 players
  # - removes multi-week wargames (e.g. 60,000 minutes)
  filter(
    !is.na(min_players), !is.na(max_players),
    max_players >= min_players,
    max_players <= 20,
    !is.na(playing_time),
    playing_time <= 600,
    rating > 0
  ) |>
  mutate(across(
    c(id, year, min_players, max_players, playing_time, min_age, users_rated),
    as.integer
  )) |>
  arrange(desc(rating))

usethis::use_data(games, overwrite = TRUE)