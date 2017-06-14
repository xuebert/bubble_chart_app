legend_col <- function(bubble_sizes, color_scale, legend_name_size, legend_name_color) {
  
  par(mar = c(0,0,0,0))
  plot(1, type = "n", xlim = c(0, 1), ylim = c(0, 1), xlab = "", ylab = "", main = "", xaxt = "n", yaxt = "n", bty = "n")
  
  # color scale parameters
  color_top = 0.8
  color_left = 0.2
  bar_thick = 0.3
  color_right = color_left + bar_thick
  y_curr = color_top
  middle = mean(c(color_left, color_right))
  inc = 0.003
  
  for (n in 100:1) {
    y_curr = y_curr - inc
    polygon(x = c(color_left, color_left + bar_thick, color_left + bar_thick, color_left), y = c(y_curr,y_curr,y_curr+inc,y_curr+inc), col = color_scale[[n]], border = color_scale[[n]])
  }
  text(x = rep(color_right, 3), y = seq(color_top, y_curr, length.out = 3), labels = c(1,0.5,0), cex = 1.5, pos = 4)
  text(x = middle, y = color_top + 0.05, labels = legend_name_color, pos = 1, cex = 2)
  
  # circle size legend
  max_circle_size = (max(bubble_sizes / ncol(bubble_sizes)) / pi) ^ 0.5
  # scale because plot sizes are different
  max_circle_size = max_circle_size * 1.8
  circle_legend = rev(seq(from = 0.03, to = max_circle_size, length.out = 7))
  
  y_coord_symbols = c(0.4, 0.35, 0.308, 0.2725, 0.245, 0.225, 0.205)
  symbols(x = rep(middle, 7), y = y_coord_symbols, circles = circle_legend, add = T, inches = F)
  text(x = rep(color_right + 0.1, 3), y = y_coord_symbols[c(1, 4, 7)], labels = c(1,0.5,0), cex = 1.5, pos = 4)
  text(x = middle, y = 0.45, labels = legend_name_size, pos = 1, cex = 2)
}