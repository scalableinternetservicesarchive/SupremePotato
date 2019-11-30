class User < ApplicationRecord
    has_many :orders
    has_many :deposits
    has_many :holdings
    validate :valid_balance

    private
    def valid_balance
    	if self.balance < 0
    		self.errors[:amount] << "Insufficient balance to support this action."
    	end
    end

end
