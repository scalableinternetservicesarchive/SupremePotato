class RemoveTypeFromOrder < ActiveRecord::Migration[5.2]
  def change
  	remove_column :orders, :type 
  	add_column :orders, :order_type, :integer
  end
end
