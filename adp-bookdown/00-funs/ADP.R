#### describe_all() ####

describe_all <- function(data,               # a data frame / tibble
                         variables = "all",  # other options = "numeric" or "categorical"
                         round_digits = T    # rounds to two decimals (F for not rounding at all)
                         ) { 
  
  if (!("data.frame" %in% class(data)))
    stop("\"data\" must be a data frame or tibble")
  
  if (!require("pacman")) 
    install.packages("pacman"); library(pacman)  
  
  p_load(dplyr, purrr, janitor, mosaic, sjmisc)
  
  p_load_gh("hadley/colformat", "ropenscilabs/skimr")
  
  rename_first <- function(data_names, string){
    a <- data_names
    names(a)[1] <- string
    return(a)
  }
  
  is_categorical <- function(x) {
    if (is.factor(x) | is_character(x) | is.labelled(x) == T )
      return(TRUE)
    else
      return(FALSE)
  }
  
  is_numeric_not_lbl <- function(x) {
    if(is.numeric(x) & !is.labelled(x) == T)
      return(TRUE)
    else
      return(FALSE)
  }
  
  any_categorical <- TRUE %in% map_lgl(data, ~is_categorical(.x))
  
  any_numeric   <- TRUE %in% map_lgl(data, ~is_numeric_not_lbl(.x))
  
  
  describe_categorical <- function(data) {
    
    data_categorical <- data %>% 
      select_if(is_categorical)
    
    n <- length(data_categorical)
    
    ret <- map(1:n , ~tabyl(data_categorical[[.x]])) %>%
      map2(names(data_categorical), ~rename_first(.x, .y)) %>%
      map(~as.tibble(.x)) %>%
      map(~arrange(.x, -n))
    
    return(ret) }
  
  describe_numeric <- function(data){
    
    data_numeric <- data %>% 
      select_if(is_numeric_not_lbl)
    
    ret <- map_df(data_numeric, ~favstats(.x)) %>%
      mutate(variable = data_numeric %>% names()) %>%
      select(variable, everything()) %>%
      rename(Q2 = median, na = missing)
    
    return(ret %>% as.tibble)
  }
  
  if (any_categorical==T) {
    desc_cha <- describe_categorical(data)
  }
  
  if (any_categorical==F) {
    desc_cha <- NULL
  }
  
  if (any_numeric==T & round_digits==T) {
    desc_num_total <- describe_numeric(data) %>%
      left_join(suppressWarnings(skim(data)) %>% 
                  filter(stat=="hist") %>%
                  select(var, level) %>%
                  rename(hist = level),
                by = c("variable" = "var"))
    desc_num_only_num <- desc_num_total %>%
      select_if(is_numeric_not_lbl) %>%
      map_df(~round(.x, 2))
    desc_num <- desc_num_total %>%
      replace_columns(desc_num_only_num)
  }
  
  if (any_numeric==T & round_digits==F) {
    desc_num <- describe_numeric(data) %>%
      left_join(suppressWarnings(skim(data)) %>% 
                  filter(stat=="hist") %>%
                  select(var, level) %>%
                  rename(hist = level),
                by = c("variable" = "var"))
    }
  
  if (any_numeric==F) {
    desc_num <- NULL
  }
  
  desc_all <- c(list(desc_num), desc_cha)
  
  if (variables=="all")
    return(desc_all)
  
  if (variables=="numeric")
    return(desc_num)
  
  if(variables=="categorical")
    return(desc_cha)
}

#### corr_pred_binary() ####

corr_pred_binary <- function(model,           # binary model of class "glm"
                             threshold = 0.5, # what is the predicted probability threshold for predicting a 1?
                             type = "n"       # another option = "prop"
                             ) {
  if (!("glm" %in% class(model)))
    stop("model must be of class \"glm\"")
  if(!(type %in% c("n", "prop")))
    stop("type must be either \"n\" or \"prop\"")
  
  if (!require("broom"))
    install.packages("broom"); library(broom)  
  if (!require("dplyr"))
    install.packages("dplyr"); library(dplyr)  
  
  pred <- suppressWarnings(augment(model, type.predict = "response")) %>%
    as.tibble() %>%
    mutate(dep_var = !!(model$formula[[2]])) %>%
    mutate(predicts_yes = if_else(.fitted>threshold,     1, 0),
           correct      = if_else(dep_var==predicts_yes, 1, 0)) %>%
    mutate(.rownames = seq(1, dim(.)[1], by = 1)) %>%
    dplyr::select(.rownames, dep_var, predicts_yes, correct)
    
  n_correct = sum(pred$correct, na.rm = T)
  
  prop_correct = n_correct / dim(pred)[[1]]
  
  if (type=="n")
    return(n_correct)
  if (type=="prop")
    return(prop_correct)
}


