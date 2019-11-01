json.extract! order, :id, :type, :price, :company_id, :user_id, :status, :created_at, :updated_at
json.url order_url(order, format: :json)
