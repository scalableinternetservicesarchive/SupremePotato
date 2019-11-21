## 1. Models
Company:
	name
	ticker
	shares
User:
	name
	balance
Order:
	price
	<!-- actual_price -->
	company_id
	user_id
	status
	order_type
Trade:
	buy_order_id
	sell_order_id
	company_id
	price
Holding:
	user_id
	company_id
	quantity
	<!-- virtual_quantity -->

## 2. Routes
companies	: view (name, ticker, shares, *price*, *trades*, *orders*)
users		: view (id, name, balance, *holdings*, *trades*, *orders*) 
			: create
orders		: view (id, type, *company*, *user*, price)
			: create
			: cancel


deposits	: create

## 3. Logic

#### create order
<!-- 1 share for each order -->
a. buy order:
	<!-- check balance -->
	1. reduce balance
	2. get a matching sell order(lowest price <= buy price)
	3. generate a trade

b. sell order:
	<!-- check holdings -->
	1. get a matching buy order(highest price >= sell price)
	2. generate a trade

#### generate a trade
	1. update buy&sell order status

	2. update balance
		a. if triggered by buy order: price = sell price
			i. refund buyer balance if sell price < buy price
			ii. add seller balance

		b. if triggered by sell order: price = buy price
			i. add seller balance
	3. update holdings
		i. add buyer holdings
		ii. reduce seller holdings

#### cancel order
	update order status
	buy order: udpate balance

#### get trades for user
	select from trades table

#### get holdings for user
	select from holdings table

#### get price for company
	select from trades table



