class Profile < ActiveRecord::Base

	belongs_to :user
	has_one :location
end
