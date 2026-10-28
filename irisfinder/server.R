library(shiny)

features <- c("Sepal.Length", "Sepal.Width", "Petal.Length", "Petal.Width")
species <- levels(iris$Species)
species_colours <- c(setosa = "#E69F00", versicolor = "#009E73", virginica = "#0072B2")
axis_labels <- c(
  Sepal.Length = "Sepal length (cm)", Sepal.Width = "Sepal width (cm)",
  Petal.Length = "Petal length (cm)", Petal.Width = "Petal width (cm)"
)

# Training measurements, optionally centred and divided by their standard deviation
# so that no single measurement dominates the distance.
training_space <- function(standardise) {
  x <- as.matrix(iris[, features])
  centre <- if (standardise) colMeans(x) else rep(0, ncol(x))
  spread <- if (standardise) apply(x, 2, sd) else rep(1, ncol(x))
  list(x = scale(x, centre, spread), centre = centre, spread = spread)
}

# Majority vote among the k closest training flowers; the nearest of the tied species wins ties.
vote <- function(d, k) {
  nearest <- order(d)[seq_len(k)]
  nearest_species <- as.character(iris$Species[nearest])
  votes <- table(factor(nearest_species, levels = species))
  tied <- names(votes)[votes == max(votes)]
  list(
    neighbours = nearest,
    votes = votes,
    winner = nearest_species[nearest_species %in% tied][1]
  )
}

shinyServer(function(input, output, session) {

  for (s in species) {
    local({
      sp <- s
      observeEvent(input[[paste0("example_", sp)]], {
        m <- round(colMeans(iris[iris$Species == sp, features]), 1)
        updateSliderInput(session, "sepal_length", value = m[["Sepal.Length"]])
        updateSliderInput(session, "sepal_width", value = m[["Sepal.Width"]])
        updateSliderInput(session, "petal_length", value = m[["Petal.Length"]])
        updateSliderInput(session, "petal_width", value = m[["Petal.Width"]])
      })
    })
  }

  space <- reactive(training_space(input$standardise))

  flower <- reactive(c(
    input$sepal_length, input$sepal_width, input$petal_length, input$petal_width
  ))

  result <- reactive({
    sp <- space()
    new_point <- (flower() - sp$centre) / sp$spread
    d <- sqrt(rowSums(sweep(sp$x, 2, new_point)^2))
    vote(d, input$k)
  })

  distances <- reactive({
    d <- as.matrix(dist(space()$x))
    diag(d) <- Inf
    d
  })

  accuracy <- reactive({
    d <- distances()
    correct <- vapply(
      seq_len(nrow(d)),
      function(i) vote(d[i, ], input$k)$winner == as.character(iris$Species[i]),
      logical(1)
    )
    mean(correct)
  })

  output$species <- renderText(result()$winner)

  output$confidence <- renderText({
    r <- result()
    n <- r$votes[[r$winner]]
    sprintf(
      "%d of the %d closest flowers in the data set are %s (%.0f%% of the vote).",
      n, input$k, r$winner, 100 * n / input$k
    )
  })

  output$votes <- renderTable({
    n <- as.integer(result()$votes)
    data.frame(
      Species = species,
      Neighbours = n,
      Share = sprintf("%.0f%%", 100 * n / input$k)
    )
  })

  output$accuracy <- renderText(sprintf(
    "Accuracy check: with k = %d and these settings, the same method labels %.1f%% of the 150 known flowers correctly when each one is hidden in turn.",
    input$k, 100 * accuracy()
  ))

  output$plot <- renderPlot({
    req(session$clientData$output_plot_width > 0)
    cols <- if (input$view == "petal") c("Petal.Length", "Petal.Width") else c("Sepal.Length", "Sepal.Width")
    new_xy <- flower()[match(cols, features)]
    x <- iris[[cols[1]]]
    y <- iris[[cols[2]]]

    plot(
      x, y,
      col = adjustcolor(species_colours[as.character(iris$Species)], 0.75), pch = 19, cex = 1.3,
      xlim = range(x, new_xy[1]), ylim = range(y, new_xy[2]),
      xlab = axis_labels[[cols[1]]], ylab = axis_labels[[cols[2]]], las = 1
    )
    if (input$show_neighbours) {
      nn <- result()$neighbours
      points(x[nn], y[nn], cex = 2.4, lwd = 2)
    }
    points(new_xy[1], new_xy[2], pch = 23, bg = "red", col = "black", cex = 2.6, lwd = 2)
    legend(
      "topleft", bty = "n",
      legend = c(species, "your flower"),
      pch = c(19, 19, 19, 23), col = c(species_colours, "black"), pt.bg = c(NA, NA, NA, "red")
    )
  })
})
