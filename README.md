
# gamenight

<!-- badges: start -->

<!-- badges: end -->

**gamenight** helps you choose a game for your game night. Tell it how
many people are playing, how much time you have and the age of the
youngest player, and it finds well-rated games that fit, and shows how
much better your options get if you allow more time.

Documentation website:

## Installation

Install the package from GitHub:

## Launch the app

``` r
gamenight::run_app()
```

The app is for **someone hosting a game night**, and answers the
question: *for my group’s size and ages, how much time do we need to
allow to play a really well-rated game?*

## Find games from the console

`find_games()` returns the games that suit your group, best rated first:

``` r
library(gamenight)

find_games(players = 2, max_minutes = 30, youngest_age = 8) |>
  head(5)
```

    ## # A tibble: 5 × 12
    ##       id name           year min_players max_players playing_time min_age rating
    ##    <int> <chr>         <int>       <int>       <int>        <int>   <int>  <dbl>
    ## 1    521 Crokinole      1876           2           4           30       8   7.67
    ## 2 163412 Patchwork      2014           2           2           30       8   7.54
    ## 3 244522 That's Prett…  2018           1           4           30       8   7.41
    ## 4 194655 Santorini      2016           2           4           20       8   7.30
    ## 5 192291 Sushi Go Par…  2016           2           8           20       8   7.28
    ## # ℹ 4 more variables: average_rating <dbl>, users_rated <int>,
    ## #   cooperative <lgl>, url <chr>
