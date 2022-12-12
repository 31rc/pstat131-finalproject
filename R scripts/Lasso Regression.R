# lasso regression using glmnet engine, tune penalty
lasso <- linear_reg(penalty = tune(), mixture = 1) %>% 
  set_mode("regression") %>% 
  set_engine("glmnet")

# create workflow by adding recipe and model
lasso_workflow <- workflow() %>% 
  add_recipe(nba_recipe) %>% 
  add_model(lasso)

# create tuning grid for penalty
lasso_penalty_grid <- grid_regular(penalty(range = c(-5, 5)), levels = 50)

# fit models to folds
lasso_res <- tune_grid(
  lasso_workflow,
  resamples = nba_folds, 
  grid = lasso_penalty_grid
)

# plot the result
autoplot(lasso_res)

# select the best penalty
lasso_best_penalty <- select_best(lasso_res, metric = "rsq")

# finalize the workflow with the best penalty
lasso_final <- finalize_workflow(lasso_workflow, lasso_best_penalty)