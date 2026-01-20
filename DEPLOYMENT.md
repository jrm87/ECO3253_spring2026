# Deployment Instructions

## Important: Site Needs to be Rebuilt

The `docs/` folder currently contains pre-built HTML from Fall 2024. After updating the source files (`.Rmd` files) to Spring 2026, the site needs to be rebuilt to reflect these changes.

## How to Rebuild the Site

### Prerequisites
- Conda (Miniconda or Anaconda)
- Git

### Environment Setup

1. **Create the Conda Environment**:
   ```bash
   conda env create -f environment.yml
   ```

2. **Activate the Environment**:
   ```bash
   conda activate eco3253
   ```


### Steps to Rebuild

1. **Install Required Packages** (if not already installed):
   ```r
   install.packages(c("bookdown", "tidyverse", "knitr", "rmarkdown"))
   ```

2. **Open the Project in RStudio**:
   - Open RStudio
   - File → Open Project
   - Select this repository folder

3. **Build the Book**:
   
   **Option A - Using RStudio** (Recommended):
   - Open `index.Rmd`
   - Click the "Build" tab in the upper-right pane
   - Click "Build Book" (or press Ctrl/Cmd + Shift + B)
   
   **Option B - Using R Console**:
   ```r
   bookdown::render_book("index.Rmd")
   ```

4. **Verify the Build**:
   - Check that `docs/index.html` has been updated
   - Open `docs/index.html` in a browser to preview
   - Verify that all pages show "Spring 2026" instead of "Fall 2024"

5. **Commit and Push**:
   ```bash
   git add docs/
   git commit -m "Rebuild site for Spring 2026"
   git push
   ```

## GitHub Pages Configuration

The site is configured to deploy from the `docs/` folder on the `main` branch:

1. Go to: https://github.com/jrm87/ECO3253_spring2026/settings/pages
2. Verify settings:
   - **Source**: Deploy from a branch
   - **Branch**: `main`
   - **Folder**: `/docs`

After pushing the rebuilt `docs/` folder, GitHub Pages will automatically update the site at:
https://jrm87.github.io/ECO3253_spring2026/

## Troubleshooting

### Build Errors

If you encounter errors during the build:

1. **Check R package versions**:
   ```r
   packageVersion("bookdown")
   packageVersion("knitr")
   ```

2. **Update packages**:
   ```r
   update.packages(ask = FALSE)
   ```

3. **Clear previous build files**:
   ```r
   bookdown::clean_book(TRUE)
   ```

4. **Try building again**:
   ```r
   bookdown::render_book("index.Rmd")
   ```

### Missing Data Files

Some data files are large (>50MB). If they're not in your local clone:
- They should be tracked with Git LFS
- Or download them separately from the data source

### Build Takes Too Long

Building the full book can take 10-30 minutes depending on your machine. To speed up development:

1. **Use serve_book() for live preview**:
   ```r
   bookdown::serve_book()
   ```
   This only rebuilds changed files.

2. **Build specific chapters**:
   Comment out chapters in `_bookdown.yml` temporarily.

## Automated Building (Optional)

Consider setting up GitHub Actions to automatically rebuild the site when changes are pushed. Example workflow file would go in `.github/workflows/bookdown.yml`.

## Current Status

- ✅ Source files (`.Rmd`) updated to Spring 2026
- ⚠️ **PENDING**: `docs/` folder needs to be rebuilt
- ✅ README.md updated with local build instructions
- ✅ GitHub Pages configured to serve from `docs/` folder

## Next Steps

1. **Rebuild the site** using the instructions above
2. Verify all pages show correct Spring 2026 information
3. Push the updated `docs/` folder
4. Check the live site at https://jrm87.github.io/ECO3253_spring2026/
