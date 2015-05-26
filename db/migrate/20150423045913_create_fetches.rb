class CreateFetches < ActiveRecord::Migration
  def change
    create_table :fetches do |t|
      t.datetime :fetchtime

      t.timestamps null: false
    end
  end
end
