class AddUserIdsToTrades < ActiveRecord::Migration[5.2]
  def change
    add_column :trades, :buyer_id,  :integer
    add_column :trades, :seller_id, :integer

    add_index :trades, [:buyer_id,  :id]
    add_index :trades, [:seller_id, :id]
  end
end
