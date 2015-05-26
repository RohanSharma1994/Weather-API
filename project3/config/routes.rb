Rails.application.routes.draw do
  # Application root
  get 'welcome/index'

  root 'welcome#index'
  
  # Weather data system
  get 'weather/locations' => 'weather#locations'

  get 'weather/data/:location_id/:date' => 'weather#data_per_id'

  get 'weather/mydata/:post_code/:date' => 'weather#data_per_post_code'
  
  # Predictions system
  get '/weather/prediction/:post_code/:period' => 'prediction#post_code_prediction'

  get '/weather/prediction/:lat/:lon/:period' => 'prediction#lat_lon_prediction'
end
