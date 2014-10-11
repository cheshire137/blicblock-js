class AddLocationIdToScores < ActiveRecord::Migration
  def change
    add_column :scores, :location_id, :integer
    add_index :scores, :location_id
  end
end
