# Set CRAN mirror
options(repos = c(CRAN = "https://cloud.r-project.org"))

# List of required packages
packages <- c("WDI", "tidyverse", "car", "MASS", "broom", "knitr",
              "kableExtra", "rmarkdown")

# Install missing packages
for (pkg in packages) {
  if (!require(pkg, character.only = TRUE, quietly = TRUE)) {
    cat("Installing", pkg, "...\n")
    install.packages(pkg, dependencies = TRUE)
  } else {
    cat(pkg, "is already installed.\n")
  }
}

cat("\nAll packages installed successfully!\n")
