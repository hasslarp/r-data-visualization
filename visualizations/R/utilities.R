# Shared Utility Functions
# For Swedish Prescription Data Analysis

library(ggplot2)
library(plotly)
library(htmlwidgets)

# ============================================================================
# Configuration
# ============================================================================

# Get project root directory (assumes script is in visualizations/R/)
PROJECT_ROOT <- normalizePath(file.path(dirname(sys.frame(1)$ofile), "..", ".."))
DATA_FILE <- file.path(PROJECT_ROOT, "data", "LM2001_20260226-092552.csv")
OUTPUT_DIR <- file.path(PROJECT_ROOT, "output", "visualizations")

# ============================================================================
# Data Loading Functions
# ============================================================================

load_prescription_data <- function(file_path = DATA_FILE) {
  # Read the raw file as text first to handle encoding
  raw_lines <- readLines(file_path, encoding = "latin1")
  
  # Parse CSV from text
  data <- read.csv(text = raw_lines, 
                   header = FALSE, 
                   sep = ";",
                   stringsAsFactors = FALSE,
                   skip = 1,  # Skip the title row
                   na.strings = c("", "NA"))
  
  # Set column names
  colnames(data) <- c("drug_group", "gender", "age_group", "period", 
                      "measure_type", "prescriptions")
  
  # Convert prescriptions to numeric (remove any spaces in numbers)
  data$prescriptions <- as.numeric(gsub(" ", "", data$prescriptions))
  
  # Add year column
  data$year <- ifelse(nchar(data$period) == 4, as.integer(data$period), 
                      as.integer(substr(data$period, 1, 4)))
  
  return(data)
}

# ============================================================================
# Data Processing Functions
# ============================================================================

filter_yearly_data <- function(data) {
  # Filter to yearly data only (period is 4-digit year)
  yearly_data <- data[nchar(data$period) == 4, ]
  yearly_data$year <- as.integer(yearly_data$period)
  return(yearly_data)
}

filter_monthly_data <- function(data) {
  # Filter to monthly data (period contains hyphen)
  monthly_data <- data[grep("-", data$period, fixed = TRUE), ]
  monthly_data$year <- as.integer(substr(monthly_data$period, 1, 4))
  monthly_data$month <- as.integer(substr(monthly_data$period, 6, 7))
  return(monthly_data)
}

# ============================================================================
# Export Functions
# ============================================================================

#' Export plot to PNG
#' @param plot ggplot object
#' @param filename Output filename
#' @param width Width in inches
#' @param height Height in inches
export_to_png <- function(plot, filename, width = 10, height = 6, 
                          output_dir = OUTPUT_DIR) {
  output_path <- file.path(output_dir, filename)
  ggsave(output_path, plot, width = width, height = height, dpi = 300)
  cat("Exported:", output_path, "\n")
}

#' Export plot to interactive HTML using plotly
#' @param plot ggplot object
#' @param filename Output HTML filename
export_to_html <- function(plot, filename, output_dir = OUTPUT_DIR) {
  output_path <- file.path(output_dir, filename)
  # Convert ggplot to plotly
  plt <- ggplotly(plot)
  # Save as HTML (without selfcontained to avoid pandoc dependency)
  htmlwidgets::saveWidget(plt, output_path, selfcontained = FALSE)
  cat("Exported:", output_path, "\n")
}

# ============================================================================
# Helper Functions
# ============================================================================

get_top_drug_groups <- function(data, n = 5) {
  yearly_data <- filter_yearly_data(data)
  drug_totals <- aggregate(prescriptions ~ drug_group, data = yearly_data, sum)
  top_drugs <- drug_totals$drug_group[order(drug_totals$prescriptions, decreasing = TRUE)][1:n]
  return(top_drugs)
}

get_available_years <- function(data) {
  yearly_data <- filter_yearly_data(data)
  available_years <- sort(unique(yearly_data$year))
  return(available_years)
}
