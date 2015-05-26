class Prediction < ActiveRecord::Base
  belongs_to :station
  belongs_to :temperature
  belongs_to :railfallPrediction
  belongs_to :windSpeed
  belongs_to :windDirection
end
