class CreateTrades < ActiveRecord::Migration[5.2]
  def change
    create_table :trades do |t|
      t.integer :buy_order_id
      t.integer :sell_order_id
      t.integer :company_id
      t.integer :price

      t.timestamps
    end
    add_index :trades, :company_id
  end
end
