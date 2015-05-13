class Day < ActiveRecord::Base
	belongs_to :stattion
	has_many :observations
end
