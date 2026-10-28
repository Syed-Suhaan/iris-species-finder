# Iris Species Finder

A small Shiny app that names an iris flower (setosa, versicolor or virginica) from four measurements, plus a 5-slide Slidify pitch for it. Built for the Developing Data Products course project.

The app uses k-nearest neighbours, written in base R, on R's built-in `iris` data. The user moves four sliders and sees the predicted species, a vote table, a plot with the closest flowers circled, and a leave-one-out accuracy figure. A Documentation tab inside the app explains every control.

Pitch deck: <https://syed-suhaan.github.io/iris-species-finder/>

## Layout

| Path | What it is |
| --- | --- |
| `irisfinder/ui.R` | Widgets, layout and the in-app Documentation tab |
| `irisfinder/server.R` | The k-nearest-neighbours calculation and all outputs |
| `presentation/index.Rmd` | Source of the 5-slide Slidify deck |
| `presentation/build.R` | Renders the deck with current `slidify` and `markdown` versions |
| `presentation/custom.css` | Style tweaks for the deck |

## Run the app locally

```r
install.packages("shiny")
shiny::runApp("irisfinder")
```

## Deploy the app to shinyapps.io

1. Sign up at <https://www.shinyapps.io> and pick an account name.
2. In the dashboard open **Account > Tokens**, click **Show**, then **Copy to clipboard**. Paste that `rsconnect::setAccountInfo(...)` command into the R console once.
3. Deploy:

   ```r
   install.packages("rsconnect")
   rsconnect::deployApp("irisfinder")
   ```

4. The app lives at `https://<account>.shinyapps.io/irisfinder/`.

## Rebuild the deck

The deck is served from the `gh-pages` branch. To rebuild it:

```r
install.packages("remotes")
remotes::install_github(c("ramnathv/slidifyLibraries", "ramnathv/slidify"))
```

Copy `presentation/` to a scratch folder, run `Rscript build.R` there, and put `index.html`, `libraries/` and `assets/` on the `gh-pages` branch next to an empty `.nojekyll` file. `slidify` 0.5 predates `markdown` 1.0, so `build.R` swaps two of its internals and replaces its http jQuery link with a bundled copy.
