class CreateRainfalls < ActiveRecord::Migration
  def change
    create_table :rainfalls do |t|
      t.decimal :amount

      t.timestamps null: false
    end
  end
end
