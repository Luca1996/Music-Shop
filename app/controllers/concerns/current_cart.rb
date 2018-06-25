# This script contains methods which can be used by all the controllers
# This is not to repeat the code in all controllers and make them DRY

module CurrentCart
	
	private

		# This method sets the cart in the instance variable @cart 
		# The cart id is stored in the hash session which isn't changed by HTTP requests
		def set_cart
			@cart = Cart.find(session[:cart_id])
		# if there isn't a cart in session, we create one an save it in session
		rescue ActiveRecord::RecordNotFound
			@cart = Cart.create
			session[:cart_id] = @cart.id
		end


# note : session stores datas as cookies in the browser web, so the value of the cart will be
# the same for different browser windows
# it is important to save the fewer amount of data possible as cookie

end