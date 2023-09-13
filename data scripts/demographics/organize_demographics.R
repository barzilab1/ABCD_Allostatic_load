library(dplyr)
library(readr)

## organize demographics ####
demographics_baseline <- read_csv("data/demographics_baseline.csv")
demographics_long <- read_csv("data/demographics_long.csv") %>% rename(demo_roster_v2 = "demo_roster_v2_l")

demo_race <- demographics_baseline[,grep("src|sex|race|hisp|born_in_usa", colnames(demographics_baseline))] #|roster because also have longitudinal roster

# Use data at 2-year
demo_2y <- demographics_long %>% filter(eventname == "2_year_follow_up_y_arm_1") %>% select(-parents_avg_edu)

# Use parent education at 1-year follow-up
demo_parent_edu <- demographics_long %>% filter(eventname == "1_year_follow_up_y_arm_1") %>% select(matches("src|edu"))


write.csv(file = "data/demographics_2y.csv", x = demo_2y, row.names=F, na = "")
write.csv(file = "data/demo_race.csv", x = demo_race, row.names=F, na = "")
write.csv(file = "data/demo_parent_edu.csv", x = demo_parent_edu, row.names=F, na = "")






















