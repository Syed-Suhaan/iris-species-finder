library(shiny)

measure_slider <- function(id, label, column) {
  r <- range(iris[[column]])
  sliderInput(
    id, label,
    min = floor(r[1]), max = ceiling(r[2]),
    value = round(median(iris[[column]]), 1), step = 0.1
  )
}

shinyUI(fluidPage(
  titlePanel("Iris Species Finder"),
  p("Type in the size of an iris flower and the app tells you which of three species it most likely is.",
    "New here? Open the ", strong("Documentation"), " tab."),

  sidebarLayout(
    sidebarPanel(
      h4("1. Describe your flower"),
      helpText("Drag the sliders, or start from a typical flower of one species:"),
      actionButton("example_setosa", "Setosa"),
      actionButton("example_versicolor", "Versicolor"),
      actionButton("example_virginica", "Virginica"),
      br(), br(),
      measure_slider("sepal_length", "Sepal length (cm)", "Sepal.Length"),
      measure_slider("sepal_width", "Sepal width (cm)", "Sepal.Width"),
      measure_slider("petal_length", "Petal length (cm)", "Petal.Length"),
      measure_slider("petal_width", "Petal width (cm)", "Petal.Width"),
      hr(),
      h4("2. Tune the method (optional)"),
      sliderInput("k", "Neighbours to ask (k)", min = 1, max = 25, value = 7, step = 1),
      checkboxInput("standardise", "Put all measurements on the same scale", value = TRUE),
      radioButtons(
        "view", "Plot shows",
        choices = c("Petal length vs width" = "petal", "Sepal length vs width" = "sepal")
      ),
      checkboxInput("show_neighbours", "Circle the k closest flowers on the plot", value = TRUE)
    ),

    mainPanel(
      tabsetPanel(
        tabPanel(
          "Prediction",
          wellPanel(
            h4("Most likely species"),
            h2(textOutput("species")),
            textOutput("confidence")
          ),
          plotOutput("plot", height = "380px"),
          h4("How the neighbours voted"),
          tableOutput("votes"),
          p(em(textOutput("accuracy")))
        ),

        tabPanel(
          "Documentation",
          h3("What this app does"),
          p("The app guesses the species of an iris flower from four measurements. It compares your flower",
            "with 150 flowers whose species is known (the built-in", code("iris"), "data set from R)."),

          h3("Quick start"),
          tags$ol(
            tags$li("Stay on the ", strong("Prediction"), " tab."),
            tags$li("Click ", strong("Setosa"), ", ", strong("Versicolor"), " or ", strong("Virginica"),
                    " to load a typical flower, or move the four sliders yourself."),
            tags$li("Read the species under ", strong("Most likely species"), ". It updates as you move a slider."),
            tags$li("Look at the plot. The red diamond is your flower. The coloured dots are the 150 known flowers.")
          ),

          h3("What each control does"),
          tags$ul(
            tags$li(strong("Sepal and petal sliders. "),
                    "The length and width of the flower's two leaf types, in centimetres. ",
                    "Petals are the inner coloured leaves, sepals the outer ones."),
            tags$li(strong("Neighbours to ask (k). "),
                    "How many of the closest known flowers get a vote. Small values react to every ",
                    "detail. Large values give smoother, steadier answers. 5 to 10 works well."),
            tags$li(strong("Put all measurements on the same scale. "),
                    "When ticked, each measurement is rescaled so that wide-ranging ones such as petal length ",
                    "do not drown out narrow ones such as sepal width. Untick it to compare raw centimetres."),
            tags$li(strong("Plot shows. "), "Switches the plot between petal and sepal measurements."),
            tags$li(strong("Circle the k closest flowers. "),
                    "Rings the flowers that voted. They are closest using all four measurements, so on a ",
                    "two-measurement plot a few may look further away than they are.")
          ),

          h3("How to read the results"),
          tags$ul(
            tags$li(strong("Most likely species. "), "The species with the most votes. If two species tie, the one ",
                    "owning the single closest flower wins."),
            tags$li(strong("Vote table. "), "How many of the k closest flowers belong to each species. ",
                    "A 7 of 7 vote is a clear call. A 4 of 7 vote means the flower sits between two species."),
            tags$li(strong("Accuracy check. "), "Each of the 150 known flowers is hidden in turn and guessed from the other 149. ",
                    "The percentage is how often that guess is right for your current k and scale setting.")
          ),

          h3("Things to try"),
          tags$ul(
            tags$li("Load a typical versicolor, then slowly raise the petal length. Watch the answer flip to virginica."),
            tags$li("Set k to 1, then to 25. See how the vote table and the accuracy check change."),
            tags$li("Untick the scale option and compare the accuracy figure.")
          ),

          h3("About the method and the data"),
          p("The method is k-nearest neighbours. It measures the distance from your flower to every known flower, ",
            "keeps the k closest, and lets them vote. The data are Edgar Anderson's iris measurements, made famous by ",
            "R. A. Fisher: 50 flowers each of ", em("Iris setosa"), ", ", em("Iris versicolor"), " and ", em("Iris virginica"), "."),
          p(em("Limits: the app only knows these three species. Any measurements you enter get one of them as an answer, even if the flower is something else entirely."))
        )
      )
    )
  )
))
