class Company < ApplicationRecord
    has_many :orders
    has_many :trades
    has_many :holdings

    def price
        @price ||= self.trades.order('updated_at DESC').last.price
    end
end
