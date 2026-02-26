# R Data Visualization Scripts
# For Swedish Prescription Data Analysis

# Source shared utilities
source("utilities.R")

# ============================================================================
# Time Series Visualization Functions
# ============================================================================

#' Create yearly trend line chart
#' @param data The prescription data
#' @param drug_groups Optional vector of drug groups to include
#' @param filter_gender Optional gender filter ("Male" or "Female")
#' @param filter_age Optional age group filter
#' @return ggplot object
create_yearly_trend_plot <- function(data, drug_groups = NULL, 
                                      filter_gender = NULL, filter_age = NULL) {
  
  # Get yearly data
  yearly_data <- filter_yearly_data(data)
  
  # Apply filters
  if (!is.null(filter_gender)) {
    yearly_data <- yearly_data[yearly_data$gender == filter_gender, ]
  }
  if (!is.null(filter_age)) {
    yearly_data <- yearly_data[yearly_data$age_group == filter_age, ]
  }
  if (!is.null(drug_groups)) {
    yearly_data <- yearly_data[yearly_data$drug_group %in% drug_groups, ]
  }
  
  # Aggregate
  yearly_agg <- aggregate(prescriptions ~ year + drug_group, data = yearly_data, sum)
  
  # Create plot
  p <- ggplot(yearly_agg, aes(x = year, y = prescriptions, color = drug_group)) +
    geom_line(linewidth = 1) +
    geom_point(size = 2) +
    scale_y_continuous(labels = scales::comma) +
    labs(
      title = "Yearly Prescription Trends by Drug Group",
      x = "Year",
      y = "Prescriptions",
      color = "Drug Group"
    ) +
    theme_minimal() +
    theme(
      plot.title = element_text(hjust = 0.5, size = 14, face = "bold"),
      legend.position = "right",
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
  
  # Show unique values for filtering
  cat("\nUnique drug groups:", length(unique(data$drug_group)), "\n")
  cat("Unique genders:", unique(data$gender), "\n")
  cat("Unique age groups:", unique(data$age_group), "\n")
  cat("Unique measure types:", unique(data$measure_type), "\n")
  
  # Get top drug groups by total prescriptions
  top_drugs <- get_top_drug_groups(data, 5)
  cat("\nTop 5 drug groups by prescriptions:\n")
  
  yearly_data <- filter_yearly_data(data)
  drug_totals <- aggregate(prescriptions ~ drug_group, data = yearly_data, sum)
  print(head(drug_totals[order(drug_totals$prescriptions, decreasing = TRUE), ], 5))
  
  # Create yearly trend plot for top 5 drug groups
  cat("\nCreating yearly trend plot...\n")
  p <- create_yearly_trend_plot(data, drug_groups = top_drugs)
  
  # Export to PNG
  export_to_png(p, "yearly_trends_by_drug_group.png")
  
  # Export to interactive HTML
  export_to_html(p, "yearly_trends_by_drug_group.html")
  
  cat("\nVisualization complete!\n")
}

# Run if executed directly
if (!interactive()) {
  main()
}
