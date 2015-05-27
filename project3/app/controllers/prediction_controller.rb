# Handles all requests in relation to predictions
class PredictionController < ApplicationController
	# Action which returns predictions for a given post-code
	# Responds to the request: GET '/weather/prediction/:post_code/:period'
	def post_code_prediction
		# A JSON hash to respond with
		hash = Prediction.post_code_prediction params[:post_code], params[:period]
		respond_to do |format|
			format.html
			format.json {render json: JSON.pretty_generate(hash)}
		end
	end

	# Action which returns predictions for a given latitude 
	# & latitude
	# Responds to the request: GET '/weather/prediction/:lat/:lon/:period'
	def lat_lon_prediction 
		# A JSON hash to respond with
		hash = Prediction.lat_lon_prediction params[:period], params[:lat], params[:lon]
		respond_to do |format|
			format.html
			format.json {render json: JSON.pretty_generate(hash)}
		end
	end
end
