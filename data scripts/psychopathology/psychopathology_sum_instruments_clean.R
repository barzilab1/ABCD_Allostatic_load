
source("config.R")
source("utility_fun.R")

################### cbcls ###################
cbcls01 = load_instrument("abcd_cbcls01",abcd_files_path)

cbcls01 = cbcls01[, grepl("^(src|interview|event|sex)|_[r|t]$", colnames(cbcls01))]


################### Youth Summary Scores BPM and POA ###################
yssbpm01 = load_instrument("abcd_yssbpm01", abcd_files_path)
yssbpm01 = yssbpm01[,grepl("^(src|interv|event|sex)|_(r|t|mean|sum)$", colnames(yssbpm01))]


psychopathology_sum_scores = merge(cbcls01, yssbpm01)

# Use data at 2y
psychopathology_sum_scores = psychopathology_sum_scores[psychopathology_sum_scores$eventname == "2_year_follow_up_y_arm_1",]

write.csv(file = "data/psychopathology_sum_scores.csv",x = psychopathology_sum_scores, row.names = F, na = "")

