source("config.R")
source("utility_fun.R")

site <-  load_instrument("abcd_lt01",abcd_files_path)


site$site_id_l_br = sub("site","",site$site_id_l)
site[,c("sched_delay", "sched_hybrid", "site_id_l")] = NULL
site = site[grep("year",site$eventname),]

# Use data at 2y
site = site[site$eventname == "2_year_follow_up_y_arm_1",]

write.csv(file = "data/site.csv",x = site, row.names = F, na = "")

