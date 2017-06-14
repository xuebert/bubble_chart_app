# server.R

rm(list=ls())

source("support_functions/load_library_data.R")
source("support_functions/bubble_chart.R")
source("support_functions/legend_col.R")

shinyServer(function(input, output) {
  
  #################### setup ####################
  # get data functions
  get_bubble_sizes <- reactive({
    if (is.null(input$size_file)) {
      filename = "example_bubble_sizes.csv"
    } else {
      filename = input$size_file$name
    }
    bubble_sizes = read.csv(filename)
  })
  
  get_bubble_colors <- reactive({
    if (is.null(input$color_file)) {
      filename = "example_bubble_colors.csv"
    } else {
      filename = input$color_file$name
    }
    bubble_colors = read.csv(filename)
  })
  
  get_show_legend <- reactive({input$show_legend})
  get_main_title <- reactive({input$main_title})
  get_label_resize <- reactive({as.numeric(input$label_resize)})
  get_scale_factor <<- reactive({as.numeric(input$scale_factor)})
  get_color <<- reactive({input$color})
  get_legend_name_size <<- reactive({input$legend_name_size})
  get_legend_name_color <<- reactive({input$legend_name_color})
  
  # get data function
  get_data <- reactive({
    if (is.null(input$data_file)) { # load from size and color files
      bubble_colors = get_bubble_colors()
      bubble_sizes = get_bubble_sizes()
    } else {
      filename = input$data_file$name
      return_list = load_library_data(filename = filename)
      bubble_colors = return_list[[1]]
      bubble_sizes = return_list[[2]]
    }
    
    # reorder AA_names
    get_AA_reorder <<- reactive({
      
      AA_names = colnames(bubble_colors)
      switch(input$AA_order_type, 
             size = AA_reorder <- order(colMeans(bubble_sizes) + rowMeans(bubble_sizes), decreasing = input$decreasing),
             color = AA_reorder <- order(colMeans(bubble_colors) + rowMeans(bubble_colors), decreasing = input$decreasing),
             alpha = AA_reorder <- order(AA_names, decreasing = input$decreasing),
             unsorted = AA_reorder <- match(colnames(bubble_colors_unsorted), colnames(bubble_colors)))
    })
    
    # storage of original (unsorted) data
    bubble_colors_unsorted = bubble_colors
    bubble_sizes_unsorted = bubble_sizes
    
    # reorder matrices
    AA_reorder = get_AA_reorder()
    bubble_colors = bubble_colors[AA_reorder, AA_reorder]
    bubble_sizes = bubble_sizes[AA_reorder, AA_reorder]
    
    list(bubble_colors, bubble_sizes)
  })
  
  #################### plotting ####################
  
  # interface to put plots to output
  output$plots <- renderUI({
    plot_output_list <- lapply(1, function(i) {
      plotname <- paste("plot", i, sep="")
      plotOutput(plotname, height = 800, width = 800)
    })
    
    # Convert the list to a tagList - this is necessary for the list of items
    # to display properly.
    do.call(tagList, plot_output_list)
  })
  
  # this function makes the plots
  make_plot <- function() {
    
    return_list = get_data()
    bubble_colors = return_list[[1]]
    bubble_sizes = return_list[[2]]
    
    bubble_chart(bubble_sizes = bubble_sizes * get_scale_factor(), bubble_colors = bubble_colors, show_legend = get_show_legend(), main_title = get_main_title(), label_resize = get_label_resize(), selected_color = get_color(), legend_name_size = get_legend_name_size(), legend_name_color = get_legend_name_color())
  }
  
  # Need local so that each item gets its own number. Without it, the value
  # of i in the renderPlot() will be the same across all instances, because
  # of when the expression is evaluated.
  local({
    
    plotname <- "plot1"
    
    output[[plotname]] <- 
      renderPlot({
        make_plot()
      })
  })
  
  #################### table ####################
  # make output table
  output_table <- observe({
    if (input$table_output == 0) return()
    
    return_list = get_data()
    bubble_colors = return_list[[1]]
    bubble_sizes = return_list[[2]]
    
    # write_table = do.call(rbind, lapply(1:4, function (i) get_table_writeout(i)))
    write.table(bubble_colors, file = paste(input$outfile, "_color_table.csv", sep = ""), sep = ",", quote = F, col.names = T)
    write.table(bubble_sizes, file = paste(input$outfile, "_size_table.csv", sep = ""), sep = ",", quote = F, col.names = T)
  })
  
  #################### output figure ####################
  # make figure
  output_graphic <- observe({
    if ((input$output_figure_check == 0) | (input$graph_output == 0)) return()
    
    # only output file when button is pressed (I don't get this logic)
    isolate({
      # store number form of outfile_format
      outfile_format = as.numeric(input$outfile_format)
      
      # get figure print out function
      figure_func_list = list("pdf" = pdf, "png" = png, "jpg" = jpeg, "bmp" = bmp)
      figure_func <- figure_func_list[[outfile_format]]
      
      # pdf (single file with multi pages)
      if (outfile_format == 1) { 
        
        pdf(paste(input$outfile, ".pdf", sep = ""), width = input$w, height = input$h)
        make_plot()
        dev.off()
        
      } else { # png jpg and bmp
        
        figure_func(paste(input$outfile, ".", names(figure_func_list)[[as.numeric(input$outfile_format)]], sep = ""), width = input$w, height = input$h, units = "in", res = 300)
        make_plot()
        dev.off()
      }
    })
  })
})