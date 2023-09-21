# ABCD_create_datasets template


1. Update the readme.md file to describe your project. The file should include the following:
   
   1. What are the instruments you are using and which ABCD version?
   2. How to run the scripts?
   3. How to merge the data?

2. Go over the data script files:

   1. Delete unrelevent categories and scripts.
   2. Adjust the required scripts. if needed, select/diselect variables. 
   3. Run the scripts. the new datasets are created under the [outputs](/outputs) folder.

3. Merge the datasets:

   1. Use the file [merging.R](/scripts/merging.R) as a template to merge the datsets 
   2. If needed, create new variables 
   3. Create new CSV file with all relevant features and upload it to box
  
4. Delete this file so it won't be part of the final project 


# Notes
- genetics - 

- demographics
- exposome: Tyler Box exposome_score_1y = Adversity_General_Factor
- AL: data from Elina Box allostatic_load = bifactor_general
- BMI, biospecimen
- poligenic: genetic data Box
- psychopathology sum: BPM, CBCL
- psychiatric conditions (e.g., PTSD, depression)


- demographics
- biospecimen
- physical health anthropometrics
- psychopathology sum: BPM, CBCL
- ksads parent and youth
- family relationship
- site id

Main analyses will include kids that have at least 1 biological indicator of allostatic load in the 2-year data timepoint.
This means: HGBA1c, Cholesterol (LDL or HDL), or DHEA.
In the sensitivity analyses we will include all kids using their imputed AL scores that I expect will give similar results. 

dataset$MDD_PRS #Major Depressive Disorder (MDD) PGC: Howard et al. (2019) #EUR
dataset$MVP_MDD_PRS ##Major Depressive Disorder (MDD) #AFR
dataset$newCDG2_PRS #Cross Disorder (CDG2) # EUR