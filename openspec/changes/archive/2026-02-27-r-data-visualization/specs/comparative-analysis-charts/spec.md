## ADDED Requirements

### Requirement: Comparative bar charts
The system SHALL generate bar charts comparing prescription values across different categories such as drug groups, gender, and age groups.

#### Scenario: Compare drug groups
- **WHEN** user selects drug group comparison
- **THEN** system displays a horizontal bar chart showing prescription values for each drug group

#### Scenario: Compare by gender
- **WHEN** user selects gender comparison
- **THEN** system displays grouped bar chart showing prescriptions for each gender, grouped by drug category or time period

#### Scenario: Compare by age group
- **WHEN** user selects age group comparison
- **THEN** system displays stacked bar chart showing prescription distribution across age groups

### Requirement: Heatmap visualization
The system SHALL generate heatmaps showing prescription intensity across two categorical dimensions.

#### Scenario: Generate drug group by period heatmap
- **WHEN** user requests heatmap visualization
- **THEN** system displays a heatmap with drug groups on one axis and time periods on the other, with color intensity representing prescription values

#### Scenario: Gender and age group cross-analysis
- **WHEN** user requests demographic heatmap
- **THEN** system displays a heatmap with gender on one axis and age groups on the other, showing prescription distribution
