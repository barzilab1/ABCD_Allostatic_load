



############# file paths #############

#path to abcd Restricted Access folder
root = "~"
box_path = "Library/CloudStorage/Box-Box"
abcd_box_path = "2. Barzi Lab - Restricted Access/2-ABCD"
abcd_data_path = "ABCD data"
prs_box_path = "Ran_Barzilay"
abcd_version = "4.0/"

abcd_data = file.path(root, box_path, abcd_box_path, abcd_data_path )
abcd_files_path = file.path(abcd_data, abcd_version)
abcd_genetics_path = file.path(abcd_data, "genetics")
abcd_partition_path = file.path(abcd_data, "partition")
abcd_covid_path = file.path(abcd_data, "covid19")

additional_files_path = file.path(root, box_path, abcd_box_path,"Additional files/")


exposome_tyler = "Projects/exposome_Tyler/3.0/results"
p_factor_files_path = file.path(root, box_path, abcd_box_path, exposome_tyler, "p factor scores")
e_factor_files_path = file.path(root, box_path, abcd_box_path, exposome_tyler, "e factor scores")

allostatic_load = "Projects/Allostatic load tyler"
allostatic_load_files_path = file.path(root, box_path, abcd_box_path, allostatic_load)
