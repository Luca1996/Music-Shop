class Cart < ApplicationRecord
	# note : if we destroy the cart, we will destroy the line_items it contains
	has_many :line_items, dependent: :destroy


	# called in create line_item
	def add_product(product)
		item_to_add = line_items.find_by(product_id: product.id)
		if item_to_add
			item_to_add.quantity += 1
		else
			# in this case we create the line_item, the quantity default is 1
			item_to_add = line_items.build(product_id: product.id)
		end
		item_to_add
	end


	# total price of the cart
	def total
		prices = line_items.map {|li| li.price}
		prices.reduce(0) {|it0, it1| it0+it1}
	end


end
