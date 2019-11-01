json.extract! trade, :id, :buy_id, :sell_id, :company_id, :price, :created_at, :updated_at
json.url trade_url(trade, format: :json)
