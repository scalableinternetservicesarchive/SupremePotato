class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.boolean :type
      t.integer :price
      t.integer :company_id
      t.integer :user_id
      t.integer :status

      t.timestamps
    end
    add_index :orders, :company_id
    add_index :orders, :user_id
  end
end
