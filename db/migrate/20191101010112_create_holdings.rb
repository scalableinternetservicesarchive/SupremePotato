class CreateHoldings < ActiveRecord::Migration[5.2]
  def change
    create_table :holdings do |t|
      t.integer :user_id
      t.integer :company_id
      t.integer :quantity

      t.timestamps
    end
    add_index :holdings, :user_id
  end
end
