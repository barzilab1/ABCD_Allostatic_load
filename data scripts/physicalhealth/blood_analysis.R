
source("config.R")
source("utility_fun.R")

####### ABCD Youth Blood Analysis ####### 
ybd = load_instrument("abcd_ybd01", abcd_files_path)

# remove unneeded variables
ybd = ybd[, grepl("src|interview|event|sex|cholesterol|a1", colnames(ybd))]

write.csv(file = "outputs/blood_analysis.csv", x = ybd, row.names = F, na = "")


####### ABCD Youth Blood Pressure ####### 
bp = load_instrument("abcd_bp01", abcd_files_path)
bp = bp %>% dplyr::select(-contains("time"))

write.csv(file = "outputs/blood_pressure.csv", x = bp, row.names = F, na = "")
