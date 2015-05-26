class CreatePredictions < ActiveRecord::Migration
  def change
    create_table :predictions do |t|
      t.datetime :time
      t.float :longitude
      t.float :latitude
      t.references :station, index: true, foreign_key: true
      t.references :temperature, index: true, foreign_key: true
      t.references :railfallPrediction, index: true, foreign_key: true
      t.references :windSpeed, index: true, foreign_key: true
      t.references :windDirection, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
