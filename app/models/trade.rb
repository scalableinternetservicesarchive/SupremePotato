class Trade < ApplicationRecord
    belongs_to :buy_order,  class_name: 'Order'
    belongs_to :sell_order, class_name: 'Order'
end
