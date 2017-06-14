bubble_chart <- function(bubble_colors, bubble_sizes, main_title = "", xlab = "", ylab = "", x_axis_opt = NULL, y_axis_opt = NULL, show_legend = T, label_resize = 1, selected_color = "red", legend_name_size = "Size", legend_name_color = "Color") {
  
  # colors and sizes are assumed to be between 0-1 and linearly scale within color_scale_list
  load("support_functions/color_scale.RData")
  color_scale = color_scale_list[[selected_color]]
  
  if (show_legend) {
    layout(matrix(c(rep(1,9), 2), nrow = 1))
  }
  
  x_axis_opt = list(side = 3, at = 0:(ncol(bubble_sizes)+1), labels = c("", colnames(bubble_sizes), ""), cex.axis = label_resize * 2)
  y_axis_opt = list(side = 2, at = 0:(ncol(bubble_sizes)+1), labels = c("", colnames(bubble_sizes), ""), cex.axis = label_resize * 2)
  
  # initialize common plot parameters
  x_axis = c(1, ncol(bubble_colors))
  y_axis = c(1, nrow(bubble_colors))
  
  y_grid = rep(1:nrow(bubble_colors), each = ncol(bubble_colors))
  x_grid = rep(1:ncol(bubble_colors), nrow(bubble_colors))
  
  # map bubble_colors to the proper colors
  mapped_colors = color_scale[matrix(t(round(bubble_colors * (length(color_scale) - 1))), ncol = 1, byrow = T) + 1]
  
  p <- symbols(x = x_grid, y = rev(y_grid), circles = (matrix(t(bubble_sizes), ncol = 1, byrow = T)/pi)^0.5, bg = mapped_colors, fg = "black", xlim = x_axis, ylim = y_axis, inches = F, xlab = xlab, ylab = ylab, xaxt = "n", yaxt = "n", cex = 2, main = main_title)
  
  if (!is.null(x_axis_opt)) {
    suppressWarnings(do.call(axis, x_axis_opt))
  }
  if (!is.null(y_axis_opt)) {
    y_axis_opt$labels = rev(y_axis_opt$labels)
    suppressWarnings(do.call(axis, y_axis_opt))
  }
  
  if (show_legend) {
    source("support_functions/legend_col.R")
    legend_col(bubble_sizes, color_scale, legend_name_size, legend_name_color)
  }
  
  return(p)
}

