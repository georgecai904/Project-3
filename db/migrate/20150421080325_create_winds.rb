class CreateWinds < ActiveRecord::Migration
  def change
    create_table :winds do |t|
      t.decimal :speed
      t.string :direction

      t.timestamps null: false
    end
  end
end
