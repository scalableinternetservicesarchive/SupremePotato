# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).

#Companies list
#name, ticker, shares, starting_price
companies_list = [
  [ "CMPSC 291", "291", 20, 200],
  [ "CMPSC 292", "292", 30, 110],
  [ "CMPSC 263", "263", 15, 100],
  [ "CMPSC 276", "276", 20, 150]
]

companies_list.each do |name, ticker, shares, price|
  #Crate companies entries
  company = Company.create(
		  	name:		name, 
		  	ticker:		ticker,  
		  	shares:		shares
	  	)

  #Create CEO users entries
  ceo = User.create(
  			name: 		name + "-CEO", 
  			balance: 	0
  		)

  #Crate User holdinng entries
  holdings = Holding.create(
		  	user_id: 	ceo.id, 
		  	company_id:	company.id, 
		  	quantity: 	shares
	  	)

  #Create #shares number of sales orders (because each order only allow one share atm)
  shares.times {
  	Order.create(
	  		price: 		price, 
	  		company_id:	company.id, 
	  		user_id:	ceo.id, 
	  		status: 	Order::PENDING, 
	  		order_type:	Order::SELL,
  		)
  }
end



