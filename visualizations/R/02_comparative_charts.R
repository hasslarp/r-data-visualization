# Comparative Analysis Charts
# For Swedish Prescription Data Analysis

# Source shared utilities
source("utilities.R")

# ============================================================================
# Comparative Chart Functions
# ============================================================================

#' Create horizontal bar chart for drug group comparison
create_drug_group_bar_chart <- function(data) {
  yearly_data <- filter_yearly_data(data)
  
  # Aggregate by drug group
  drug_totals <- aggregate(prescriptions ~ drug_group, data = yearly_data, sum)
  drug_totals <- drug_totals[order(drug_totals$prescriptions, decreasing = TRUE), ]
  
  # Create horizontal bar chart
  p <- ggplot(drug_totals, aes(x = prescriptions, y = reorder(drug_group, prescriptions))) +
    geom_bar(stat = "identity", fill = "steelblue") +
    scale_x_continuous(labels = scales::comma) +
    labs(
      title = "Prescription Volume by Drug Group",
      x = "Total Prescriptions",
      y = "Drug Group"
    ) +
    theme_minimal() +
    theme(
      plot.title = element_text(hjust = 0.5, size = 14, face = "bold"),
      axis.text.y = element_text(size = 8)
    )
  
  return(p)
}

#' Create grouped bar chart for gender comparison
create_gender_comparison_chart <- function(data) {
  yearly_data <- filter_yearly_data(data)
  
  # Filter to specific year for clarity
  yearly_data <- yearly_data[yearly_data$year == 2024, ]
  
  # Aggregate by gender and drug group
  gender_drug <- aggregate(prescriptions ~ gender + drug_group, 
                           data = yearly_data, sum)
  
  # Get top 5 drug groups
  top_drugs <- get_top_drug_groups(data, 5)
  gender_drug <- gender_drug[gender_drug$drug_group %in% top_drugs, ]
  
  # Create grouped bar chart
  p <- ggplot(gender_drug, aes(x = drug_group, y = prescriptions, fill = gender)) +
    geom_bar(stat = "identity", position = "dodge") +
    scale_y_continuous(labels = scales::comma) +
    labs(
      title = "Prescriptions by Gender and Drug Group (2024)",
      x = "Drug Group",
      y = "Prescriptions",
      fill = "Gender"
    ) +
    theme_minimal() +
    theme(
      plot.title = element_text(hjust = 0.5, size = 14, face = "bold"),
      axis.text.x = element_text(angle = 45, hjust = 1, size = 8)
    )
  
  return(p)
}

#' Create stacked bar chart for age group distribution
create_age_distribution_chart <- function(data) {
  yearly_data <- filter_yearly_data(data)
  
  # Filter to 2024
  yearly_data <- yearly_data[yearly_data$year == 2024, ]
  
  # Filter out the "All ages" category
  yearly_data <- yearly_data[yearly_data$age_group != "Alla åldrar", ]
  
  # Aggregate by age group and drug group
  age_drug <- aggregate(prescriptions ~ age_group + drug_group, 
                        data = yearly_data, sum)
  
  # Get top 5 drug groups
  top_drugs <- get_top_drug_groups(data, 5)
  age_drug <- age_drug[age_drug$drug_group %in% top_drugs, ]
  
  # Create stacked bar chart
  p <- ggplot(age_drug, aes(x = drug_group, y = prescriptions, fill = age_group)) +
    geom_bar(stat = "identity") +
    scale_y_continuous(labels = scales::comma) +
    labs(
      title = "Prescriptions by Age Group and Drug Group (2024)",
      x = "Drug Group",
      y = "Prescriptions",
      fill = "Age Group"
    ) +
    theme_minimal() +
    theme(
      plot.title = element_text(hjust = 0.5, size = 14, face = "bold"),
      axis.text.x = element_text(angle = 45, hjust = 1, size = 8)
    )
  
  return(p)
}

#' Create heatmap for drug group by period
create_drug_period_heatmap <- function(data) {
  yearly_data <- filter_yearly_data(data)
  
  # Get top 5 drug groups
  top_drugs <- get_top_drug_groups(data, 5)
  yearly_data <- yearly_data[yearly_data$drug_group %in% top_drugs, ]
  
  # Aggregate
  drug_period <- aggregate(prescriptions ~ year + drug_group, data = yearly_data, sum)
  
  # Create heatmap using ggplot2
  p <- ggplot(drug_period, aes(x = year, y = drug_group, fill = prescriptions)) +
    geom_tile() +
    scale_fill_gradient(low = "white", high = "steelblue", labels = scales::comma) +
    labs(
      title = "Prescription Heatmap: Drug Group by Year",
      x = "Year",
      y = "Drug Group",
      fill = "Prescriptions"
    ) +
    theme_minimal() +
    theme(
      plot.title = element_text(hjust = 0.5, size = 14, face = "bold"),
      axis.text.y = element_text(size = 8)
    )
  
  return(p)
}

#' Create demographic heatmap (gender x age group)
create_demographic_heatmap <- function(data) {
  yearly_data <- filter_yearly_data(data)
  
  # Filter to 2024
  yearly_data <- yearly_data[yearly_data$year == 2024, ]
  
  # Filter out "Alla åldrar"
  yearly_data <- yearly_data[yearly_data$age_group != "Alla åldrar", ]
  
  # Aggregate by gender and age group
  demo <- aggregate(prescriptions ~ gender + age_group, data = yearly_data, sum)
  
  # Create heatmap
  p <- ggplot(demo, aes(x = age_group, y = gender, fill = prescriptions)) +
    geom_tile() +
    scale_fill_gradient(low = "white", high = "coral", labels = scales::comma) +
    labs(
      title = "Prescription Heatmap: Gender by Age Group (2024)",
      x = "Age Group",
      y = "Gender",
      fill = "Prescriptions"
    ) +
    theme_minimal() +
    theme(
      plot.title = element_text(hjust = 0.5, size = 14, face = "bold"),
      axis.text.x = element_text(angle = 45, hjust = 1, size = 8)
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
  
  # 3.1 Horizontal bar chart for drug groups
  cat("\nCreating drug group bar chart...\n")
  p1 <- create_drug_group_bar_chart(data)
  export_to_png(p1, "drug_group_comparison.png")
  
  # 3.2 Grouped bar chart for gender comparison
  cat("\nCreating gender comparison chart...\n")
  p2 <- create_gender_comparison_chart(data)
  export_to_png(p2, "gender_comparison.png")
  
  # 3.3 Stacked bar chart for age distribution
  cat("\nCreating age distribution chart...\n")
  p3 <- create_age_distribution_chart(data)
  export_to_png(p3, "age_distribution.png")
  
  # 3.4 Drug group by period heatmap
  cat("\nCreating drug period heatmap...\n")
  p4 <- create_drug_period_heatmap(data)
  export_to_png(p4, "drug_period_heatmap.png")
  
  # 3.5 Demographic heatmap
  cat("\nCreating demographic heatmap...\n")
  p5 <- create_demographic_heatmap(data)
  export_to_png(p5, "demographic_heatmap.png")
  
  cat("\nComparative analysis charts complete!\n")
}

if (!interactive()) {
  main()
}
