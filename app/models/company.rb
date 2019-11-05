class Company < ApplicationRecord
    has_many :orders
    has_many :trades
end
