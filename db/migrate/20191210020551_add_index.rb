class AddIndex < ActiveRecord::Migration[5.2]
  def change
  	add_index :deposits, :user_id
  	add_index :holdings, [:user_id, :company_id]
  	add_index :orders, :status
  	add_index :orders, :order_type
  	add_index :orders, [:order_type, :company_id, :status]
  end
end
