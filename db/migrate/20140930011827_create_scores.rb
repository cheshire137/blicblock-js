class CreateScores < ActiveRecord::Migration
  def change
    create_table :scores do |t|
      t.string :initials
      t.integer :value, null: false
      t.string :ip_address
      t.timestamps
    end
  end
end
