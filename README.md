# Iris Species Finder

A small Shiny app that names an iris flower (setosa, versicolor or virginica) from four measurements, plus a 5-slide R Presenter pitch for it. Built for the Developing Data Products course project.

The app uses k-nearest neighbours, written in base R, on R's built-in `iris` data. The user moves four sliders and sees the predicted species, a vote table, a plot with the closest flowers circled, and a leave-one-out accuracy figure. A Documentation tab inside the app explains every control.

## Layout

| Path | What it is |
| --- | --- |
| `irisfinder/ui.R` | Widgets, layout and the in-app Documentation tab |
| `irisfinder/server.R` | The k-nearest-neighbours calculation and all outputs |
| `presentation/iris-finder-pitch.Rpres` | The 5-slide RStudio Presenter deck |
| `presentation/custom.css` | Style tweaks for the deck |

## Run it locally

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

4. The app lives at `https://<account>.shinyapps.io/irisfinder/`. Open it and click through once before submitting.

## Publish the presentation

1. Open `presentation/iris-finder-pitch.Rpres` in RStudio.
2. In the first lines of the code chunk named `setup`, set `app_url` and `repo_url`. Change `author:` in the header too.
3. Click **Preview**, check all 5 slides, then click **Publish** and choose **RPubs**. Paste the RPubs link into the submission box as an `http://` link, not `https://`.

## Submission checklist

- [ ] App link (shinyapps.io)
- [ ] GitHub link with `ui.R` and `server.R`
- [ ] Presentation link (RPubs, or GitHub Pages with a `.nojekyll` file on a `gh-pages` branch)
