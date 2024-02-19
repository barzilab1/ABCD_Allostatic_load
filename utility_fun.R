library(readr)
library(qgraph)
library(corrplot)
library(Hmisc)

load_instrument <- function(file_name, file_path) {
  
  instrument = read.csv(file = paste0(file_path,file_name,".txt"), sep = '\t',header = TRUE,
                        row.names=NULL, na.string = c("","NA"), check.names=FALSE)
  
  #remove details line
  instrument=instrument[-1,]
  
  #drop columns introduced by NDA, they are not required in the instruments.
  instrument = instrument[,!(names(instrument) %in% c(paste0(file_name,"_id"), "collection_id", "collection_title", "promoted_subjectkey","subjectkey" ,"study_cohort_name", "dataset_id"))]
  
  #if visit was used instead of eventname, rename
  if ("visit" %in% names(instrument) ){
    ind = which(names(instrument) == "visit")
    names(instrument)[ind] = "eventname"
    print("eventname replaced visit")
  }
  
  #remove empty columns (and print their names)
  instrument = instrument[,colSums(is.na(instrument)) != nrow(instrument)]
  
  instrument = droplevels(instrument)
  
  
  #convert to numeric
  for (i in 1:ncol(instrument)) {
    
    tryCatch({
      if(typeof(instrument[,i]) == "character"){
        instrument[,i] = as.numeric(instrument[,i])
      }else if (typeof(instrument[,i]) == "factor"){
        instrument[,i] = as.numeric(as.character(instrument[,i]))
      }
    }, error = function(e) {
      print(colnames(instrument)[i])
      print(e)
    }, warning = function(e){
      print(colnames(instrument)[i])
      print(e)
    })
    
  }
  
  
  return(instrument)
}

# Create correlation plot
plot_cor <- function(vars, ...) {
  cor = cor_auto(vars)
  testRes = cor.mtest(vars, conf.level = 0.95)
  plot <- corrplot(cor, p.mat = testRes$p, method = 'color', diag = FALSE, type = 'upper',
                   sig.level = c(0.001, 0.01, 0.05),
                   insig = 'label_sig', pch.col = 'grey20', order = 'original', 
                   tl.col = "black", tl.srt = 45, ...)
  return(plot)
}

# Run mediation models among each ancestry
run_mediation <- function(IV, DV, Mediator, data, covariates = c("scale(age_years)", "scale(age_years)^2", "scale(age_years)^3", "sex_br")) {
  
  set.seed(060223)
  
  formula1 <- paste0(Mediator, " ~ a1*", IV, " + " , paste0(covariates, collapse = " + "))
  formula2 <- paste0(DV, " ~ b1*", Mediator ," + c*", IV, "+", paste0(covariates, collapse = " + "))
  formula3 <- "indirecteffect := a1*b1"
  formula4 <- "totaleffect := c + a1*b1"
  
  mediation_formula <- paste(formula1, formula2, formula3, formula4, sep = " \n ")
  
  mediation_mod <- sem(mediation_formula, data = data, se = "bootstrap", bootstrap = 500)
  results <- standardizedSolution(mediation_mod, type = "std.lv")
  summary <-summary(mediation_mod)
  
  return(list(results = results,  summary = summary))
}

# Run mediation models among each ancestry - 3 IVs
run_mediation_3IVs <- function(DV, data = data_eur, covariates = c("scale(age_years)", "scale(age_years)^2", "scale(age_years)^3", "sex_br")) {
  set.seed(060223)
  
  formula1 <- "allostatic_load ~ a1*exposome_score_1y + a2*T2D_fromEUR_PRS + a3*MDD_PRS + scale(age_years) + scale(age_years)^2 + scale(age_years)^3 + sex_br"
  formula2 <- paste(DV, " ~ b*allostatic_load + c1*exposome_score_1y + c2*T2D_fromEUR_PRS + c3*MDD_PRS +  + scale(age_years) + scale(age_years)^2 + scale(age_years)^3 + sex_br")
  formula3 <- "indirecteffectExp := a1*b"
  formula4 <- "indirecteffectT2D := a2*b"
  formula5 <- "indirecteffectMDD := a3*b"
  formula6 <- "totaleffect := a1*b + a2*b + a3*b + c1 + c2 + c3"
  
  mediation_formula <- paste(formula1, formula2, formula3, formula4, formula5, formula6, sep = " \n ")
  
  mediation_mod <- sem(mediation_formula, data = data, se = "bootstrap", bootstrap = 500)
  results <- standardizedSolution(mediation_mod, type = "std.lv")
  summary <-summary(mediation_mod)
  
  return(list(results = results,  summary = summary))
}

# run mixed models
covar_mixed_mod <- c("scale(age_years)", "scale(age_years)^2", "scale(age_years)^3",
                     "race_white", "race_black", "ethnicity_hisp", "sex_br", "household_income") #"highschool_diploma", "post_highschooler_education", "bachelor", "master_above"
random_effects <- "(1 | site_id_l_br/rel_family_id)"


get_model <- function(data, outcome, predictor = NULL, covariates = covar_mixed_mod, random_eff = random_effects) {
  
  mod_formula <- reformulate(c(covariates, predictor, random_eff), response = outcome)
  
  model <- lmer(mod_formula, data = data,
                control = lmerControl(check.nobs.vs.nlev = "ignore",
                                      check.nobs.vs.rankZ = "ignore",
                                      check.nobs.vs.nRE = "ignore",
                                      optimizer = "bobyqa", optCtrl = list(maxfun = 2e5)))
      
  return(model)
}

# Simple linear regression
get_simple_mod <- function(predictor, outcome, data){
  covariates <- c("scale(age_years)", "scale(age_years)^2", "scale(age_years)^3", "sex_br")
  mod_formula <- reformulate(c(covariates, predictor), response = outcome)
  mod <- lm(mod_formula, data = data)
}






