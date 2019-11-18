class CurrentyToDecimals < ActiveRecord::Migration[5.2]
  def change
    change_column(
      :deposits,
      :amount,
      :decimal, :precision => 12, :scale => 2
    )

    change_column(
      :orders,
      :price,
      :decimal, :precision => 12, :scale => 2
    )

    change_column(
      :trades,
      :price,
      :decimal, :precision => 12, :scale => 2
    )

    change_column(
      :users,
      :balance,
      :decimal, :precision => 12, :scale => 2
    )
  end
end
