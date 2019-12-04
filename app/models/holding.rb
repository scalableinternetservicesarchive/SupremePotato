class Holding < ApplicationRecord
    belongs_to :user
    belongs_to :company

    def average_cost

        # Holdings are not deleted even if you sell all your stocks
        if self.quantity < 1
            @average_cost = 0
        end

        unless @average_cost
            # Use FIFO in averaging buys, ignoring first N sells
            num_sells = Trade.where(company_id: self.company_id).joins(:sell_order).where('orders.user_id' => self.user_id).count

            # Successful buys
            fifo_buy_total = Trade.where(company_id: self.company_id).joins(:buy_order).where('orders.user_id' => self.user_id).order('id DESC').limit(9223372036854775807).offset(num_sells).inject(0) { |sum, x|
                sum + x.price
            }

            @average_cost = fifo_buy_total / self.quantity
        end
        @average_cost
    end
end
