class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :country
      t.string :country_code, limit: 3
      t.timestamps
    end
  end
end
