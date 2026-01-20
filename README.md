# ECO 3253 – Spring 2026

## Economics of Public and Social Issues

This is the course website for ECO 3253 at UTSA, taught in the Spring of 2026 by Jonathan Moreno-Medina.

**Course Information:**
- **Semester:** Spring 2026
- **Class Days:** Tuesday and Thursday
- **Time:** 1:00 PM
- **First Class:** January 20, 2026

## About This Website

This website is built using [R Bookdown](https://bookdown.org/), which allows us to create beautiful, interactive course materials that integrate text, code, data visualizations, and mathematical notation.

The site includes:
- Course schedule and syllabus
- Lecture notes and materials
- R tutorials and code examples
- Project assignments
- Statistical methods tutorials

## Viewing the Website

The published course website is available at: https://jrm87.github.io/ECO3253_spring2026/

## Building the Site Locally

If you want to run and build this website on your own computer, follow these steps:

### Prerequisites

1. **Install Conda**: Download and install [Miniconda](https://docs.conda.io/en/latest/miniconda.html) or [Anaconda](https://www.anaconda.com/products/distribution).
2. **Install RStudio**: Download and install RStudio from [RStudio's website](https://posit.co/download/rstudio-desktop/) (Optional but recommended).

### Environment Setup

1. **Clone this repository**:
   ```bash
   git clone https://github.com/jrm87/ECO3253_spring2026.git
   cd ECO3253_spring2026
   ```

2. **Create and Activate the Environment**:
   ```bash
   conda env create -f environment.yml
   conda activate eco3253
   ```

### Building the Site

1. **Clone this repository**:
```bash
git clone https://github.com/jrm87/ECO3253_spring2026.git
cd ECO3253_spring2026
```

2. **Open the project in RStudio**:
   - Open RStudio
   - File → Open Project
   - Select the repository folder

3. **Build the book**:
   
   Option A - Using RStudio:
   - Open `index.Rmd` in RStudio
   - Click the "Build" tab in the upper-right pane
   - Click "Build Book"
   
   Option B - Using R console:
   ```r
   bookdown::render_book("index.Rmd")
   ```

4. **View the site**:
   - The built website will be in the `docs/` folder
   - Open `docs/index.html` in your web browser
   - Or use RStudio's viewer pane

### Serving Locally

To preview the site with live reload during development:

```r
bookdown::serve_book()
```

This will start a local web server and automatically rebuild the book when you save changes.

## Project Structure

```
├── index.Rmd              # Main landing page and course overview
├── 00-schedule.Rmd        # Course schedule
├── 01-intro.Rmd           # Introduction chapter
├── 02-*.Rmd              # Course content chapters
├── 03-*.Rmd              # R tutorials and methods
├── project*.Rmd          # Project assignments
├── 91-appendixA.Rmd      # Appendices
├── _bookdown.yml         # Bookdown configuration
├── _output.yml           # Output format configuration
├── book.bib              # Bibliography
├── style.css             # Custom CSS styling
├── data/                 # Course datasets
├── images/               # Images and figures
├── slides/               # Lecture slides
└── docs/                 # Generated website (published to GitHub Pages)
```

## GitHub Pages Deployment

This site is configured to deploy automatically to GitHub Pages from the `docs/` folder on the `main` branch.

### Setup GitHub Pages (Already Configured)

1. Go to repository Settings → Pages
2. Source: Deploy from a branch
3. Branch: `main`
4. Folder: `/docs`

After pushing changes to `main`, GitHub will automatically publish the updated site.

## Course Content

### Topics Covered

- Geography of Upward Mobility in America
- Causal Effects of Neighborhoods
- Historical and International Evidence on Inequality
- Higher Education and Upward Mobility
- Primary Education (K-12)
- Teachers and Charter Schools
- Racial Disparities in Economic Opportunity
- Criminal Justice and Judicial Decisions
- Immigration
- Political Economy
- Income Taxation
- Environmental Economics

### Statistical Methods

- Data Visualization with ggplot2
- Data Wrangling with dplyr
- Regression Analysis
- Causal Inference
- Experimental Design (RCTs)
- Quasi-Experimental Methods
- Machine Learning Basics
- R Programming

## Contributing

If you find any errors or have suggestions for improvements, please:
1. Open an issue in this repository
2. Or submit a pull request with your proposed changes

## License

Course materials © 2026 Jonathan Moreno-Medina. All rights reserved.

## Contact

For questions about the course, please contact the instructor through Canvas or during office hours.

## Acknowledgments

This course is partly based on the [Using Big Data to Solve Economic and Social Problems](https://opportunityinsights.org/course/) course by Prof. Raj Chetty at Harvard University. Statistical computing materials draw from [ModernDive](https://moderndive.com/) by Chester Ismay and Albert Y. Kim.
