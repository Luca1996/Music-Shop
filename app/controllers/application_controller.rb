class ApplicationController < ActionController::Base
	include CurrentCart
	before_action :ensure_logged_in, only: [:logout]
	before_action :set_cart, only: [:cart] 

	def cart
		redirect_to cart_path(@cart)
	end
	
	# method called to logout, it previously check you are logged in
	def logout
		sign_out(@user)
		redirect_to '/', notice: "Logout success"
	end

	private

		def ensure_logged_in
			if !user_signed_in?
				redirect_to	'/', notice: "Already logged out"
			end
		end

end
