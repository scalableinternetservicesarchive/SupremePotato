class Order < ApplicationRecord
	BUY  = 1
	SELL = 2
	PENDING = 0
	COMPLETED = 1

    belongs_to :user
    belongs_to :company
end
