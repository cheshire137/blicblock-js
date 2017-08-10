class DropIpAddressField < ActiveRecord::Migration
  def up
    remove_column :scores, :ip_address
  end

  def down
    add_column :scores, :ip_address, :string, limit: 255
  end
end
