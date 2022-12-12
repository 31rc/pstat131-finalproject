# ridge regression using glmnet engine, tune penalty
ridge <- linear_reg(penalty = tune(), mixture = 0) %>% 
  set_mode("regression") %>% 
  set_engine("glmnet")

# create workflow by adding recipe and model
ridge_workflow <- workflow() %>% 
  add_recipe(nba_recipe) %>% 
  add_model(ridge)

# create tuning grid for penalty
penalty_grid <- grid_regular(penalty(range = c(-5, 5)), levels = 50)

# fit models to folds
ridge_res <- tune_grid(
  ridge_workflow,
  resamples = nba_folds, 
  grid = penalty_grid
)

# plot the result
autoplot(ridge_res)

# select the best penalty
best_penalty <- select_best(ridge_res, metric = "rsq")

# finalize the workflow with the best penalty
ridge_final <- finalize_workflow(ridge_workflow, best_penalty)