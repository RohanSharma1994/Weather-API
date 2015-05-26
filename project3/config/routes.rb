Rails.application.routes.draw do
  # Application root
  get 'welcome/index'

  root 'welcome#index'
  
  #<-----Weather data system----->
  # API call to get all the locations
  get 'weather/locations' => 'weather#locations'
  # API call to get data given a post code and date. Using regex to resolve URI collision.
  get 'weather/data/:post_code/:date' => 'weather#data_per_post_code', :post_code => /[0-9]{4}/
  # API call to get data given a location id and date.
  get 'weather/data/:location_id/:date' => 'weather#data_per_location_id'

  
  
  #<-----Predictions system----->
  get '/weather/prediction/:post_code/:period' => 'prediction#post_code_prediction'

  get '/weather/prediction/:lat/:lon/:period' => 'prediction#lat_lon_prediction'
end
