# Statistical Visualizations
# For Swedish Prescription Data Analysis

# Source shared utilities
source("utilities.R")

# ============================================================================
# Statistical Visualization Functions
# ============================================================================

#' Create histogram with adjustable bins
create_histogram <- function(data, bins = 30) {
  yearly_data <- filter_yearly_data(data)
  
  # Filter to 2024
  yearly_data <- yearly_data[yearly_data$year == 2024, ]
  
  # Aggregate by drug group
  drug_totals <- aggregate(prescriptions ~ drug_group, data = yearly_data, sum)
  
  p <- ggplot(drug_totals, aes(x = prescriptions)) +
    geom_histogram(bins = bins, fill = "steelblue", color = "white") +
    scale_x_continuous(labels = scales::comma) +
    scale_y_continuous(labels = scales::comma) +
    labs(
      title = paste("Distribution of Prescriptions by Drug Group (2024) -", bins, "bins"),
      x = "Total Prescriptions",
      y = "Count of Drug Groups"
    ) +
    theme_minimal() +
    theme(plot.title = element_text(hjust = 0.5, size = 14, face = "bold"))
  
  return(p)
}

#' Create box plot by drug group
create_boxplot <- function(data) {
  yearly_data <- filter_yearly_data(data)
  
  # Get top 8 drug groups
  drug_totals <- aggregate(prescriptions ~ drug_group, data = yearly_data, sum)
  top_drugs <- drug_totals$drug_group[order(drug_totals$prescriptions, decreasing = TRUE)][1:8]
  yearly_data <- yearly_data[yearly_data$drug_group %in% top_drugs, ]
  
  p <- ggplot(yearly_data, aes(x = drug_group, y = prescriptions, fill = drug_group)) +
    geom_boxplot() +
    scale_y_continuous(labels = scales::comma) +
    labs(
      title = "Prescription Distribution by Drug Group (Box Plot)",
      x = "Drug Group",
      y = "Prescriptions"
    ) +
    theme_minimal() +
    theme(
      plot.title = element_text(hjust = 0.5, size = 14, face = "bold"),
      axis.text.x = element_text(angle = 45, hjust = 1, size = 8),
      legend.position = "none"
    )
  
  return(p)
}

#' Create summary statistics
create_summary_stats <- function(data) {
  yearly_data <- filter_yearly_data(data)
  
  # Calculate summary statistics by drug group
  stats <- aggregate(prescriptions ~ drug_group, data = yearly_data, 
                     FUN = function(x) c(
                       mean = mean(x),
                       median = median(x),
                       sd = sd(x),
                       min = min(x),
                       max = max(x),
                       n = length(x)
                     ))
  
  # Flatten the stats
  stats_df <- data.frame(
    drug_group = stats$drug_group,
    mean = stats$prescriptions[, "mean"],
    median = stats$prescriptions[, "median"],
    sd = stats$prescriptions[, "sd"],
    min = stats$prescriptions[, "min"],
    max = stats$prescriptions[, "max"],
    n = stats$prescriptions[, "n"]
  )
  
  # Order by mean
  stats_df <- stats_df[order(stats_df$mean, decreasing = TRUE), ]
  
  # Display top 10
  return(head(stats_df, 10))
}

#' Create statistics visualization
create_statistics_chart <- function(data) {
  yearly_data <- filter_yearly_data(data)
  
  # Get top 8 drugs
  drug_totals <- aggregate(prescriptions ~ drug_group, data = yearly_data, sum)
  top_drugs <- drug_totals$drug_group[order(drug_totals$prescriptions, decreasing = TRUE)][1:8]
  yearly_data <- yearly_data[yearly_data$drug_group %in% top_drugs, ]
  
  # Calculate stats by drug and year
  stats <- aggregate(prescriptions ~ drug_group + year, data = yearly_data, 
                     FUN = function(x) c(mean = mean(x), median = median(x)))
  
  # Flatten
  stats_df <- data.frame(
    drug_group = stats$drug_group,
    year = stats$year,
    mean = stats$prescriptions[, "mean"],
    median = stats$prescriptions[, "median"]
  )
  
  p <- ggplot(stats_df, aes(x = year, y = mean, color = drug_group)) +
    geom_line(linewidth = 1) +
    geom_point(size = 2) +
    scale_y_continuous(labels = scales::comma) +
    labs(
      title = "Mean Prescriptions by Drug Group Over Time",
      x = "Year",
      y = "Mean Prescriptions",
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
  
  # 5.1 Histogram with adjustable bins
  cat("\nCreating histogram...\n")
  p1 <- create_histogram(data, bins = 20)
  export_to_png(p1, "histogram_prescriptions.png")
  export_to_html(p1, "histogram_prescriptions.html")
  
  # 5.2 Box plots by drug group
  cat("\nCreating box plots...\n")
  p2 <- create_boxplot(data)
  export_to_png(p2, "boxplot_by_drug_group.png")
  export_to_html(p2, "boxplot_by_drug_group.html")
  
  # 5.4 Statistics visualization
  cat("\nCreating statistics chart...\n")
  p3 <- create_statistics_chart(data)
  export_to_png(p3, "statistics_chart.png")
  export_to_html(p3, "statistics_chart.html")
  
  # 5.3, 5.5 Summary statistics table
  cat("\nComputing summary statistics...\n")
  stats <- create_summary_stats(data)
  print(stats)
  
  # Save stats to CSV
  write.csv(stats, file.path(OUTPUT_DIR, "summary_statistics.csv"), row.names = FALSE)
  cat("Exported: output/visualizations/summary_statistics.csv\n")
  
  cat("\nStatistical visualizations complete!\n")
}

if (!interactive()) {
  main()
}
