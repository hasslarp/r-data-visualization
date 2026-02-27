## Context

The R-analyze-data project processes Swedish pharmaceutical prescription data from CSV files. The data contains prescription values by drug group (varugrupp), gender (kön), age group (åldersgrupp), and time period. Currently, the project lacks visualization capabilities for exploring this data visually.

## Goals / Non-Goals

**Goals:**
- Add time series visualization for prescription trends over monthly/yearly periods
- Add comparative analysis charts for cross-category comparisons
- Add interactive HTML dashboards using Plotly
- Add statistical distribution visualizations

**Non-Goals:**
- Real-time data ingestion from external APIs
- User authentication/authorization for dashboards
- Mobile-optimized visualizations
- PDF report generation (export to PNG/HTML only)

## Decisions

### 1. Visualization Library Selection: ggplot2 + plotly over base R graphics
**Rationale**: ggplot2 provides a consistent grammar of graphics making code maintainable. plotly adds interactivity on top of ggplot2 objects. Base R graphics are harder to maintain and customize.

**Alternative Considered**: Using only base R graphics - rejected due to limited customization and harder to create interactive outputs.

### 2. Output Format: PNG for static, HTML for interactive
**Rationale**: PNG is suitable for reports and presentations. HTML allows interactive exploration with tooltips, zoom, and filtering.

**Alternative Considered**: PDF output - rejected due to larger file sizes and less common use case.

### 3. Directory Structure: visualizations/ folder in project root
**Rationale**: Separates visualization code from data processing logic. Easy to locate all visualization-related files.

**Alternative Considered**: Putting visualizations in scripts/ - rejected as it mixes different script purposes.

### 4. Data Integration: Reuse existing data loading pipeline
**Rationale**: Avoids duplicating data loading logic. Visualizations should consume preprocessed data from existing pipeline.

## Risks / Trade-offs

- **Large datasets may slow down rendering** → Mitigation: Implement data aggregation/sampling for visualizations showing large time ranges
- **Plotly dependency increases bundle size** → Mitigation: Only load plotly when interactive visualizations are needed
- **Encoding issues with Swedish characters in axis labels** → Mitigation: Use UTF-8 encoding consistently and test with actual data
- **Browser compatibility for interactive HTML** → Mitigation: Use widely supported plotly features; provide fallback static PNG versions
