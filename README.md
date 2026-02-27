# R Data Visualization

A collection of R scripts for analyzing and visualizing Swedish prescription data with interactive and static charts.

## Overview

This project provides a comprehensive set of R scripts for:
- Time series visualization of prescription trends
- Comparative analysis charts
- Interactive dashboards with filtering
- Statistical visualizations
- Advanced dashboard layouts

## Features

- **Time Series Analysis** - Track prescription trends over time
- **Comparative Charts** - Compare drug groups, gender, and age demographics
- **Interactive Dashboards** - Plotly-based dashboards with dropdown filters
- **Statistical Visualizations** - Histograms, box plots, and distribution analysis
- **HTML Export** - All visualizations export to interactive HTML files

## Prerequisites

### Required Software

- **R** (4.0 or later) - Statistical computing
- **RStudio Desktop** (optional) - Integrated development environment

### R Packages

The following R packages are required:
- `tidyverse` - Data manipulation and visualization
- `plotly` - Interactive visualizations
- `htmlwidgets` - Interactive HTML widgets
- `lubridate` - Date/time handling
- `scales` - Axis scales and formatting
- `zoo` - Time series utilities

## Installation

### Ubuntu/Linux

See the detailed [Ubuntu Setup Guide](docs/linux-ubuntu/SETUP.md) for step-by-step instructions.

Quick start:
```bash
# Install R
sudo apt update
sudo apt install r-base r-base-dev

# Install system dependencies
sudo apt install libcurl4-openssl-dev libxml2-dev libssl-dev

# Install R packages
R -e "install.packages(c('tidyverse', 'plotly', 'htmlwidgets', 'lubridate', 'scales', 'zoo'))"
```

## Usage

### Running the Scripts

1. **Navigate to the project:**
   ```bash
   cd /path/to/r-analyze-data/visualizations/R
   ```

2. **Run a script:**
   ```bash
   Rscript 01_time_series.R
   ```

3. **Or use RStudio:**
   - Open the desired `.R` file
   - Click "Run" or press `Ctrl+Enter`

### Available Scripts

| Script | Description |
|--------|-------------|
| `01_time_series.R` | Time series trend visualizations |
| `02_comparative_charts.R` | Comparative bar charts |
| `03_interactive_dashboard.R` | Interactive Plotly dashboard |
| `04_statistical.R` | Statistical visualizations |
| `05_enhanced_time_series.R` | Enhanced time series |
| `06_advanced_dashboard.R` | Advanced dashboard |

### Output

Generated HTML files are saved to:
```
output/visualizations/
```

## Data Preparation

Place your CSV data file in the `data/` directory. See the [Data Guide](docs/linux-ubuntu/DATA.md) for format requirements.

## Hosting Visualizations

### Using nginx

Serve visualizations locally using nginx. See the [Nginx Hosting Guide](docs/linux-ubuntu/NGINX.md) for setup instructions.

Quick start:
```bash
# Install nginx
sudo apt install nginx

# Configure and restart
sudo systemctl restart nginx

# Access at http://localhost/
```

## Documentation

### Guides

- [Setup Guide](docs/linux-ubuntu/SETUP.md) - Installation on Ubuntu
- [Usage Guide](docs/linux-ubuntu/USAGE.md) - Running the scripts
- [Data Guide](docs/linux-ubuntu/DATA.md) - Data preparation
- [Nginx Hosting Guide](docs/linux-ubuntu/NGINX.md) - Web server setup
- [Troubleshooting Guide](docs/linux-ubuntu/TROUBLESHOOTING.md) - Common issues

## Project Structure

```
r-analyze-data/
├── data/                          # Data files
├── visualizations/
│   └── R/
│       ├── 01_time_series.R
│       ├── 02_comparative_charts.R
│       ├── 03_interactive_dashboard.R
│       ├── 04_statistical.R
│       ├── 05_enhanced_time_series.R
│       ├── 06_advanced_dashboard.R
│       └── utilities.R
├── output/
│   └── visualizations/           # Generated HTML files
└── docs/
    └── linux-ubuntu/             # Documentation
        ├── SETUP.md
        ├── USAGE.md
        ├── DATA.md
        ├── NGINX.md
        └── TROUBLESHOOTING.md
```

## License

This project is for educational and research purposes.

## Contributing

Contributions are welcome! Please feel free to submit issues or pull requests.
