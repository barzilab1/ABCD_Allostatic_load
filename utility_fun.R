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

  check_missing <- function(data, instrument) {
    
    data %>% 
      group_by(eventname) %>% 
      naniar::miss_var_summary() %>% 
      mutate(instrument = instrument) %>% 
      ungroup() %>% 
      
      left_join(
        data %>% 
          group_by(eventname) %>% 
          summarise(N_complete = n()) %>% 
          ungroup()) %>% 
      
      # Order columns
      select(instrument, variable, eventname, N_complete, N_missing = n_miss, pct_missing = pct_miss)
  }
  return(instrument)
}

# Create correlation plot
# plot_cor <- function(vars) {
#     cor = cor_auto(vars)
#     testRes = cor.mtest(vars, conf.level = 0.95)
#     plot <- corrplot(cor, p.mat = testRes$p, method = 'color', diag = FALSE, type = 'upper', #col = col,
#                      sig.level = c(0.001, 0.01, 0.05), pch.cex = 0.7,
#                      insig = 'label_sig', pch.col = 'grey20', order = 'original', tl.col = "black", tl.srt = 45, tl.cex = 0.7, cl.cex = 0.7, cl.ratio = 0.4)
#     return(plot)
# }

plot_cor <- function(vars, ...) {
  cor = cor_auto(vars)
  testRes = cor.mtest(vars, conf.level = 0.95)
  plot <- corrplot(cor, p.mat = testRes$p, method = 'color', diag = FALSE, type = 'upper', #col = col,
                   sig.level = c(0.001, 0.01, 0.05), #pch.cex = 0.7,
                   insig = 'label_sig', pch.col = 'grey20', order = 'original', 
                   tl.col = "black", tl.srt = 45, ...) #tl.cex = 0.7, cl.cex = 0.7, cl.ratio = 0.4
  return(plot)
}

# Run mediaton models among each ancestry
run_mediation <- function(IV, DV, Mediator, data, covariates = c("scale(age_years)", "scale(age_years)^2", "scale(age_years)^3", "sex_br")) {
  
  set.seed(060223)
  
  mod1 <- paste0(c(paste0(Mediator, " ~ ", paste0("a1*", IV)), covariates), collapse = " + ")
  mod2 <- paste0(c(paste0(DV, " ~ ", paste0("b1*", Mediator)), paste0("c*", IV), covariates ), collapse = " + ")
  mod3 <- "indirecteffect := a1*b1"
  mod4 <- "totaleffect := c + a1*b1"
  
  mod <- paste(mod1, mod2, mod3, mod4, sep = " \n ")
  
  mediation_mod <- sem(mod, data = data, se = "bootstrap", bootstrap = 500)
  results <- standardizedSolution(mediation_mod, type = "std.lv")
  summary <-summary(mediation_mod)
  
  return(list(results = results,  summary = summary))
}

# run mixed models
# get_formula <- function(outcome, predictor, random_eff, var_added = NULL) {
#     if (is.null(var_added)) {
#         reformulate(c(predictor, random_eff), response = outcome)
#     } else {
#         reformulate(c(predictor, var_added, random_eff), response = outcome)
#     }
# }

# run mixed models
covar_mixed_mod <- c("scale(age_years)", "scale(age_years)^2", "scale(age_years)^3",
                     "race_white", "race_black", "ethnicity_hisp", "sex_br", "household_income", "parents_avg_edu")
random_effects <- "(1 | site_id_l_br/rel_family_id)"

get_model <- function(data, outcome, predictor = NULL, covariates = covar_mixed_mod, random_eff = random_effects, control_model = F, binary_DV = F) {
  
  mod_formula <- reformulate(c(covariates, predictor, random_eff), response = outcome)
  
  if(!binary_DV) {
    if(!control_model) {
      model <- lmer(mod_formula, data = data)
    }
    
    else {
      model <- lmer(mod_formula, data = data,
                    control = lmerControl(check.nobs.vs.nlev = "ignore",
                                          check.nobs.vs.rankZ = "ignore",
                                          check.nobs.vs.nRE = "ignore",
                                          optimizer = "bobyqa", optCtrl = list(maxfun = 2e5)))
    }
  }
  
  else {
    model <- glmer(mod_formula, data = data, family = binomial, nAGQ = 0)
  }
  return(model)
}








