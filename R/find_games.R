#' Discover well-rated board games that suit your group
#'
#' Keeps the games that your group can play; games that allow your number of
#' players, fit in the time you have, and (optionally) suit your youngest
#' player. The matches are ranked from highest to lowest rating, so the top
#' rows are the best options for your game night.
#'
#' @param players Number of people playing.
#' @param max_minutes The most time you have, in minutes. Games with a
#'   typical playing time longer than this are excluded.
#' @param youngest_age Age of the youngest player, in years. Games whose
#'   suggested minimum age is higher are excluded, as are games with no
#'   recorded age. Use `NULL` (the default) to ignore age.
#' @param min_ratings Minimum number of BoardGameGeek ratings a game needs.
#'   Ratings based on only a few people are less trustworthy, so raising this
#'   leaves fewer but more reliably rated games.
#' @param cooperative_only If `TRUE`, only keep games where players work
#'   together rather than compete.
#' @param data A data frame with the same columns as [games]. Defaults to
#'   the data included in this package.
#'
#' @return A data frame with one row per matching game, highest `rating`
#'   first. It has zero rows if no games match.
#'
#' @examples
#' # The best games for four players with an hour to spare
#' find_games(players = 4, max_minutes = 60)
#'
#' # Two players, half an hour, and an eight-year-old joining in
#' find_games(players = 2, max_minutes = 30, youngest_age = 8)
#'
#' # Large groups with little time leave very few options
#' find_games(players = 8, max_minutes = 30, youngest_age = 6)
#'
#' @importFrom dplyr filter arrange desc .data
#' @export
find_games <- function(players,
                       max_minutes,
                       youngest_age = NULL,
                       min_ratings = 1000,
                       cooperative_only = FALSE,
                       data = gamenight::games) {
  # Check inputs early so users get a clear message, not a  error
  if (!is.numeric(players) || length(players) != 1 || players < 1) {
    stop("`players` must be a single number of at least 1.", call. = FALSE)
  }
  if (!is.numeric(max_minutes) || length(max_minutes) != 1 || max_minutes <= 0) {
    stop("`max_minutes` must be a single positive number.", call. = FALSE)
  }
  
  result <- data |>
    filter(
      .data$min_players <= players,
      .data$max_players >= players,
      .data$playing_time <= max_minutes,
      .data$users_rated >= min_ratings
    )
  
  if (!is.null(youngest_age)) {
    # A game with no recorded age can't be confirmed as suitable, so drop it
    result <- filter(result, !is.na(.data$min_age), .data$min_age <= youngest_age)
  }
  
  if (cooperative_only) {
    result <- filter(result, .data$cooperative)
  }
  
  arrange(result, desc(.data$rating))
}