# Interactive Dashboards
# For Swedish Prescription Data Analysis

# Source shared utilities
source("utilities.R")

# ============================================================================
# Interactive Dashboard Functions
# ============================================================================

#' Create interactive Plotly dashboard with filters
create_interactive_dashboard <- function(data) {
  # Filter to yearly data
  yearly_data <- filter_yearly_data(data)
  
  # Get unique values for dropdowns
  drug_groups <- sort(unique(yearly_data$drug_group))
  years <- sort(unique(yearly_data$year))
  genders <- sort(unique(yearly_data$gender))
  age_groups <- sort(unique(yearly_data$age_group))
  
  # Create the base plotly figure
  # We'll create a line chart showing trends
  
  # Aggregate data for default view
  default_agg <- aggregate(prescriptions ~ year + drug_group, 
                           data = yearly_data, sum)
  
  # Get top 5 drugs for default
  top_drugs <- get_top_drug_groups(data, 5)
  default_agg <- default_agg[default_agg$drug_group %in% top_drugs, ]
  
  # Create plotly figure
  fig <- plot_ly()
  
  # Add a trace for each drug group
  for (drug in top_drugs) {
    drug_data <- default_agg[default_agg$drug_group == drug, ]
    fig <- fig %>% add_trace(
      data = drug_data,
      x = ~year,
      y = ~prescriptions,
      name = drug,
      type = "scatter",
      mode = "lines+markers"
    )
  }
  
  # Update layout
  fig <- fig %>% layout(
    title = "Prescription Trends by Drug Group",
    xaxis = list(title = "Year"),
    yaxis = list(title = "Prescriptions"),
    hovermode = "closest"
  )
  
  return(fig)
}

#' Create interactive bar chart with dropdown filter
create_drug_filter_dashboard <- function(data) {
  yearly_data <- filter_yearly_data(data)
  
  # Get top 10 drug groups
  drug_totals <- aggregate(prescriptions ~ drug_group, data = yearly_data, sum)
  top_drugs <- drug_totals$drug_group[order(drug_totals$prescriptions, decreasing = TRUE)][1:10]
  
  # Filter to top drugs
  yearly_data <- yearly_data[yearly_data$drug_group %in% top_drugs, ]
  
  # Aggregate
  agg <- aggregate(prescriptions ~ year + drug_group, data = yearly_data, sum)
  
  # Create plotly figure with animation
  fig <- plot_ly()
  
  for (drug in top_drugs) {
    drug_data <- agg[agg$drug_group == drug, ]
    fig <- fig %>% add_trace(
      data = drug_data,
      x = ~year,
      y = ~prescriptions,
      name = drug,
      type = "bar",
      visible = TRUE
    )
  }
  
  # Create dropdown menu
  fig <- fig %>% layout(
    title = "Prescriptions by Drug Group (Top 10)",
    xaxis = list(title = "Year"),
    yaxis = list(title = "Prescriptions"),
    updatemenus = list(
      list(
        buttons = lapply(top_drugs, function(drug) {
          list(
            method = "update",
            args = list(list(visible = sapply(top_drugs, function(d) d == drug)),
                       list(title = paste("Prescriptions:", drug))),
            label = drug
          )
        })
      )
    )
  )
  
  return(fig)
}

# ============================================================================
# Main Execution
# ============================================================================

main <- function() {
  cat("Loading prescription data...\n")
  data <- load_prescription_data()
  cat("Data loaded:", nrow(data), "rows\n")
  
  # 4.1 Create base Plotly dashboard with default view
  cat("\nCreating interactive dashboard...\n")
  fig1 <- create_interactive_dashboard(data)
  htmlwidgets::saveWidget(fig1, file.path(OUTPUT_DIR, "interactive_dashboard.html"), 
                          selfcontained = FALSE)
  cat("Exported: output/visualizations/interactive_dashboard.html\n")
  
  # 4.2 Create dashboard with drug group dropdown filter
  cat("\nCreating dashboard with filters...\n")
  fig2 <- create_drug_filter_dashboard(data)
  htmlwidgets::saveWidget(fig2, file.path(OUTPUT_DIR, "dashboard_with_filters.html"), 
                          selfcontained = FALSE)
  cat("Exported: output/visualizations/dashboard_with_filters.html\n")
  
  cat("\nInteractive dashboards complete!\n")
}

if (!interactive()) {
  main()
}
