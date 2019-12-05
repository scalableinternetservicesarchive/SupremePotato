class User < ApplicationRecord
    has_many :orders
    has_many :deposits
    has_many :holdings
end
