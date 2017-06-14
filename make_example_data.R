
source("C:/Users/Xuebert/Dropbox/Albert Xue/Research/SAMDI/data/KDAC_DeLuca/KDAC_DeLuca_XuePC2.R")
data_mat = KDAC_DeLuca_Demeter()
bubble_color = colMeans(data_mat[1:2,])

load("C:/Users/Xuebert/Dropbox/Albert Xue/Research/SAMDI/data/KDAC_controls/2010222_RKacXZ_control_data.RData")
bubble_size = colMeans(SN[1:11,])
# normalize bubble_size
bubble_size = bubble_size / max(bubble_size)

AA_storage = sapply(names(bubble_color), function(i) strsplit(i, ""))
AA_storage = matrix(unlist(AA_storage), ncol = 2, byrow = T)

write_table = cbind(bubble_color, bubble_size, AA_storage)
colnames(write_table) = c("bubble_color", "bubble_size", "X-position", "Z-position")

write.csv(write_table, file = "example_data_file.csv", quote = F, row.names = F)