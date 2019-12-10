class AddInitialToOrder < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :initial, :integer
  end
end
