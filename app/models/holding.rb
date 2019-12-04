class Holding < ApplicationRecord
    belongs_to :user
    belongs_to :company

    def average_cost
        unless @average_cost
            # Use FIFO in averaging buys, ignoring first N sells
            sells = self.user.sells.where(company_id: self.company_id)
            buys  = self.user.buys.where(company_id: self.company_id).order('id DESC')

            fifo_buy_total = buys.offset(sells.count).limit(2**60).sum(:price)
            @average_cost  = fifo_buy_total / self.quantity
        end

        @average_cost
    end
end
