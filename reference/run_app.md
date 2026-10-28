# Launch the Game Night Picker app

Opens an interactive app for someone hosting a game night. Choose how
many people are playing the game, how much time you have and the age of
the youngest player, and the app shows which well-rated games fit, and
how many better games you could unlock by allowing more time.

## Usage

``` r
run_app(...)
```

## Arguments

- ...:

  Other arguments passed to
  [`shiny::runApp()`](https://rdrr.io/pkg/shiny/man/runApp.html), such
  as `launch.browser = TRUE` to open the app in your web browser.

## Value

No return value. Called to launch the app.

## Details

The app uses the
[games](https://etc5523-2026.github.io/etc5523-assignment-4-noormoolji17/reference/games.md)
data included in this package and finds matches with
[`find_games()`](https://etc5523-2026.github.io/etc5523-assignment-4-noormoolji17/reference/find_games.md),
so it works without an internet connection.

## Examples

``` r
if (interactive()) {
  run_app()
}
```
