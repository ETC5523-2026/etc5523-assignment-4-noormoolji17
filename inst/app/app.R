# Game Night Picker 
# A Shiny app for someone hosting a game night. It uses the `games` data and
# the `find_games()` function from the gamenight package.

library(shiny)
library(bslib)
library(ggplot2)

# Colours used in both the theme and the plot
col_fits  <- "#b5452c"  #  red: games that fit your time
col_later <- "#c9bfb2"  #  grey: games that need more time
col_text  <- "#2b2118"

# User interface

ui <- page_sidebar(
  title = "Game Night Picker",
  fillable = FALSE,
  theme = bs_theme(
    version = 5,
    bg = "#fbf8f3",
    fg = col_text,
    primary = col_fits,
    base_font = c("Avenir Next", "Arial", "sans-serif"),
    heading_font = c("Georgia", "serif")
  ),
  tags$head(tags$style(HTML("
    .intro { font-size: 1.05rem; line-height: 1.5; }
    .intro strong { color: #b5452c; }
    .help-text { font-size: 0.85rem; color: #6b5d50; margin-top: -0.5rem; }
    .summary-box { font-size: 1.05rem; line-height: 1.6; }
    .table td, .table th { vertical-align: middle; }
    .table a { color: #b5452c; font-weight: 600; text-decoration: none; }
  "))),
  
  # Inputs, each followed by a short explanation of what it does
  sidebar = sidebar(
    width = 300,
    h5("Your group"),
    numericInput("players", "How many people are playing?",
                 value = 4, min = 1, max = 20, step = 1),
    p(class = "help-text", "Only games that can be played with this many people are shown."),
    
    sliderInput("max_minutes", "How much time do you have? (minutes)",
                min = 10, max = 240, value = 60, step = 5, ticks = FALSE),
    p(class = "help-text",
      "Games whose typical playing time is longer than this are left out.",
      "Drag it to see what more time would unlock."),
    
    numericInput("youngest", "Age of the youngest player",
                 value = 18, min = 3, max = 99, step = 1),
    p(class = "help-text",
      "Uses the publisher's suggested minimum age. Leave at 18 or more if",
      "everyone is an adult."),
    
    h5("How much to trust ratings"),
    radioButtons("min_ratings", "Only include games rated by at least",
                 choices = c("30 people (every game)" = 30,
                             "100 people" = 100,
                             "1,000 people (recommended)" = 1000,
                             "10,000 people (classics only)" = 10000),
                 selected = 1000),
    p(class = "help-text",
      "A rating from a handful of people is less reliable. Raising this",
      "shows fewer, but better-known, games."),
    
    checkboxInput("coop", "Only cooperative games", value = FALSE),
    p(class = "help-text", "Cooperative games have everyone working as a team."),
    
    hr(),
    p(class = "help-text",
      "Data: BoardGameGeek ratings via Kaggle and TidyTuesday",
      "(January 2022 snapshot).")
  ),
  
  # The intended user and question
  card(
    card_body(
      class = "intro",
      p(strong("For:"), "anyone hosting a game night."),
      p(strong("Question:"), "for my group's size and ages, how much time do we",
        "need to allow to play a really well-rated game?")
    )
  ),
  
  # Written summary that answers the question for the current inputs
  card(
    card_header("What fits your group"),
    card_body(class = "summary-box", uiOutput("summary"))
  ),
  
  # The plot shows the time-vs-rating trade-off
  card(
    full_screen = TRUE,
    card_header(textOutput("plot_title")),
    plotOutput("tradeoff_plot", height = "380px"),
    card_footer(
      class = "help-text",
      "Each point is a game your group could play.",
      span(style = paste0("color:", col_fits, "; font-weight:600;"), "Solid red dots"),
      "fit in your time; hollow grey circles need more time. The dashed line",
      "is your time limit. Higher is better rated, so look for red dots near",
      "the top. If the best grey circles sit just right of the line, a little more time",
      "would get you a noticeably better game. The time axis is stretched at",
      "the short end so quick games are easier to tell apart."
    )
  ),
  
  # The table lists the best matches
  card(
    card_header("Top 10 games that fit"),
    tableOutput("top_table"),
    card_footer(
      class = "help-text",
      "Ranked by rating out of 10. This is BoardGameGeek's adjusted rating,",
      "which pulls games with few ratings towards the average so they can't",
      "top the list on a handful of votes. Click a name to see the game on",
      "BoardGameGeek."
    )
  )
)

# Server 
server <- function(input, output, session) {
  
  # Adults can play any game, so only filter by age when a child is playing.
  # This also keeps games that have no recorded minimum age.
  youngest_age <- reactive({
    if (is.na(input$youngest) || input$youngest >= 18) NULL else input$youngest
  })
  
  # Check the player count before using it, so a blank or invalid entry shows
  # a message instead of an error
  players <- reactive({
    validate(need(
      !is.na(input$players) && input$players >= 1 && input$players <= 20,
      "Enter how many people are playing (a number from 1 to 20)."
    ))
    input$players
  })
  
  # Every game that suits the group, ignoring the time limit (600 minutes is
  # the longest game kept in the data). Used to display what more time unlocks.
  any_time <- reactive({
    gamenight::find_games(
      players = players(),
      max_minutes = 600,
      youngest_age = youngest_age(),
      min_ratings = as.numeric(input$min_ratings),
      cooperative_only = input$coop
    )
  })
  
  # Games that suit the group AND fit in the time available
  matches <- reactive({
    gamenight::find_games(
      players = players(),
      max_minutes = input$max_minutes,
      youngest_age = youngest_age(),
      min_ratings = as.numeric(input$min_ratings),
      cooperative_only = input$coop
    )
  })
  
  output$summary <- renderUI({
    fits <- matches()
    all <- any_time()
    
    # Scenatio 1: nothing suits this group at all, whatever the time
    if (nrow(all) == 0) {
      return(div(
        class = "alert alert-warning",
        strong("No games suit this group, even with unlimited time."),
        "Try allowing games with fewer ratings, turning off 'cooperative only',",
        "or checking the number of players."
      ))
    }
    
    # Scenario 2: games suit the group, but none fit in the time
    if (nrow(fits) == 0) {
      shortest <- all[which.min(all$playing_time), ]
      return(div(
        class = "alert alert-warning",
        strong(paste0("No games fit in ", input$max_minutes, " minutes.")),
        paste0("The quickest game that suits your group is ", shortest$name,
               ", which takes about ", shortest$playing_time, " minutes. ",
               "Try moving the time slider to at least that.")
      ))
    }
    
    best <- fits[1, ]
    
    # What would an extra 30 minutes unlock?
    extra <- all[all$playing_time > input$max_minutes &
                   all$playing_time <= input$max_minutes + 30, ]
    extra_text <- if (nrow(extra) == 0) {
      "Allowing another 30 minutes wouldn't add any games."
    } else if (round(extra$rating[1], 1) > round(best$rating, 1)) {
      # Compare at one decimal place, the precision shown to the user, so
      # tiny differences don't count as "better"
      paste0("Allowing another 30 minutes would add ", nrow(extra),
             " games, including ", extra$name[1], " (rated ",
             format(round(extra$rating[1], 1), nsmall = 1),
             "), which is better rated than your current best pick.")
    } else {
      paste0("Allowing another 30 minutes would add ", nrow(extra),
             " games, but none noticeably better rated than ", best$name,
             ", so you don't need more time.")
    }
    
    tagList(
      p(strong(format(nrow(fits), big.mark = ",")), "games fit your group in", input$max_minutes,
        "minutes. The best rated is", strong(best$name),
        paste0("(", format(round(best$rating, 1), nsmall = 1), " out of 10, ",
               best$playing_time, " minutes).")),
      p(extra_text),
      # A softer warning when there are only a few options
      if (nrow(fits) < 5) {
        p(class = "text-warning",
          "Only a few games fit, so treat these as a starting point rather than",
          "a ranking.")
      }
    )
  })
  
  # The plot title updates with the group size, so the reader knows what
  # they are looking at
  output$plot_title <- renderText({
    paste0("Rating against playing time for ", players(), " players")
  })
  
  output$tradeoff_plot <- renderPlot({
    all <- any_time()
    validate(need(nrow(all) > 0, "No games suit this group. Try changing the settings on the left."))
    
    all$fits <- ifelse(all$playing_time <= input$max_minutes,
                       "Fits your time", "Needs more time")
    
    # Nudge each game slightly left or right so games with the same playing
    # time don't hide each other. A fixed seed keeps the dots in the same
    # place every time the plot redraws.
    set.seed(1)
    all$time_jitter <- all$playing_time * 10^runif(nrow(all), -0.03, 0.03)
    
    # Colour AND shape show whether a game fits, so the plot does not rely on
    # colour alone
    ggplot(all, aes(x = time_jitter, y = rating, colour = fits, shape = fits)) +
      # Context first: games that need more time, drawn underneath
      geom_point(data = all[all$fits == "Needs more time", ],
                 alpha = 0.7, size = 2.2) +
      # Emphasis second: games that fit, drawn on top so they're never hidden
      geom_point(data = all[all$fits == "Fits your time", ],
                 alpha = 0.7, size = 2.2) +
      geom_vline(xintercept = input$max_minutes, linetype = "dashed",
                 colour = col_text) +
      scale_x_log10(breaks = c(10, 15, 30, 60, 120, 240, 480)) +
      scale_colour_manual(values = c("Fits your time" = col_fits,
                                     "Needs more time" = col_later)) +
      scale_shape_manual(values = c("Fits your time" = 16,    # solid dot
                                    "Needs more time" = 1)) + # hollow circle
      labs(x = "Typical playing time (minutes)",
           y = "Rating (out of 10)", colour = NULL, shape = NULL) +
      theme_minimal(base_size = 14) +
      theme(legend.position = "top",
            panel.grid.minor = element_blank(),
            plot.background = element_rect(fill = "#fbf8f3", colour = NA))
  })
  
  output$top_table <- renderTable({
    fits <- matches()
    validate(need(nrow(fits) > 0, "No games to list. See the message above for what to try."))
    
    top <- head(fits, 10)
    data.frame(
      Game = paste0('<a href="', top$url, '" target="_blank">', top$name, "</a>"),
      Players = ifelse(top$min_players == top$max_players, top$min_players,
                       paste0(top$min_players, "-", top$max_players)),
      Minutes = top$playing_time,
      Age = ifelse(is.na(top$min_age), "Not given", paste0(top$min_age, "+")),
      Rating = format(round(top$rating, 1), nsmall = 1),
      `Rated by` = format(top$users_rated, big.mark = ","),
      check.names = FALSE
    )
  }, sanitize.text.function = identity, striped = TRUE, hover = TRUE, width = "100%")
}

shinyApp(ui, server)