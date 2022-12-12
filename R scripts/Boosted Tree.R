# boosted tree model
bt <- boost_tree(mode = "regression", trees = tune()) %>%
  set_engine("xgboost")

# create workflow by adding recipe and model
bt_workflow <- workflow() %>%
  add_recipe(nba_recipe) %>%
  add_model(bt)

# create tuning grid
bt_grid <- grid_regular(trees(range = c(10, 2000)), levels = 10)

# fit models to folds
bt_res <- tune_grid(
  bt_workflow, 
  resamples = nba_folds, 
  grid = bt_grid
)

# plot the result
autoplot(bt_res)

# select the best penalty
bt_best <- select_best(bt_res, metric = "rsq")

# finalize the workflow with the best penalty
bt_final <- finalize_workflow(bt_workflow, bt_best)