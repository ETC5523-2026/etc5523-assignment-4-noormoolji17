#' Launch the Game Night Picker app
#'
#' Opens an interactive app for someone hosting a game night. Choose how many
#' people are playing the game, how much time you have and the age of the 
#' youngest player, and the app shows which well-rated games fit, and how many better
#' games you could unlock by allowing more time.
#'
#' The app uses the [games] data included in this package and finds matches
#' with [find_games()], so it works without an internet connection.
#'
#' @param ... Other arguments passed to [shiny::runApp()], such as
#'   `launch.browser = TRUE` to open the app in your web browser.
#'
#' @return No return value. Called to launch the app.
#'
#' @examples
#' if (interactive()) {
#'   run_app()
#' }
#'
#' @importFrom bslib bs_theme
#' @importFrom ggplot2 ggplot
#' @export
run_app <- function(...) {
  # The app lives in inst/app, which becomes app/ once the package is installed
  app_dir <- system.file("app", package = "gamenight")
  if (app_dir == "") {
    stop("Could not find the app. Try re-installing `gamenight`.", call. = FALSE)
  }
  shiny::runApp(app_dir, display.mode = "normal", ...)
}