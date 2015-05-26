class CreateRailfallPredictions < ActiveRecord::Migration
  def change
    create_table :railfall_predictions do |t|
      t.float :probability
      t.float :value
      t.references :regression, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
