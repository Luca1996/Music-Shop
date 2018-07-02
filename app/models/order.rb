class Order < ApplicationRecord
	belongs_to :user
	has_many :line_items

	validates :address, presence: true, length: { minimum:5 }
	validates :t_num, length: {maximum: 8}, format: { with: /\A[0-9]{8,12}/, message: "Insert a valid number" }
	validates :user_id, presence: true
	
	
	
	enum p_method: {
		"PayPal"	         => 0,
		"Cash on delivery"	 => 1
	}
	

	#add the items from the cart to the order
	def add_items_from_cart(cart)
		cart.line_items.each do |item|
			item.cart_id = nil
			line_items << item
		end
	end


end
