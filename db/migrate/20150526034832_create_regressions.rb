class CreateRegressions < ActiveRecord::Migration
  def change
    create_table :regressions do |t|
      t.string :expression
      t.float :variance
      t.string :type
      t.string :coefficients

      t.timestamps null: false
    end
  end
end
