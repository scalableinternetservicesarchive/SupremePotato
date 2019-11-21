# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).

#Companies list
#id, name, ticker, shares, starting_price
companies_list = [
  [1, "Apple",    "AAPL",  20, 200],
  [2, "Google",   "GOOGL", 30, 110],
  [3, "Facebook", "FB",    15, 100],
  [4, "Amazon",   "AMZN",  20, 150],
]

#Erase all entries everytime before Seeding!
Company.delete_all
Deposit.delete_all
Holding.delete_all
Order.delete_all 
Trade.delete_all
User.delete_all

companies_list.each do |id, name, ticker, shares, price|
  #Crate companies entries
  company = Company.new(
    name:    name,
    ticker:  ticker,
    shares:  shares,
  )
  company.id = id
  company.save!

  #Create CEO users entries
  ceo = User.create(
    name:    name + "-CEO",
    balance: 1000000,
  )
  #ceo.id = id
  #ceo.save!

  #Crate User holdinng entries
  holdings = Holding.create(
    user_id:    ceo.id,
    company_id: id,
    quantity:   shares,
  )

  #Create #shares number of sales orders (because each order only allow one share atm)
  shares.times {
    Order.create(
      price:      price,
      company_id: id,
      user_id:    ceo.id,
      status:     Order::PENDING,
      order_type: Order::SELL,
    )
  }
end