#### rob_se_glm_vctr() ####

rob_se_glm_vctr <- function(model,     # model of class "glm"
                            type="HC1" # see ?sandwich::vcovHC for options
                            ) {
  if (!("glm" %in% class(model)))
    stop("model must be of class \"glm\"")
  
  if (!require("pacman")) 
    install.packages("pacman"); library(pacman)  
  
  p_load(lmtest, sandwich)
  
  vector <- coeftest(model, vcov=vcovHC(model, type = type))[,2]
  return(vector)
  }

#### rob_cl_se_glm_vctr() ####

rob_cl_se_glm_vctr <- function(model,               # model of class "glm"
                               cluster,             # cluster variable, quotated (e.g. "group") or as vector (e.g. db$group)
                               df_correction = T) { # T for HC1 VCOV, F for HC0
  if (!("glm" %in% class(model)))
    stop("model must be of class \"glm\"")
  
  if (!require("pacman")) 
    install.packages("pacman"); library(pacman)
  
  p_load(lmtest, sandwich, multiwayvcov)
  
  if (is_scalar_character(cluster)) {
    vcovCL <- cluster.vcov(model, 
                           cluster = model$data[[cluster]], 
                           df_correction = df_correction)
  }

  if ((is_double(cluster) | is_integer(cluster)) & length(cluster) > 1) {
    vcovCL <- cluster.vcov(model, 
                           cluster = cluster, 
                           df_correction = df_correction)
  }
    
  vector <- coeftest(model, vcovCL)[,2]
  
  return(vector)
}

#### stargazer_easy_binary() ####

stargazer_easy_binary <- function(models,              # either a binary model or a list of binary models
                                  ...,                 # stargazer() options 
                                  default.stats = c("n", "ll", "AIC", "BIC", "nCP", "PCP"),
                                  add.lines = NULL     # another stargazer() option
                                  ) {
  if (!require("pacman")) 
    install.packages("pacman"); library(pacman)
  
  p_load(dplyr, stringr, broom)
  
  supported_stats <- c("n", "ll", "AIC", "BIC", "nCP", "PCP")
  
  if (identical(intersect(default.stats, supported_stats), character(0)))
    stop("None of your provided \"default.stats\" is currently supported")
  
  n_not_suported_def_stats <- length(setdiff(default.stats, supported_stats))
  
  if (n_not_suported_def_stats > 0 & !(identical(intersect(default.stats, supported_stats), character(0))))
    stop(str_c(n_not_suported_def_stats, " of your provided \"default.stats\" are currently not supported"))
  
  if (!("list" %in% class(models))) {
    models <- list(models)
  }
  
  if ("n" %in% default.stats) {
    n_vctr   <- c("Observations", map_dbl(models, ~ dim(suppressWarnings(augment(.x)))[1]))
  }
  else {
    n_vctr   <- NULL
  }
  
  if ("ll" %in% default.stats) {
    ll_vctr   <- c("Log Likelihood", map_dbl(models, ~ logLik(.x) %>% as.double() %>% round(., 2)))
  }
  else {
    ll_vctr   <- NULL
  }
  
  if("AIC" %in% default.stats) {
    AIC_vctr <- c("AIC", map_dbl(models, ~ round(AIC(.x), 2)))
  }
  else {
    AIC_vctr <- NULL
  }
  
  
  if ("BIC" %in% default.stats) {
    BIC_vctr <- c("BIC", map_dbl(models, ~ round(BIC(.x), 2)))
  }
  else {
    BIC_vctr <- NULL
  }
  
  
  if("nCP" %in% default.stats) {
    nCP_vctr <- c("nCP", map_dbl(models, ~ corr_pred_binary(.x)))
  }
  else {
    nCP_vctr <- NULL
  }
  
  
  if("PCP" %in% default.stats) {
    PCP_vctr <- c("PCP", map_dbl(models, ~ round(corr_pred_binary(.x, type = "prop"), 2)))
  }
  else {
    PCP_vctr <- NULL
  }
  
  
  list_stats <- list(
    n_vctr,
    ll_vctr,
    AIC_vctr,
    BIC_vctr,
    nCP_vctr,
    PCP_vctr
  ) %>%
    setdiff(rep.int(list(NULL), length(.))) %>%
    c(add.lines)
  
  stargazer(... = models, 
            ..., 
            omit.stat = c("n", "ll", "aic"),
            add.lines = list_stats)
  }

