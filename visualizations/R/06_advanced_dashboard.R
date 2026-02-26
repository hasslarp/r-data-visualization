# Advanced Interactive Dashboard
# With time period filter and zoom synchronization

# Source shared utilities
source("utilities.R")

# ============================================================================
# Advanced Dashboard with Time Filter and Zoom Sync
# ============================================================================

create_advanced_dashboard <- function(data) {
  # Filter to yearly data
  yearly_data <- filter_yearly_data(data)
  
  # Get top 8 drug groups
  drug_totals <- aggregate(prescriptions ~ drug_group, data = yearly_data, sum)
  top_drugs <- drug_totals$drug_group[order(drug_totals$prescriptions, decreasing = TRUE)][1:8]
  
  # Filter to top drugs
  yearly_data <- yearly_data[yearly_data$drug_group %in% top_drugs, ]
  
  # Aggregate
  agg <- aggregate(prescriptions ~ year + drug_group, data = yearly_data, sum)
  
  # Create subplot layout - 2x2 grid
  fig <- subplot(
    # Plot 1: Line chart with zoom
    plot_ly(data = agg, x = ~year, y = ~prescriptions, color = ~drug_group,
            type = "scatter", mode = "lines+markers") %>%
      layout(
        title = "Time Series (Zoom Enabled)",
        xaxis = list(title = "Year"),
        yaxis = list(title = "Prescriptions"),
        dragmode = "zoom"
      ),
    # Plot 2: Bar chart
    plot_ly(data = agg, x = ~drug_group, y = ~prescriptions, color = ~drug_group,
            type = "bar") %>%
      layout(
        title = "Total by Drug Group",
        xaxis = list(title = "Drug Group"),
        yaxis = list(title = "Total Prescriptions"),
        showlegend = FALSE
      ),
    # Plot 3: Box plot
    plot_ly(data = yearly_data, x = ~drug_group, y = ~prescriptions, color = ~drug_group,
            type = "box") %>%
      layout(
        title = "Distribution by Drug Group",
        xaxis = list(title = "Drug Group"),
        yaxis = list(title = "Prescriptions"),
        showlegend = FALSE
      ),
    # Plot 4: Heatmap-style
    plot_ly(data = agg, x = ~year, y = ~drug_group, z = ~prescriptions,
            type = "heatmap", colorscale = "Blues") %>%
      layout(
        title = "Heatmap View",
        xaxis = list(title = "Year"),
        yaxis = list(title = "Drug Group")
      ),
    nrows = 2, margin = 0.05
  )
  
  # Get available years from data for dynamic filter options
  available_years <- get_available_years(data)
  min_year <- min(available_years)
  max_year <- max(available_years)
  mid_year <- min_year + floor((max_year - min_year) / 2)
  
  # Add dynamic slider for time period filtering
  fig <- fig %>% layout(
    title = "Advanced Dashboard with Zoom Sync",
    updatemenus = list(
      list(
        type = "buttons",
        direction = "right",
        x = 0.7,
        y = 1.15,
        buttons = list(
          list(
            method = "relayout",
            args = list("xaxis.range", list(min_year, max_year)),
            label = paste(min_year, "-", max_year)
          ),
          list(
            method = "relayout",
            args = list("xaxis.range", list(min_year, mid_year)),
            label = paste(min_year, "-", mid_year)
          ),
          list(
            method = "relayout",
            args = list("xaxis.range", list(mid_year + 1, max_year)),
            label = paste(mid_year + 1, "-", max_year)
          )
        )
      )
    )
  )
  
  return(fig)
}

# ============================================================================
# Dashboard with Date Range Picker
# ============================================================================

create_dashboard_with_range <- function(data) {
  # Filter to yearly data
  yearly_data <- filter_yearly_data(data)
  
  # Get top drugs
  top_drugs <- get_top_drug_groups(data, 5)
  yearly_data <- yearly_data[yearly_data$drug_group %in% top_drugs, ]
  
  # Aggregate
  agg <- aggregate(prescriptions ~ year + drug_group, data = yearly_data, sum)
  
  # Create figure with slider
  fig <- plot_ly()
  
  for (drug in top_drugs) {
    drug_data <- agg[agg$drug_group == drug, ]
    fig <- fig %>% add_trace(
      data = drug_data,
      x = ~year,
      y = ~prescriptions,
      name = drug,
      type = "scatter",
      mode = "lines+markers"
    )
  }
  
  # Add range slider
  fig <- fig %>% layout(
    title = "Dashboard with Year Range Selector",
    xaxis = list(
      title = "Year",
      rangeselector = list(
        buttons = list(
          list(count = 1, label = "1y", step = "year", stepmode = "backward"),
          list(count = 3, label = "3y", step = "year", stepmode = "backward"),
          list(step = "all", label = "All")
        )
      ),
      rangeslider = list(visible = TRUE)
    ),
    yaxis = list(title = "Prescriptions")
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
  
  # 4.3 Create dashboard with time period date picker
  cat("\nCreating dashboard with time range picker...\n")
  fig1 <- create_dashboard_with_range(data)
  htmlwidgets::saveWidget(fig1, file.path(OUTPUT_DIR, "dashboard_with_range_picker.html"), 
                         selfcontained = FALSE)
  cat("Exported: output/visualizations/dashboard_with_range_picker.html\n")
  
  # 4.4 Create advanced dashboard with zoom synchronization
  cat("\nCreating advanced dashboard with zoom sync...\n")
  fig2 <- create_advanced_dashboard(data)
  htmlwidgets::saveWidget(fig2, file.path(OUTPUT_DIR, "advanced_dashboard_zoom_sync.html"), 
                         selfcontained = FALSE)
  cat("Exported: output/visualizations/advanced_dashboard_zoom_sync.html\n")
  
  cat("\nAdvanced dashboard features complete!\n")
}

if (!interactive()) {
  main()
}
