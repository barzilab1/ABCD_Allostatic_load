
library(psych)

source("config.R")
source("utility_fun.R")

### TODO check with Ran what should be the boundaries for all of markers


########### Hormone Saliva Salimetric Scores ########### 

hsss01 = load_instrument("abcd_hsss01",abcd_files_path)
hsss01 = hsss01[,grepl("src|interview|event|sex|dhea_mean", colnames(hsss01))]

describe(hsss01)


####### ABCD Youth Blood Analysis ####### 
ybd = load_instrument("abcd_ybd01", abcd_files_path)

# remove unneeded variables
ybd = ybd[, grepl("src|interview|event|sex|cholesterol|a1", colnames(ybd))]

describe(ybd)


####### ABCD Youth Blood Pressure ####### 
bp = load_instrument("abcd_bp01", abcd_files_path)

bp = bp[, grepl("src|interview|event|sex|_mean", colnames(bp))]

describe(bp)




####### merge ####### 

bi_markers = merge(hsss01, ybd )
bi_markers = merge(bi_markers, bp)

write.csv(file = "data/biospecimen.csv", x = bi_markers, row.names = F, na = "")

