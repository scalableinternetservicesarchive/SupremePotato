class Deposit < ApplicationRecord
    belongs_to :user
    validate   :check_valid_amount

    private
    def check_valid_amount
        if self.user.balance + self.amount < 0
            self.errors[:amount] << "Can't withdraw more than account balance."
        end
    end
end
