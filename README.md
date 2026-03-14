# Vancouver Food Programs Dashboard (Shiny for R)

This repository contains my individual assignment for DSCI 532. It is a simplified Shiny for R re-implementation of our original group project, which was built in Shiny for Python.

The app helps users explore free and low-cost food programs in Vancouver by filtering programs by meal cost and local area. It presents the results through reactive summary metrics, a bar chart, and a table of filtered programs.

## Original group project

This individual app is based on the original group project:

**UBC-MDS/DSCI-532_2026_22_Vancouver-LC_Food-Programs**

The original dashboard focused on helping Vancouver residents explore food programs using filters, summary metrics, and a map interface. This individual version keeps the same overall topic and filtering idea, but uses Shiny for R and a simplified non-map dashboard design.

## Data

This app uses the City of Vancouver Free and Low-Cost Food Programs dataset stored locally in:

`data/food_program_data.csv`

## Features

This app includes:

- 2 input components
  - Meal Cost
  - Local Area
- 1 reactive calculation
  - a filtered dataset based on the selected inputs
- multiple output components
  - summary KPI cards
  - a bar chart
  - an interactive data table

## Repository structure

```text
.
├── app.R
├── README.md
├── manifest.json
└── data/
    └── food_program_data.csv
```

## How to configure and run the app locally

1. Clone the repository
```bash
git clone <your-repo-url>
cd <your-repo-name>
```
2. Open the project in RStudio

Open the project folder in RStudio.

3. click run app in RStudio

## Note on metric differences from the group project

The summary metrics in this individual Shiny for R app may not exactly match the values shown in our original group project. This is because the group project calculates its dashboard metrics after filtering the dataset to keep only records with valid latitude and longitude values, since those records are needed for the map view. In contrast, this individual version does not use a map and may calculate summary statistics from a slightly different subset of the data. In addition, the original group project reads data directly from the Vancouver Open Data API, while this individual version uses the local food_program_data.csv file stored in the repository. These differences in data source and filtering logic can lead to small differences in totals and percentages.

## Group Project Reference

This individual assignment is based on the group project: 

## Deployment

The live application is deployed on Posit Connect Cloud at: [Your Deployment URL]