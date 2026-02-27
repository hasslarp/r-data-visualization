# Ubuntu Setup Guide for R Data Analysis

This guide covers the complete setup process for running R data analysis and visualization scripts on Ubuntu Linux (20.04+).

## Table of Contents

1. [System Requirements](#system-requirements)
2. [Install R](#install-r)
3. [Install System Dependencies](#install-system-dependencies)
4. [Install RStudio Desktop (Optional)](#install-rstudio-desktop-optional)
5. [Install R Packages](#install-r-packages)
6. [Verify Installation](#verify-installation)

---

## System Requirements

- **Operating System:** Ubuntu 20.04 LTS or later
- **RAM:** Minimum 4GB (8GB recommended)
- **Disk Space:** At least 2GB free space
- **Internet Connection:** Required for package downloads

---

## Install R

### Step 1: Update Package List

```bash
sudo apt update
```

### Step 2: Install Basic Dependencies

```bash
sudo apt install -y dirmngr gnupg2
```

### Step 3: Add CRAN Repository

For Ubuntu 20.04:
```bash
sudo apt install -y software-properties-common
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB1417166B2AF37790
sudo add-apt-repository "deb https://cloud.r-project.org/bin/linux/ubuntu focal-cran40/"
```

For Ubuntu 22.04:
```bash
sudo apt install -y software-properties-common
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB1417166B2AF37790
sudo add-apt-repository "deb https://cloud.r-project.org/bin/linux/ubuntu jammy-cran40/"
```

For Ubuntu 24.04:
```bash
sudo apt install -y software-properties-common
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB1417166B2AF37790
sudo add-apt-repository "deb https://cloud.r-project.org/bin/linux/ubuntu noble-cran40/"
```

### Step 4: Install R

```bash
sudo apt update
sudo apt install -y r-base r-base-dev
```

---

## Install System Dependencies

R packages require various system libraries. Install them with:

```bash
sudo apt install -y \
    libcurl4-openssl-dev \
    libxml2-dev \
    libssl-dev \
    libgit2-dev \
    libfontconfig1-dev \
    libfreetype6-dev \
    libpng-dev \
    libjpeg-dev \
    libtiff5-dev \
    libharfbuzz-dev \
    libfribidi-dev \
    pandoc
```

### Package Descriptions

| Package | Purpose |
|---------|---------|
| `libcurl4-openssl-dev` | HTTP requests (httr, rcran) |
| `libxml2-dev` | XML parsing (xml2) |
| `libssl-dev` | SSL/TLS connections |
| `libfontconfig1-dev` | Font configuration |
| `libfreetype6-dev` | FreeType font rendering |
| `libpng-dev` | PNG image support |
| `libjpeg-dev` | JPEG image support |
| `pandoc` | Document conversion |

---

## Install RStudio Desktop (Optional)

RStudio provides an integrated development environment (IDE) for R.

### Method 1: Install via Ubuntu Software

1. Download RStudio Desktop from https://posit.co/download/rstudio-desktop/
2. Open the `.deb` file with Ubuntu Software
3. Click "Install"

### Method 2: Install via Terminal

```bash
# Download RStudio (check for latest version)
cd /tmp
wget https://download1.rstudio.org/electron/jammy/amd64/rstudio-2024.12.1-577-amd64.deb

# Install the package
sudo apt install -y ./rstudio-2024.12.1-577-amd64.deb

# Clean up
rm rstudio-2024.12.1-577-amd64.deb
```

> **Note:** Replace the filename with the latest version from https://posit.co/download/rstudio-desktop/

---

## Install R Packages

### Step 1: Launch R

```bash
R
```

### Step 2: Install Required Packages

```r
# Install tidyverse (includes ggplot2, dplyr, tidyr, etc.)
install.packages("tidyverse")

# Install plotly for interactive visualizations
install.packages("plotly")

# Install htmlwidgets for interactive HTML output
install.packages("htmlwidgets")

# Install lubridate for date/time handling
install.packages("lubridate")

# Install scales for axis scales
install.packages("scales")

# Install zoo for time series
install.packages("zoo")
```

### Step 3: Install All Packages at Once

```r
packages <- c(
    "tidyverse",
    "plotly",
    "htmlwidgets",
    "lubridate",
    "scales",
    "zoo"
)

install.packages(packages)
```

### Step 4: Exit R

```r
q()
```

---

## Verify Installation

### Verify R Installation

```bash
R --version
```

Expected output:
```
R version 4.x.x (2024-...) -- "xxxxx"
Copyright (C) 2024 The R Foundation for Statistical Computing
...
```

### Verify R Packages

```bash
R -e "library(tidyverse); library(plotly); library(lubridate); cat('All packages loaded successfully!\n')"
```

### Verify System Dependencies

```bash
# Check pkg-config can find libraries
pkg-config --modversion libcurl && echo "libcurl: OK"
pkg-config --modversion libxml-2.0 && echo "libxml2: OK"
pkg-config --modversion openssl && echo "openssl: OK"
```

---

## Next Steps

Now that R and all dependencies are installed, proceed to:

- [USAGE.md](USAGE.md) - Learn how to run the visualization scripts
- [DATA.md](DATA.md) - Prepare your data files
- [NGINX.md](NGINX.md) - Set up a web server to host visualizations
- [TROUBLESHOOTING.md](TROUBLESHOOTING.md) - Common issues and solutions
