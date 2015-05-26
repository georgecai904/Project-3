class Weather < ActiveRecord::Base
  belongs_to :rainfall
  belongs_to :temperature
  belongs_to :wind
  belongs_to :station
	belongs_to :fetch
end
