class CartsController < ApplicationController
 before_action :select_cart, only: [:show, :destroy]


def show 
end

def index 
	@carts = Cart.all
end

def destroy
	if @cart.id == session[:cart_id]
		@cart.destroy 
		session[:cart_id] = nil
		redirect_to root_path, notice: "Cart emptied"
	else
		redirect_to root_path, notice: "Can't empty the selected cart"
	end
end


private 
	def select_cart
		@cart = Cart.find_by_id(params[:id])
		# can't access a cart which isn't in database
		# can't access the cart which doesn't correspond to my session if i'm not admin
		if @cart == nil || (@cart.id != session[:cart_id] && current_user != nil && current_user.admin != true)
			raise ActiveRecord::RecordNotFound
		end
		rescue ActiveRecord::RecordNotFound
			invalid_cart
	end

	def invalid_cart
		redirect_to root_path, notice: 'Invalid cart'
	end
end
