library(shiny)
library(dplyr)
library(ggplot2)
library(readr)
library(bslib)
library(DT)

food_data <- read_delim("data/food_program_data.csv", delim = ";", show_col_types = FALSE)

food_data <- food_data |>
  rename(
    program_name = `Program Name`,
    description = Description,
    program_status = `Program Status`,
    organization_name = `Organization Name`,
    local_areas = `Local Areas`,
    provides_meals = `Provides Meals`,
    provides_hampers = `Provides Hampers`,
    delivery_available = `Delivery Available`,
    takeout_available = `Takeout Available`,
    wheelchair_accessible = `Wheelchair Accessible`,
    meal_cost = `Meal Cost`,
    location_address = `Location Address`,
    latitude = Latitude,
    longitude = Longitude
  )

meal_cost_choices <- c("All", "Free", "Low-cost")
area_choices <- c("All", sort(unique(na.omit(food_data$local_areas))))

ui <- fluidPage(
  theme = bs_theme(
    version = 5,
    bg = "#F3F4F6",
    fg = "#1F2937",
    base_font = font_google("Inter")
  ),
  
  tags$head(
    tags$style(HTML("
      body {
        background-color: #F3F4F6;
      }

      .app-shell {
        display: flex;
        min-height: 100vh;
        gap: 18px;
        padding: 18px;
      }

      .sidebar-panel {
        width: 290px;
        background: linear-gradient(180deg, #1F2937 0%, #111827 100%);
        border-radius: 18px;
        padding: 24px 22px;
        color: white;
        box-shadow: 0 8px 24px rgba(0,0,0,0.12);
        flex-shrink: 0;
      }

      .sidebar-title {
        font-size: 2.1rem;
        font-weight: 800;
        line-height: 1.1;
        margin-bottom: 26px;
      }

      .sidebar-divider {
        border-top: 1px solid rgba(255,255,255,0.18);
        margin: 18px 0 26px 0;
      }

      .filter-label {
        font-size: 1.1rem;
        font-weight: 700;
        margin-bottom: 10px;
        color: #E5E7EB;
      }

      .sidebar-panel .form-control,
      .sidebar-panel .selectize-input {
        border-radius: 10px !important;
        min-height: 46px;
        border: none !important;
        box-shadow: none !important;
      }

      .main-panel {
        flex: 1;
      }

      .top-nav {
        margin-bottom: 18px;
      }

      .nav-pill {
        display: inline-block;
        background: #3B82F6;
        color: white;
        font-weight: 700;
        padding: 10px 18px;
        border-radius: 10px;
        margin-right: 10px;
      }

      .nav-text {
        display: inline-block;
        color: #3B82F6;
        font-weight: 700;
        padding: 10px 6px;
      }

      .kpi-row {
        display: grid;
        grid-template-columns: repeat(3, 1fr);
        gap: 20px;
        margin-bottom: 20px;
      }

      .kpi-card {
        border-radius: 18px;
        padding: 22px 26px;
        color: white;
        min-height: 150px;
        box-shadow: 0 8px 22px rgba(0,0,0,0.08);
      }

      .kpi-blue {
        background: #58A5D1;
      }

      .kpi-yellow {
        background: #EDBF45;
      }

      .kpi-red {
        background: #E1726C;
      }

      .kpi-label {
        font-size: 1.1rem;
        font-weight: 500;
        opacity: 0.95;
        margin-bottom: 14px;
      }

      .kpi-value {
        font-size: 2.5rem;
        font-weight: 800;
        line-height: 1;
      }

      .content-row {
        display: grid;
        grid-template-columns: 2fr 1fr;
        gap: 20px;
        margin-bottom: 20px;
      }

      .card-panel {
        background: white;
        border-radius: 18px;
        box-shadow: 0 8px 22px rgba(0,0,0,0.06);
        overflow: hidden;
      }

      .card-header-custom {
        font-size: 1.35rem;
        font-weight: 700;
        padding: 16px 18px;
        border-bottom: 1px solid #E5E7EB;
        background: #FFFFFF;
      }

      .card-body-custom {
        padding: 18px;
      }

      .summary-item {
        margin-bottom: 18px;
      }

      .summary-label {
        font-size: 0.95rem;
        color: #6B7280;
        margin-bottom: 6px;
      }

      .summary-value {
        font-size: 1.55rem;
        font-weight: 800;
        color: #1F2937;
      }

      .table-card {
        margin-top: 0;
      }

      .dataTables_wrapper {
        padding: 6px 6px 10px 6px;
      }

      table.dataTable thead th {
        background-color: #F3F4F6;
        color: #1F2937;
        font-weight: 700;
        border-bottom: none !important;
      }

      table.dataTable tbody td {
        vertical-align: top;
      }

      .dataTables_wrapper .dataTables_paginate .paginate_button.current {
        background: #3B82F6 !important;
        color: white !important;
        border: none !important;
        border-radius: 8px !important;
      }

      @media (max-width: 1100px) {
        .kpi-row {
          grid-template-columns: 1fr;
        }

        .content-row {
          grid-template-columns: 1fr;
        }

        .app-shell {
          flex-direction: column;
        }

        .sidebar-panel {
          width: 100%;
        }
      }
    "))
  ),
  
  div(
    class = "app-shell",
    
    div(
      class = "sidebar-panel",
      div(class = "sidebar-title", HTML("Vancouver<br>Food Programs")),
      div(class = "sidebar-divider"),
      
      div(class = "filter-label", "Meal cost"),
      selectInput("meal_cost", NULL, choices = meal_cost_choices, selected = "All"),
      
      div(class = "sidebar-divider"),
      
      div(class = "filter-label", "Local Area"),
      selectInput("area", NULL, choices = area_choices, selected = "All")
    ),
    
    div(
      class = "main-panel",
      
      div(
        class = "top-nav",
        span(class = "nav-pill", "Dashboard")
      ),
      
      div(
        class = "kpi-row",
        div(
          class = "kpi-card kpi-blue",
          div(class = "kpi-label", "Total Programs"),
          div(class = "kpi-value", textOutput("total_programs"))
        ),
        div(
          class = "kpi-card kpi-yellow",
          div(class = "kpi-label", "Free Programs (%)"),
          div(class = "kpi-value", textOutput("free_pct"))
        ),
        div(
          class = "kpi-card kpi-red",
          div(class = "kpi-label", "Accessibility (%)"),
          div(class = "kpi-value", textOutput("accessible_pct"))
        )
      ),
      
      div(
        class = "content-row",
        
        div(
          class = "card-panel",
          div(class = "card-header-custom", "Programs by Local Area"),
          div(class = "card-body-custom",
              plotOutput("program_plot", height = "420px"))
        ),
        
        div(
          class = "card-panel",
          div(class = "card-header-custom", "Program Summary"),
          div(
            class = "card-body-custom",
            div(
              class = "summary-item",
              div(class = "summary-label", "Programs with Hampers"),
              div(class = "summary-value", textOutput("hamper_count"))
            ),
            div(
              class = "summary-item",
              div(class = "summary-label", "Programs with Delivery"),
              div(class = "summary-value", textOutput("delivery_count"))
            ),
            div(
              class = "summary-item",
              div(class = "summary-label", "Programs with Takeout"),
              div(class = "summary-value", textOutput("takeout_count"))
            ),
            div(
              class = "summary-item",
              div(class = "summary-label", "Most common area"),
              div(class = "summary-value", textOutput("top_area"))
            )
          )
        )
      ),
      
      div(
        class = "card-panel table-card",
        div(class = "card-header-custom", "Filtered Programs"),
        div(class = "card-body-custom",
            DTOutput("program_table"))
      )
    )
  )
)

server <- function(input, output, session) {
  
  filtered_data <- reactive({
    dff <- food_data
    
    if (input$meal_cost != "All") {
      if (input$meal_cost == "Free") {
        dff <- dff |>
          filter(tolower(as.character(meal_cost)) == "free")
      } else {
        dff <- dff |>
          filter(
            grepl("low cost", tolower(as.character(meal_cost))) |
              grepl("^\\$", as.character(meal_cost))
          )
      }
    }
    
    if (input$area != "All") {
      dff <- dff |>
        filter(local_areas == input$area)
    }
    
    dff
  })
  
  output$total_programs <- renderText({
    nrow(filtered_data())
  })
  
  output$free_pct <- renderText({
    dff <- filtered_data()
    if (nrow(dff) == 0) return("0%")
    pct <- mean(tolower(as.character(dff$meal_cost)) == "free", na.rm = TRUE)
    paste0(round(pct * 100, 1), "%")
  })
  
  output$accessible_pct <- renderText({
    dff <- filtered_data()
    if (nrow(dff) == 0) return("0%")
    pct <- mean(tolower(as.character(dff$wheelchair_accessible)) == "yes", na.rm = TRUE)
    paste0(round(pct * 100, 1), "%")
  })
  
  output$hamper_count <- renderText({
    dff <- filtered_data()
    sum(tolower(as.character(dff$provides_hampers)) == "yes", na.rm = TRUE)
  })
  
  output$delivery_count <- renderText({
    dff <- filtered_data()
    sum(tolower(as.character(dff$delivery_available)) == "yes", na.rm = TRUE)
  })
  
  output$takeout_count <- renderText({
    dff <- filtered_data()
    sum(tolower(as.character(dff$takeout_available)) == "yes", na.rm = TRUE)
  })
  
  output$top_area <- renderText({
    dff <- filtered_data()
    if (nrow(dff) == 0) return("None")
    
    area_count <- dff |>
      count(local_areas, sort = TRUE)
    
    area_count$local_areas[1]
  })
  
  output$program_plot <- renderPlot({
    dff <- filtered_data()
    
    if (nrow(dff) == 0) {
      plot.new()
      text(0.5, 0.5, "No programs match the selected filters.")
      return()
    }
    
    dff |>
      count(local_areas, sort = TRUE) |>
      ggplot(aes(x = reorder(local_areas, n), y = n)) +
      geom_col(fill = "#58A5D1") +
      coord_flip() +
      labs(
        x = "Local Area",
        y = "Number of Programs"
      ) +
      theme_minimal(base_size = 14) +
      theme(
        panel.grid.minor = element_blank(),
        panel.grid.major.y = element_blank(),
        plot.background = element_rect(fill = "white", color = NA)
      )
  })
  
  output$program_table <- renderDT({
    datatable(
      filtered_data() |>
        select(
          program_name,
          organization_name,
          local_areas,
          meal_cost,
          wheelchair_accessible
        ),
      rownames = FALSE,
      options = list(
        pageLength = 8,
        scrollX = TRUE,
        autoWidth = TRUE
      )
    )
  })
}

shinyApp(ui, server)