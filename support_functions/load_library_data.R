load_library_data <- function(filename) {
  
  # read the file
  raw_data = read.csv(filename)
  
  # find number of AA positions
  first_row = raw_data[1,2:ncol(raw_data)]
  found_numeric = sapply(1:length(first_row), function(i) is.numeric(first_row[[i]]))
  num_positions = which(found_numeric)[[1]] - 1
  
  # gather all amino acids
  AA_names = unique(unlist(raw_data[,3:4]))
  
  # storage
  bubble_colors = matrix(NA, length(AA_names), length(AA_names), dimnames = list(AA_names, AA_names))
  bubble_sizes = bubble_colors
  
  # place values into storage variables
  for (n_row in 1:nrow(raw_data)) {
    row_index = which(AA_names == raw_data[[n_row, 4]])
    col_index = which(AA_names == raw_data[[n_row, 3]])
    
    bubble_colors[[row_index, col_index]] = raw_data[[n_row, 1]]
    bubble_sizes[[row_index, col_index]] = raw_data[[n_row, 2]]
  }
  
  return(list(bubble_colors, bubble_sizes))
  
}