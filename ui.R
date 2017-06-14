rm(list=ls())

library(shiny)

shinyUI(
  fluidPage(
    titlePanel("Bubble chart app with SAMDI peptide array data"),
    
    fluidRow(
      column(4, 
             # sidebarLayout(
             
             # load data
             wellPanel(
               titlePanel("File inputs and outputs"),
               fileInput("size_file", "Choose size file"),
               fileInput("color_file", "Choose color file"),
               fileInput("data_file", "Choose data file (overrides size and color file)"),
               textInput("outfile", "Choose output file name", value = "example_output", placeholder = "example_output"),
               actionButton("table_output", label = "Make table file"),
               
               checkboxInput('output_figure_check', 'Output figure?', FALSE),
               conditionalPanel(
                 
                 condition = "input.output_figure_check == true",
                 selectInput("outfile_format", label = h3("Figure format"), choices = list("pdf" = 1, "png" = 2, "jpg" = 3, "bmp" = 4), selected = 1),
                 strong("Figure size (inches):"),
                 sliderInput(inputId="w", label = "width:", min=3, max=20, value=10, width=100, ticks=F),
                 sliderInput(inputId="h", label = "height:", min=3, max=20, value=10, width=100, ticks=F),
                 br(),
                 actionButton("graph_output", label = "Make figure file")
               )
             )
      ),
      
      column(4, 
             # plotting parameters
             wellPanel(
               titlePanel("Plotting parameters"),
               
               checkboxInput('show_legend', 'Show legend?', TRUE),
               radioButtons("AA_order_type", label = h3("Amino acid order"),
                            choices = list("By bubble size" = "size", "By bubble color" = "color", "Alphabetical" = "alpha", "Unsorted" = "unsorted"), selected = "unsorted"),
               radioButtons("decreasing", label = h3("Order of amino acids"),
                            choices = list("Lowest to highest" = F, "Highest to lowest" = T), selected = F)
               
               
             )
      ),
      
      column(4, 
             wellPanel(
               titlePanel("Tinkering parameters"),
               
               textInput("scale_factor", label = "Bubble size scaling factor", value = "1", placeholder = "1"),
               textInput("label_resize", label = "Amino acid label resizing", value = "1", placeholder = "1"),
               selectInput("color", label = h3("Select color scale"), choices = list("Red" = "red", "Blue" = "blue", "Green" = "green", "Orange" = "orange", "Purple" = "purple"), selected = "red"),
               textInput("legend_name_size", label = "Legend label for size", value = "Size", placeholder = "Size"),
               textInput("legend_name_color", label = "Legend label for color", value = "Color", placeholder = "Color")
             )
      )),
    
    mainPanel(
      # This is the dynamic UI for the plots
      uiOutput("plots")
      
    )
  )
)
# ))