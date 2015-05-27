class Temperature < ActiveRecord::Base
	# Relationships
	belongs_to :observation
	belongs_to :prediction
end
