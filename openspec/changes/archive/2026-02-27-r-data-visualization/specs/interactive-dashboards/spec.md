## ADDED Requirements

### Requirement: Interactive Plotly dashboard
The system SHALL generate interactive HTML dashboards using Plotly that allow users to explore data dynamically.

#### Scenario: Load interactive dashboard
- **WHEN** user opens the interactive HTML dashboard
- **THEN** dashboard loads with default view showing overall prescription trends

#### Scenario: Filter by drug group
- **WHEN** user selects a drug group from dropdown filter
- **THEN** all charts update to show data for the selected drug group only

#### Scenario: Filter by time period
- **WHEN** user selects a time range using the date picker
- **THEN** all charts update to show data within the selected range

#### Scenario: Zoom into chart
- **WHEN** user zooms into a specific area of a chart
- **THEN** other linked charts also zoom to show corresponding data

#### Scenario: View data tooltips
- **WHEN** user hovers over a data point
- **THEN** a tooltip displays exact values for that point

### Requirement: Dashboard export
The system SHALL allow users to export the interactive dashboard.

#### Scenario: Export as standalone HTML
- **WHEN** user clicks export button
- **THEN** system generates a self-contained HTML file with all data embedded that can be shared and viewed offline
