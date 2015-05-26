class CreateTemperatures < ActiveRecord::Migration
  def change
    create_table :temperatures do |t|
      t.decimal :current
      t.decimal :dew

      t.timestamps null: false
    end
  end
end
