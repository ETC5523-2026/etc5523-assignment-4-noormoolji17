#' Board games with ratings player counts and playing times

#' A cleaned table of board games listed on BoardGameGeek combining each
#' games community rating with the details a game-night host requires: the 
#' number of people that can play how long it takes and the suggested minimum 
#' age.
#'
#' @format A data frame with 20309 rows and 12 columns:
#' \describe{
#'   \item{id}{BoardGameGeek game identifier}
#'   \item{name}{Game name}
#'   \item{year}{Year published. `NA` for traditional and ancient games
#'     whose year was recorded as 0 or as a BC date}
#'   \item{min_players}{Minimum number of players}
#'   \item{max_players}{Maximum number of players}
#'   \item{playing_time}{Typical playing time in minutes}
#'   \item{min_age}{Publishers suggested minimum age in years. `NA` if
#'     not recorded}
#'   \item{rating}{Bayes average rating (1 to 10). This pulls games with
#'     few ratings towards the site average so it is more reliable for
#'     ranking than the raw average}
#'   \item{average_rating}{Raw mean user rating (1 to 10)}
#'   \item{users_rated}{Number of BoardGameGeek users who rated the game}
#'   \item{cooperative}{`TRUE` if players work together against the game
#''     rather than against each other}
#'   \item{url}{Link to the games BoardGameGeek page}
#' }
#'
#' @details Ratings come from BoardGameGeek users who tend to be
#'   gaming enthusiasts and may favour longer more complex games than casual
#'   players would. The data is a snapshot from January 2022. Games were
#'   removed if their player count or playing time was missing if they
#'   allowed more than 20 players (often a code for "unlimited") or if
#'   they took longer than 600 minutes. See `data-raw/games.R` for every
#'   cleaning step performed.
#'
#' @source BoardGameGeek <https://boardgamegeek.com> via the Kaggle
#'   BoardGameGeek Reviews dataset by Jesse van Elteren
#'   <https://www.kaggle.com/datasets/jvanelteren/boardgamegeek-reviews>
#'   as prepared for TidyTuesday on 25 January 2022
#'   <https://github.com/rfordatascience/tidytuesday/tree/main/data/2022/2022-01-25>.
"games"