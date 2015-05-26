class CreateTemperaturePredictions < ActiveRecord::Migration
  def change
    create_table :temperature_predictions do |t|
      t.float :probability
      t.float :value
      t.references :regression, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
