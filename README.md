# ABCD allostatic load project


#### This project uses the following ABCD instruments [version 4.0]:
1. pdem02
2. abcd_lpds01
3. abcd_hsss01
4. abcd_ybd01
5. abcd_bp01
6. acspsw03
7. abcd_ant01
8. abcd_mx01
9. abcd_lpmh01
10. abcd_cbcls01
11. abcd_yssbpm01
12. abcd_lt01


#### How to run the code:

1. Update the [config.R](config.R) to reflect the location of the instruments above.
2. In the data-scripts folder, run scripts in any order. These scripts go over the abcd instruments and create new variables and datasets that are placed in the “data” folder.
In the demographics folder, the script organize_demographics.R should be run after the other two scripts.
3. Run the [merging.Rmd](scripts/merging.Rmd) script to create the dataset.
4. Run the [descriptive_analysis.Rmd](scripts/descriptive_analysis.Rmd) to generate descriptive tables and figures.
5. Run the [descriptive_missing_data.Rmd](scripts/descriptive_missing_data.Rmd) to generate the supplement table 1.
6. Run the [analysis.Rmd](scripts/analysis.Rmd) to generate tables in the main text and supplement.
7. Run the [mediation_analysis.Rmd](scripts/mediation_analysis.Rmd) to generate mediation results.