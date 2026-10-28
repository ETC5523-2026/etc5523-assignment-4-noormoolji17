# Discover well-rated board games that suit your group

Keeps the games that your group can play; games that allow your number
of players, fit in the time you have, and (optionally) suit your
youngest player. The matches are ranked from highest to lowest rating,
so the top rows are the best options for your game night.

## Usage

``` r
find_games(
  players,
  max_minutes,
  youngest_age = NULL,
  min_ratings = 1000,
  cooperative_only = FALSE,
  data = gamenight::games
)
```

## Arguments

- players:

  Number of people playing.

- max_minutes:

  The most time you have, in minutes. Games with a typical playing time
  longer than this are excluded.

- youngest_age:

  Age of the youngest player, in years. Games whose suggested minimum
  age is higher are excluded, as are games with no recorded age. Use
  `NULL` (the default) to ignore age.

- min_ratings:

  Minimum number of BoardGameGeek ratings a game needs. Ratings based on
  only a few people are less trustworthy, so raising this leaves fewer
  but more reliably rated games.

- cooperative_only:

  If `TRUE`, only keep games where players work together rather than
  compete.

- data:

  A data frame with the same columns as
  [games](https://etc5523-2026.github.io/etc5523-assignment-4-noormoolji17/reference/games.md).
  Defaults to the data included in this package.

## Value

A data frame with one row per matching game, highest `rating` first. It
has zero rows if no games match.

## Examples

``` r
# The best games for four players with an hour to spare
find_games(players = 4, max_minutes = 60)
#> # A tibble: 1,545 × 12
#>        id name          year min_players max_players playing_time min_age rating
#>     <int> <chr>        <int>       <int>       <int>        <int>   <int>  <dbl>
#>  1 161936 Pandemic Le…  2015           2           4           60      13   8.44
#>  2 221107 Pandemic Le…  2017           2           4           60      14   7.78
#>  3 284083 The Crew: T…  2019           2           5           20      10   7.78
#>  4 230802 Azul          2017           2           4           45       8   7.69
#>  5 244521 The Quacks …  2018           2           4           45      10   7.68
#>  6    521 Crokinole     1876           2           4           30       8   7.67
#>  7 191189 Aeon's End    2016           1           4           60      14   7.67
#>  8  28143 Race for th…  2007           2           4           60      12   7.65
#>  9 201808 Clank!: A D…  2016           2           4           60      12   7.65
#> 10  68448 7 Wonders     2010           2           7           30      10   7.63
#> # ℹ 1,535 more rows
#> # ℹ 4 more variables: average_rating <dbl>, users_rated <int>,
#> #   cooperative <lgl>, url <chr>

# Two players, half an hour, and an eight-year-old joining in
find_games(players = 2, max_minutes = 30, youngest_age = 8)
#> # A tibble: 409 × 12
#>        id name          year min_players max_players playing_time min_age rating
#>     <int> <chr>        <int>       <int>       <int>        <int>   <int>  <dbl>
#>  1    521 Crokinole     1876           2           4           30       8   7.67
#>  2 163412 Patchwork     2014           2           2           30       8   7.54
#>  3 244522 That's Pret…  2018           1           4           30       8   7.41
#>  4 194655 Santorini     2016           2           4           20       8   7.30
#>  5 192291 Sushi Go Pa…  2016           2           8           20       8   7.28
#>  6 204583 Kingdomino    2016           2           4           15       8   7.23
#>  7 165722 KLASK         2014           2           2           10       8   7.19
#>  8 160477 Onitama       2014           2           2           20       8   7.18
#>  9 140934 Arboretum     2015           2           4           30       8   7.15
#> 10  70323 King of Tok…  2011           2           6           30       8   7.07
#> # ℹ 399 more rows
#> # ℹ 4 more variables: average_rating <dbl>, users_rated <int>,
#> #   cooperative <lgl>, url <chr>

# Large groups with little time leave very few options
find_games(players = 8, max_minutes = 30, youngest_age = 6)
#> # A tibble: 9 × 12
#>      id name            year min_players max_players playing_time min_age rating
#>   <int> <chr>          <int>       <int>       <int>        <int>   <int>  <dbl>
#> 1   150 PitchCar        1995           2           8           30       6   7.00
#> 2 14254 PitchCar Mini   2003           2           8           30       6   6.32
#> 3  1198 SET             1988           1          20           30       6   6.30
#> 4 20545 Rory's Story …  2005           1          12           20       6   5.99
#> 5  2452 Jenga           1983           1           8           20       6   5.55
#> 6  2394 Dominoes        1500           2          10           30       5   5.44
#> 7  2243 Yahtzee         1956           2          10           30       6   5.38
#> 8  2223 UNO             1971           2          10           30       6   5.31
#> 9  3522 LCR             1983           3          12           20       5   4.38
#> # ℹ 4 more variables: average_rating <dbl>, users_rated <int>,
#> #   cooperative <lgl>, url <chr>
```
