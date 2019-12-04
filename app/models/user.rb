class User < ApplicationRecord
    has_many :orders
    has_many :deposits
    has_many :holdings

    has_many :buys,  class_name: 'Trade', foreign_key: 'buyer_id'
    has_many :sells, class_name: 'Trade', foreign_key: 'seller_id'
    has_many :trades, ->(user){ where("trades.buyer_id = :id OR trades.seller_id = :id", id: user.id) }

    validate :valid_balance

    private
    def valid_balance
        if self.balance < 0
            self.errors[:amount] << "Insufficient balance to support this action."
        end
    end
end
