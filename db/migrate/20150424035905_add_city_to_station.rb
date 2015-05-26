class AddCityToStation < ActiveRecord::Migration
  def change
    add_reference :stations, :city, index: true, foreign_key: true
  end
end
