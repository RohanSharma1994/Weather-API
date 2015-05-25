class Rainfall < ActiveRecord::Base
	belongs_to :observation

	def last_rainfall
		return Rainfall.order(:created_at).last.rainfall_amount
	end
end
