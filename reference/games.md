# Board games with ratings player counts and playing times A cleaned table of board games listed on BoardGameGeek combining each games community rating with the details a game-night host requires: the number of people that can play how long it takes and the suggested minimum age.

Board games with ratings player counts and playing times A cleaned table
of board games listed on BoardGameGeek combining each games community
rating with the details a game-night host requires: the number of people
that can play how long it takes and the suggested minimum age.

## Usage

``` r
games
```

## Format

A data frame with 20309 rows and 12 columns:

- id:

  BoardGameGeek game identifier

- name:

  Game name

- year:

  Year published. `NA` for traditional and ancient games whose year was
  recorded as 0 or as a BC date

- min_players:

  Minimum number of players

- max_players:

  Maximum number of players

- playing_time:

  Typical playing time in minutes

- min_age:

  Publishers suggested minimum age in years. `NA` if not recorded

- rating:

  Bayes average rating (1 to 10). This pulls games with few ratings
  towards the site average so it is more reliable for ranking than the
  raw average

- average_rating:

  Raw mean user rating (1 to 10)

- users_rated:

  Number of BoardGameGeek users who rated the game

- cooperative:

  `TRUE` if players work together against the game ' rather than against
  each other

- url:

  Link to the games BoardGameGeek page

## Source

BoardGameGeek <https://boardgamegeek.com> via the Kaggle BoardGameGeek
Reviews dataset by Jesse van Elteren
<https://www.kaggle.com/datasets/jvanelteren/boardgamegeek-reviews> as
prepared for TidyTuesday on 25 January 2022
<https://github.com/rfordatascience/tidytuesday/tree/main/data/2022/2022-01-25>.

## Details

Ratings come from BoardGameGeek users who tend to be gaming enthusiasts
and may favour longer more complex games than casual players would. The
data is a snapshot from January 2022. Games were removed if their player
count or playing time was missing if they allowed more than 20 players
(often a code for "unlimited") or if they took longer than 600 minutes.
See `data-raw/games.R` for every cleaning step performed.
