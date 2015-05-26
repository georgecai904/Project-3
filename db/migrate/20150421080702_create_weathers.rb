class CreateWeathers < ActiveRecord::Migration
  def change
    create_table :weathers do |t|
      t.string :source
      t.string :time
      t.references :rainfall, index: true, foreign_key: true
      t.references :temperature, index: true, foreign_key: true
      t.references :wind, index: true, foreign_key: true
      t.references :station, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
