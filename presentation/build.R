# Renders index.Rmd to index.html in the current directory.
# Run it from a copy of this folder: slidify writes libraries/, assets/ and index.html next to the source.
#
# Needs: install.packages("remotes"); remotes::install_github(c("ramnathv/slidifyLibraries", "ramnathv/slidify"))

# slidify 0.5 calls markdownExtensions(), which markdown >= 1.0 removed.
if (!exists("markdownExtensions", envir = asNamespace("markdown"))) {
  slidify_ns <- asNamespace("slidify")
  unlockBinding("md2html", slidify_ns)
  assign("md2html", function(md) markdown::mark(md, format = "html"), envir = slidify_ns)
}

slidify::slidify("index.Rmd")

# The io2012 template loads jQuery and its Google Fonts over http, which https pages block, and
# ships a dead Chrome Frame snippet. Serve jQuery from libraries/ and fetch the fonts over https.
slidify_css <- "libraries/frameworks/io2012/css/slidify.css"
writeLines(
  sub("http://fonts.googleapis.com", "https://fonts.googleapis.com", readLines(slidify_css, warn = FALSE), fixed = TRUE),
  slidify_css, useBytes = TRUE
)
file.copy(
  system.file("libraries/widgets/quiz/js/jquery.js", package = "slidifyLibraries"),
  "libraries/jquery.js", overwrite = TRUE
)
html <- paste(readLines("index.html", encoding = "UTF-8", warn = FALSE), collapse = "\n")
html <- sub("[^\n]*window\\.jQuery \\|\\|[^\n]*\n", "", html)
html <- sub("http://ajax.aspnetcdn.com/ajax/jQuery/jquery-1.7.min.js", "libraries/jquery.js", html, fixed = TRUE)
html <- gsub("(?s)<!--\\[if IE\\]>.*?<!\\[endif\\]-->", "", html, perl = TRUE)
html <- gsub(" title='NA'", "", html, fixed = TRUE)
css <- paste(readLines("custom.css", warn = FALSE), collapse = "\n")
html <- sub("</head>", paste0("<style>\n", css, "\n</style>\n</head>"), html, fixed = TRUE)
writeLines(html, "index.html", useBytes = TRUE)
