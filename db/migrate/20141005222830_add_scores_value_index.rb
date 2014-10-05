class AddScoresValueIndex < ActiveRecord::Migration
  def change
    add_index :scores, :value
  end
end
