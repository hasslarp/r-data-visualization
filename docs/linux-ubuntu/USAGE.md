# Usage Guide for R Visualization Scripts

This guide explains how to run each R visualization script in the project.

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Project Structure](#project-structure)
3. [Running the Scripts](#running-the-scripts)
4. [Output Files](#output-files)

---

## Prerequisites

Before running any scripts, ensure you have:

1. **R installed** - See [SETUP.md](SETUP.md) for installation instructions
2. **Required R packages** - Install with:
   ```r
   install.packages(c("tidyverse", "plotly", "htmlwidgets", "lubridate", "scales", "zoo"))
   ```
3. **Data file** - Place your CSV data file in the `data/` directory

---

## Project Structure

```
r-analyze-data/
├── data/                          # Data files (CSV)
├── visualizations/
│   └── R/
│       ├── 01_time_series.R       # Time series visualizations
│       ├── 02_comparative_charts.R # Comparative analysis charts
│       ├── 03_interactive_dashboard.R # Interactive dashboards
│       ├── 04_statistical.R       # Statistical visualizations
│       ├── 05_enhanced_time_series.R # Enhanced time series
│       ├── 06_advanced_dashboard.R # Advanced dashboard
│       └── utilities.R            # Shared utility functions
├── output/
│   └── visualizations/            # Generated HTML files
└── docs/
    └── linux-ubuntu/
        ├── SETUP.md               # Installation guide
        ├── USAGE.md               # This file
        ├── DATA.md                # Data preparation guide
        ├── NGINX.md               # Web hosting guide
        └── TROUBLESHOOTING.md     # Common issues
```

---

## Running the Scripts

### Method 1: Run from Terminal

Navigate to the project directory and run R scripts:

```bash
cd /path/to/r-analyze-data/visualizations/R

# Run a specific script
Rscript 01_time_series.R

# Or launch R interactively
R
```

Then inside R:
```r
source("01_time_series.R")
```

### Method 2: Run from RStudio

1. Open RStudio
2. Navigate to `visualizations/R/`
3. Open the desired script
4. Click "Run" or press `Ctrl+Enter`

---

## Script Reference

### 01_time_series.R

**Purpose:** Creates time series visualizations showing prescription trends over time.

**Features:**
- Yearly trend line charts by drug group
- Filterable by gender and age group
- Multiple drug group comparison
- Static ggplot2 visualizations

**Output:** Static PNG/HTML files saved to `output/visualizations/`

**Key Functions:**
- `create_yearly_trend_plot()` - Main trend visualization

---

### 02_comparative_charts.R

**Purpose:** Creates comparative analysis charts for different dimensions.

**Features:**
- Horizontal bar charts for drug group comparison
- Grouped bar charts for gender comparison
- Top drug group identification
- Comparative analysis across categories

**Output:** Static PNG/HTML files saved to `output/visualizations/`

**Key Functions:**
- `create_drug_group_bar_chart()` - Horizontal bar chart
- `create_gender_comparison_chart()` - Gender comparison

---

### 03_interactive_dashboard.R

**Purpose:** Creates interactive Plotly dashboards with filtering capabilities.

**Features:**
- Interactive line charts
- Dropdown filters for drug groups
- Year selection
- Gender and age group filters
- Zoom and pan functionality
- Hover tooltips

**Output:** Interactive HTML files saved to `output/visualizations/`

**Key Functions:**
- `create_interactive_dashboard()` - Main dashboard with filters
- Generates standalone HTML files

> **Note:** This script requires the `plotly` and `htmlwidgets` packages.

---

### 04_statistical.R

**Purpose:** Creates statistical visualizations for data distribution analysis.

**Features:**
- Histograms with adjustable bins
- Box plots by drug group
- Distribution analysis
- Statistical summary visualizations

**Output:** Static PNG/HTML files saved to `output/visualizations/`

**Key Functions:**
- `create_histogram()` - Distribution histogram
- `create_boxplot()` - Box plot visualization

---

### 05_enhanced_time_series.R

**Purpose:** Creates enhanced time series visualizations with additional analysis.

**Features:**
- Enhanced trend visualizations
- Moving average calculations
- Seasonal decomposition views
- Multiple time granularity options
- Advanced formatting

**Output:** Static PNG/HTML files saved to `output/visualizations/`

**Key Functions:**
- Enhanced time series plotting functions
- Uses `zoo` package for time series support

---

### 06_advanced_dashboard.R

**Purpose:** Creates advanced dashboards combining multiple visualization types.

**Features:**
- Multi-panel layouts
- Combined chart types
- Advanced filtering
- Summary statistics
- Custom styling

**Output:** Static PNG/HTML files saved to `output/visualizations/`

**Key Functions:**
- Advanced dashboard creation functions

---

### utilities.R

**Purpose:** Contains shared utility functions used by all visualization scripts.

**Functions Provided:**
- `filter_yearly_data()` - Filter data to yearly aggregates
- `get_top_drug_groups()` - Get top N drug groups by prescription count
- Data loading and preprocessing utilities
- Common helper functions

> **Note:** This file is sourced by all other scripts. Do not run it directly.

---

## Output Files

All scripts save their output to the `output/visualizations/` directory:

| Script | Output File(s) |
|--------|----------------|
| 01_time_series.R | `time_series_*.html` |
| 02_comparative_charts.R | `comparative_*.html` |
| 03_interactive_dashboard.R | `dashboard_*.html` |
| 04_statistical.R | `statistical_*.html` |
| 05_enhanced_time_series.R | `enhanced_time_series_*.html` |
| 06_advanced_dashboard.R | `advanced_dashboard_*.html` |

---

## Next Steps

- [DATA.md](DATA.md) - Learn how to prepare your data files
- [NGINX.md](NGINX.md) - Host visualizations on a web server
- [TROUBLESHOOTING.md](TROUBLESHOOTING.md) - Solve common issues
