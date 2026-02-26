# Enhanced Time Series Visualizations
# For Swedish Prescription Data Analysis

# Source shared utilities
source("utilities.R")

# ============================================================================
# Time Series Functions
# ============================================================================

#' Create monthly trend visualization
create_monthly_trend <- function(data, drug_groups = NULL) {
  monthly_data <- filter_monthly_data(data)
  
  # Filter to specific drug groups if provided
  if (!is.null(drug_groups)) {
    monthly_data <- monthly_data[monthly_data$drug_group %in% drug_groups, ]
  }
  
  # Get top 5 drugs overall
  top_drugs <- get_top_drug_groups(data, 5)
  
  # Filter to top drugs
  monthly_data <- monthly_data[monthly_data$drug_group %in% top_drugs, ]
  
  # Aggregate by month
  monthly_agg <- aggregate(prescriptions ~ year + month + drug_group, 
                          data = monthly_data, sum)
  
  # Create date column
  monthly_agg$date <- as.Date(paste(monthly_agg$year, monthly_agg$month, "01", sep = "-"))
  
  p <- ggplot(monthly_agg, aes(x = date, y = prescriptions, color = drug_group)) +
    geom_line(linewidth = 0.8) +
    scale_y_continuous(labels = scales::comma) +
    labs(
      title = "Monthly Prescription Trends by Drug Group",
      x = "Month",
      y = "Prescriptions",
      color = "Drug Group"
    ) +
    theme_minimal() +
    theme(
      plot.title = element_text(hjust = 0.5, size = 14, face = "bold"),
      legend.text = element_text(size = 8)
    )
  
  return(p)
}

#' Create demographic filtered visualization (gender)
create_gender_filtered_trend <- function(data, gender_filter = "Kvinna") {
  yearly_data <- filter_yearly_data(data)
  
  # Filter by gender
  yearly_data <- yearly_data[yearly_data$gender == gender_filter, ]
  
  # Get top 5 drugs
  drug_totals <- aggregate(prescriptions ~ drug_group, data = yearly_data, sum)
  top_drugs <- drug_totals$drug_group[order(drug_totals$prescriptions, decreasing = TRUE)][1:5]
  yearly_data <- yearly_data[yearly_data$drug_group %in% top_drugs, ]
  
  p <- ggplot(yearly_data, aes(x = year, y = prescriptions, color = drug_group)) +
    geom_line(linewidth = 1) +
    geom_point(size = 2) +
    scale_y_continuous(labels = scales::comma) +
    labs(
      title = paste("Prescription Trends -", gender_filter),
      x = "Year",
      y = "Prescriptions",
      color = "Drug Group"
    ) +
    theme_minimal() +
    theme(
      plot.title = element_text(hjust = 0.5, size = 14, face = "bold"),
      legend.text = element_text(size = 8)
    )
  
  return(p)
}

#' Create year-over-year comparison bars
create_yoy_comparison <- function(data) {
  yearly_data <- filter_yearly_data(data)
  
  # Get top 5 drugs
  top_drugs <- get_top_drug_groups(data, 5)
  yearly_data <- yearly_data[yearly_data$drug_group %in% top_drugs, ]
  
  # Calculate YoY change
  yearly_agg <- aggregate(prescriptions ~ year + drug_group, data = yearly_data, sum)
  
  # Calculate YoY percentage change
  yearly_agg <- yearly_agg[order(yearly_agg$drug_group, yearly_agg$year), ]
  yearly_agg$prev_year_prescriptions <- ave(yearly_agg$prescriptions, yearly_agg$drug_group, 
                                           FUN = function(x) c(NA, x[-length(x)]))
  yearly_agg$yoy_change <- ((yearly_agg$prescriptions - yearly_agg$prev_year_prescriptions) / 
                             yearly_agg$prev_year_prescriptions) * 100
  
  # Filter out NA values
  yearly_agg <- yearly_agg[!is.na(yearly_agg$yoy_change), ]
  
  p <- ggplot(yearly_agg, aes(x = year, y = yoy_change, fill = drug_group)) +
    geom_bar(stat = "identity", position = "dodge") +
    geom_hline(yintercept = 0, color = "black", linewidth = 0.5) +
    scale_y_continuous(labels = function(x) paste0(x, "%")) +
    labs(
      title = "Year-over-Year Prescription Change (%)",
      x = "Year",
      y = "Change (%)",
      fill = "Drug Group"
    ) +
    theme_minimal() +
    theme(
      plot.title = element_text(hjust = 0.5, size = 14, face = "bold"),
      legend.text = element_text(size = 8)
    )
  
  return(p)
}

#' Create monthly seasonality analysis
create_seasonality <- function(data) {
  monthly_data <- filter_monthly_data(data)
  
  # Get top 5 drugs
  top_drugs <- get_top_drug_groups(data, 3)
  monthly_data <- monthly_data[monthly_data$drug_group %in% top_drugs, ]
  
  # Aggregate by month (across all years)
  monthly_agg <- aggregate(prescriptions ~ month + drug_group, data = monthly_data, mean)
  
  p <- ggplot(monthly_agg, aes(x = month, y = prescriptions, color = drug_group, group = drug_group)) +
    geom_line(linewidth = 1.5) +
    geom_point(size = 3) +
    scale_x_continuous(breaks = 1:12, 
                      labels = c("Jan", "Feb", "Mar", "Apr", "May", "Jun",
                                "Jul", "Aug", "Sep", "Oct", "Nov", "Dec")) +
    scale_y_continuous(labels = scales::comma) +
    labs(
      title = "Monthly Seasonality Pattern (Average Across Years)",
      x = "Month",
      y = "Average Prescriptions",
      color = "Drug Group"
    ) +
    theme_minimal() +
    theme(
      plot.title = element_text(hjust = 0.5, size = 14, face = "bold"),
      legend.text = element_text(size = 8)
    )
  
  return(p)
}

# ============================================================================
# Main Execution
# ============================================================================

main <- function() {
  cat("Loading prescription data...\n")
  data <- load_prescription_data()
  cat("Data loaded:", nrow(data), "rows\n")
  
  # 2.2 Monthly trend visualization
  cat("\nCreating monthly trend visualization...\n")
  p1 <- create_monthly_trend(data)
  export_to_png(p1, "monthly_trends.png")
  export_to_html(p1, "monthly_trends.html")
  
  # 2.3 Demographic filtering - Female
  cat("\nCreating gender-filtered trends (Female)...\n")
  p2 <- create_gender_filtered_trend(data, "Kvinna")
  export_to_png(p2, "trends_female.png")
  
  # 2.3 Demographic filtering - Male
  cat("\nCreating gender-filtered trends (Male)...\n")
  p3 <- create_gender_filtered_trend(data, "Man")
  export_to_png(p3, "trends_male.png")
  
  # 2.5 Year-over-year comparison
  cat("\nCreating year-over-year comparison...\n")
  p4 <- create_yoy_comparison(data)
  export_to_png(p4, "year_over_year_comparison.png")
  export_to_html(p4, "year_over_year_comparison.html")
  
  # 2.6 Monthly seasonality analysis
  cat("\nCreating seasonality analysis...\n")
  p5 <- create_seasonality(data)
  export_to_png(p5, "seasonality_analysis.png")
  export_to_html(p5, "seasonality_analysis.html")
  
  cat("\nEnhanced time series visualizations complete!\n")
}

if (!interactive()) {
  main()
}
