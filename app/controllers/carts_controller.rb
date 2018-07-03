class CartsController < ApplicationController
 before_action :select_cart, only: [:show, :destroy]
 skip_before_action :verify_authenticity_token, :only => [:destroy]

def show 
end

def index
	if current_user != nil && current_user.admin
		@carts = Cart.all
	else
		invalid_cart
	end
end

def destroy
	if is_my_cart?(@cart)
		@cart.line_items.each do |li|
			li.product.quantity += li.quantity
			li.product.save
		end
		@cart.destroy 
		session[:cart_id] = nil
		redirect_to root_path, notice: "Cart emptied"
	else
		redirect_to root_path, alert: "Can't empty the selected cart"
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

	def is_my_cart?(cart)
		if cart.id == session[:cart_id] || (current_user != nil && current_user.admin)
			return true
		end
		false
	end

	def invalid_cart
		redirect_to root_path, alert: 'Invalid cart'
	end
end
