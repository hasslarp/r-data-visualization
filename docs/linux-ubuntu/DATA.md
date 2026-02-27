# Data Preparation Guide

This guide explains how to prepare and manage data files for the R visualization scripts.

## Table of Contents

1. [Expected Data Format](#expected-data-format)
2. [Data File Structure](#data-file-structure)
3. [Placing Data Files](#placing-data-files)
4. [Updating File Paths](#updating-file-paths)
5. [Data Validation](#data-validation)

---

## Expected Data Format

The visualization scripts are designed to work with Swedish prescription data in CSV format with the following characteristics:

### File Format
- **Delimiter:** Semicolon (`;`)
- **Encoding:** Latin-1 (ISO-8859-1)
- **Header:** Skip first row (contains title)
- **Missing Values:** Empty strings or "NA"

### Required Columns

| Column | Description | Example |
|--------|-------------|---------|
| `drug_group` | Drug group name | "Pain relievers" |
| `gender` | Gender ("Male" or "Female") | "Female" |
| `age_group` | Age group category | "15-44 years" |
| `period` | Time period (YYYY or YYYY-MM) | "2024" or "2024-01" |
| `measure_type` | Type of measure | "Prescriptions" |
| `prescriptions` | Number of prescriptions | 1,234,567 |

### Example Data Row

```
Paracetamol;Female;45-64 years;2024;Prescriptions;12345
```

---

## Data File Structure

### File Location

Place your CSV data file in the `data/` directory:

```
r-analyze-data/
└── data/
    └── your-data-file.csv    # Place your data here
```

### Default Filename

The scripts expect the data file to be named `LM2001_20260226-092552.csv` by default (configured in `visualizations/R/utilities.R`).

---

## Placing Data Files

### Step 1: Locate the data directory

```bash
cd /path/to/r-analyze-data
ls -la data/
```

### Step 2: Copy your data file

```bash
# Copy your CSV file to the data directory
cp /path/to/your/data.csv data/
```

### Step 3: Verify the file

```bash
# Check file exists and has content
ls -la data/*.csv
head -5 data/your-data-file.csv
```

---

## Updating File Paths

If your data file has a different name or location, you can update the path in two ways:

### Option 1: Modify utilities.R

Edit `visualizations/R/utilities.R` and change the `DATA_FILE` variable:

```r
# Change this line:
DATA_FILE <- file.path(PROJECT_ROOT, "data", "LM2001_20260226-092552.csv")

# To your filename:
DATA_FILE <- file.path(PROJECT_ROOT, "data", "your-data-file.csv")
```

### Option 2: Pass file path to load function

When calling `load_prescription_data()` in your scripts:

```r
# Load with custom path
data <- load_prescription_data("path/to/your/data.csv")
```

### Option 3: Use command-line argument

Pass the file path as an R session argument:

```bash
R --args data/myfile.csv -e 'source("your_script.R")'
```

---

## Data Validation

### Check Data Structure

Run this in R to validate your data:

```r
# Load data
source("visualizations/R/utilities.R")
data <- load_prescription_data()

# Check structure
str(data)

# Check column names
names(data)

# Check first few rows
head(data)

# Check for missing values
summary(data)

# Check unique values
unique(data$gender)
unique(data$age_group)
unique(data$period)
```

### Expected Data Characteristics

- **gender:** Should contain "Male" and/or "Female"
- **age_group:** Should contain age ranges (e.g., "0-14 years", "15-44 years", etc.)
- **period:** Should be 4-digit years (2020, 2021, etc.) or monthly (2024-01)
- **prescriptions:** Should be numeric values

### Common Data Issues

| Issue | Solution |
|-------|----------|
| Wrong delimiter | Convert CSV to semicolon-delimited |
| Wrong encoding | Convert to Latin-1 encoding |
| Missing columns | Add required columns |
| Wrong column order | Reorder columns to match expected format |
| Empty values | Fill in missing data or use NA |

---

## Creating Test Data

If you need to create test data, here's a template:

```csv
;Drug group;Gender;Age group;Period;Measure type;Prescriptions
;Pain relievers;Female;15-44 years;2024;Prescriptions;50000
;Pain relievers;Male;15-44 years;2024;Prescriptions;45000
;Antibiotics;Female;0-14 years;2024;Prescriptions;30000
;Antibiotics;Male;0-14 years;2024;Prescriptions;28000
```

---

## Next Steps

- [USAGE.md](USAGE.md) - Run the visualization scripts
- [NGINX.md](NGINX.md) - Host visualizations on a web server
- [TROUBLESHOOTING.md](TROUBLESHOOTING.md) - Solve data-related issues
