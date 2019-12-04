class Order < ApplicationRecord
    PENDING   = 0
    COMPLETED = 1
    CANCELED  = 2

    BUY  = 1
    SELL = 2

    def status_name
        case self.status
        when PENDING
            'PENDING'
        when COMPLETED
            'COMPLETED'
        when CANCELED
            'CANCELED'
        else
            'UNKNOWN STATUS'
        end
    end

    def order_name
        case self.order_type
        when BUY
            'BUY'
        when SELL
            'SELL'
        else
            'UNKNOWN ORDER TYPE'
        end
    end

    belongs_to :user
    belongs_to :company

    def cached_user_name
        Rails.cache.fetch('user_name_' + self.user_id.to_s) do
            Rails.logger.info '<<<CACHE NOT FOUND + DB CALL>>>' + 'user_id' + self.user_id.to_s
            User.find(self.user_id).name
        end
    end
end
