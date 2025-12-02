#!/usr/bin/env Rscript

# Script to render the homework RMarkdown document
# This script will knit the RMD file to HTML

cat("=== Házifeladat RMarkdown rendering ===\n\n")

# Check if rmarkdown is installed
if (!require("rmarkdown", quietly = TRUE)) {
  cat("Installing rmarkdown package...\n")
  install.packages("rmarkdown", repos = "https://cloud.r-project.org/")
}

# Check if required packages are installed
required_packages <- c("readxl", "dplyr", "tidyr", "ggplot2", "scales", "patchwork")

for (pkg in required_packages) {
  if (!require(pkg, character.only = TRUE, quietly = TRUE)) {
    cat(sprintf("Installing %s package...\n", pkg))
    install.packages(pkg, repos = "https://cloud.r-project.org/")
  }
}

# Render the RMarkdown document
cat("\nRendering homework_solution.Rmd...\n")

tryCatch({
  rmarkdown::render(
    input = "homework_solution.Rmd",
    output_format = "html_document",
    output_file = "homework_solution.html"
  )
  cat("\n✓ Success! Output file: homework_solution.html\n")
  cat("You can open it in your browser.\n")
}, error = function(e) {
  cat("\n✗ Error during rendering:\n")
  cat(as.character(e), "\n")
  cat("\nYou can still open the .Rmd file in RStudio and knit it manually.\n")
})
