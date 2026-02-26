## Why

The project currently lacks visualization capabilities for analyzing the Swedish prescription data. With pharmaceutical sales data spanning multiple years (2020-2024), drug groups, gender, and age demographics, visual analysis would significantly improve insight discovery and reporting. Adding R-based data visualization will enable time series trends, comparative analysis, and interactive dashboards.

## What Changes

- Add R visualization scripts using ggplot2 and plotly libraries
- Create time series plots for prescription trends by drug group, gender, and age
- Add comparative bar charts for cross-sectional analysis
- Implement interactive HTML visualizations for dynamic exploration
- Create summary statistics visualization (histograms, box plots)
- Add data export capabilities for visualization outputs (PNG, HTML)

## Capabilities

### New Capabilities
- `time-series-visualization`: Time series plots showing prescription trends over monthly/yearly periods, filterable by drug group, gender, and age
- `comparative-analysis-charts`: Bar charts and heatmaps comparing prescriptions across categories (drug groups, gender, age groups)
- `interactive-dashboards`: Plotly-based interactive HTML dashboards allowing dynamic filtering and exploration
- `statistical-visualizations`: Distribution plots (histograms, box plots) showing data distributions and outliers

### Modified Capabilities
- None - this is a new capability set

## Impact

- New R scripts in `visualizations/` directory
- Dependencies: ggplot2, plotly, htmlwidgets R packages
- Outputs: PNG images and interactive HTML files in `output/visualizations/`
- Integration with existing data loading pipeline
