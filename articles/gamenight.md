# Choosing a game for game night

This guide is for anyone hosting a game night who wants to pick a game
that suits their group. It shows you how to install the package, launch
the app, use its controls and read what it tells you.

## Install and launch

Install gamenight from GitHub, then launch the app:

``` r

# install.packages("remotes")
remotes::install_github("ETC5523-2026/etc5523-assignment-4-noormoolji17")

gamenight::run_app()
```

The app opens in your viewer or browser. It uses the game data that
comes with the package, so it works without an internet connection.

## The question the app answers

> For my group’s size and ages, how much time do we need to allow to
> play a really well-rated game?

There is no single “best game”. The best game for two people with half
an hour is completely different from the best game for eight people with
an evening, so the app lets you describe *your* group.

## Using the controls

The sidebar on the left describes your group:

- **How many people are playing?** Only games that can be played with
  exactly this many people are shown.
- **How much time do you have?** Games whose typical playing time is
  longer than this are left out. This is the most important control; as
  one can drag it to see what extra time would unlock.
- **Age of the youngest player.** Uses the publisher’s suggested minimum
  age. Leave it at 18 or more if everyone is an adult.
- **Only include games rated by at least…** A rating from a handful of
  people is less reliable. The default of 1,000 people keeps well-known
  games; lower it to see more obscure ones.
- **Only cooperative games.** Tick this if your group would rather work
  as a team than compete.

## Reading the results

The app gives three outputs, from quickest to most detailed:

1.  **What fits your group.** A sentence telling you how many games fit,
    the best-rated one, and whether allowing another 30 minutes would
    get you a better game.
2.  **Rating against playing time.** Each point is a game your group
    could play. Solid red dots fit in your time; hollow grey circles
    need more time. The dashed line is your time limit. Look for points
    near the top: if the best grey circles sit just to the right of the
    line, a little more time would get you a noticeably better game.
3.  **Top 10 games that fit.** The best matches, with a link to each
    game on BoardGameGeek.

Ratings are BoardGameGeek’s *adjusted* rating out of 10. It pulls games
with few ratings towards the average, so a game rated highly by only a
handful of people can’t top the list.

## A worked example

Say six friends are coming over. With 45 minutes to spare:

``` r

library(gamenight)

short <- find_games(players = 6, max_minutes = 45)
nrow(short)
#> [1] 418
head(short[, c("name", "playing_time", "rating")], 3)
#> # A tibble: 3 × 3
#>   name               playing_time rating
#>   <chr>                     <int>  <dbl>
#> 1 7 Wonders                    30   7.63
#> 2 Dominion: Intrigue           30   7.55
#> 3 Decrypto                     45   7.52
```

If they can stay for 90 minutes instead:

``` r

long <- find_games(players = 6, max_minutes = 90)
nrow(long)
#> [1] 634
head(long[, c("name", "playing_time", "rating")], 3)
#> # A tibble: 3 × 3
#>   name                          playing_time rating
#>   <chr>                                <int>  <dbl>
#> 1 Viticulture Essential Edition           90   7.90
#> 2 7 Wonders                               30   7.63
#> 3 Dominion: Intrigue                      30   7.55
```

Doubling the time adds 216 games, and the best option improves from 7
Wonders (7.6) to Viticulture Essential Edition (7.9). The app shows this
trade-off as you drag the time slider.

## When nothing fits

Some groups have very few options. For ten players including a
six-year-old, with only 15 minutes:

``` r

find_games(players = 10, max_minutes = 15, youngest_age = 6)
#> # A tibble: 0 × 12
#> # ℹ 12 variables: id <int>, name <chr>, year <int>, min_players <int>,
#> #   max_players <int>, playing_time <int>, min_age <int>, rating <dbl>,
#> #   average_rating <dbl>, users_rated <int>, cooperative <lgl>, url <chr>
```

No games fit. Instead of an empty screen, the app shows a yellow message
naming the quickest game that suits the group and how much time it
needs, so you know what to change. If the number of players is left
blank or is outside 1 to 20, the app asks you to enter a valid number.

## Things to keep in mind

- Ratings come from BoardGameGeek users, who are enthusiasts and tend to
  rate longer, more complex games highly. A casual group might enjoy
  shorter games more than the ratings suggest.
- The data is a snapshot from January 2022, so newer games are missing.
- “Board games” here means any tabletop game on BoardGameGeek, including
  card, dice and party games.
- Playing times and minimum ages are the publisher’s suggestions. Your
  group may be faster or slower.

The data comes from [BoardGameGeek](https://boardgamegeek.com), via
Kaggle and
[TidyTuesday](https://github.com/rfordatascience/tidytuesday/tree/main/data/2022/2022-01-25).
See
[`?games`](https://etc5523-2026.github.io/etc5523-assignment-4-noormoolji17/reference/games.md)
for details.
