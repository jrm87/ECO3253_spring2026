# PR Report: Environment Setup and Documentation Update

## Summary
This PR adds instructions for setting up a reproducible Conda environment for the course and updates the deployment documentation. It also includes the `environment.yml` file necessary to create the environment.

## Changes
- **`environment.yml`**: Created a Conda environment file containing all necessary R packages (`tidyverse`, `bookdown`, `knitr`, `rmarkdown`, `skimr`, `caret`, `rpart`, `rpart.plot`, `randomForest`, `mvtnorm`, `kableExtra`, `patchwork`, `rockchalk`, `pacman`, `broom`, `ggthemes`, `ggforce`, `viridis`, `gridExtra`, `here`, `magrittr`, `gapminder`) and `pandoc`.
- **`DEPLOYMENT.md`**: Added a section on "Environment Setup" with instructions on how to create and activate the Conda environment.
- **`README.md`**: Added a "Quick Start" section pointing to the Conda setup.
- **`07-k12.Rmd`**: Fixed unbalanced code fences (syntax error).
- **`03-wrangling.Rmd`**: Fixed unbalanced code fences (syntax error).

## Verification
- **Environment Creation**: Successfully created the `eco3253` environment using `conda env create -f environment.yml`.
- **Build Verification**: Successfully built the book using `bookdown::render_book("index.Rmd")` within the `eco3253` environment.
  - **Output**: `docs/index.html` was generated.
  - **Note**: Some warnings regarding missing citations and labels were observed, but they did not prevent the build.

## Instructions for Reviewers
1. Clone the repository.
2. Run `conda env create -f environment.yml`.
3. Activate the environment: `conda activate eco3253`.
4. Run `Rscript -e 'bookdown::render_book("index.Rmd")'` to verify the build locally.
