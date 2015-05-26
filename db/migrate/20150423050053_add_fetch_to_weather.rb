class AddFetchToWeather < ActiveRecord::Migration
  def change
    add_reference :weathers, :fetch, index: true, foreign_key: true
  end
end
