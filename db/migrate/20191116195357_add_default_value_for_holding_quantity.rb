class AddDefaultValueForHoldingQuantity < ActiveRecord::Migration[5.2]
  def change
    change_column_default(
      :holdings,
      :quantity,
      from: nil,
      to: 0,
    )
  end
end
