class Rainfall < ActiveRecord::Base
	# Relationships
	belongs_to :observation
	belongs_to :prediction

	def last_rainfall
		return Rainfall.order(:created_at).last.rainfall_amount
	end
end
