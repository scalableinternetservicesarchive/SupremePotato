class Company < ApplicationRecord
    has_many :orders
    has_many :trades
    has_many :holdings

    def price
        if @price.nil?
            trade  = self.trades.order('id DESC').first

            if trade
                @price = trade.price
            else
                # Get CEO's sale price
                @price = self.orders.where(order_type: Order::SELL).order('id DESC').first.price
            end
        end

        @price
    end
end
