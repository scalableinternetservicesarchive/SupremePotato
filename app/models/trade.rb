class Trade < ApplicationRecord
    belongs_to :buy_order,  model: :orders
    belongs_to :sell_order, model: :orders
end
