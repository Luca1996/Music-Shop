class LineItemsController < ApplicationController
	include CurrentCart		# to use :set_cart
	before_action :set_cart, only: [:create, :destroy]
	skip_before_action :verify_authenticity_token, :only => [:create, :destroy]

	def index
		@line_items = LineItem.all
	end

	def show
		@line_item = LineItem.find_by_id(params[:id])
	end

	def create 
		product = Product.find(params[:product_id])
		@line_item = @cart.add_product(product)
		if @line_item.save
			redirect_to cart_path(@cart)
			flash.keep[:notice] = "Item was added to the cart"
		else 
			redirect_to root_path
			flash.keep[:alert] = "Can't add the item to the cart"
		end
	end

	# DELETE /line_items/:id
	def destroy
		@line_item = LineItem.find_by_id(params[:id])
		if @line_item.quantity > 1
			@line_item.quntity -= 1
		else
			@line_item.destroy
		end
		if @line_item.save
			redirect_to cart_path(@cart)
			flash.keep[:notice] = "Item was added to the cart"
		else 
			redirect_to root_path
			flash.keep[:alert] = "Caraise ActiveRecord::RecordNotFound.newn't add the item to the cart"
		end
	end

	# DELETE /line_items/destroy_all/:id
	def destroy_all
		@line_item = LineItem.find_by_id(params[:id])
		if @line_item.destroy
			redirect_to cart_path(@cart)
			flash.keep[:notice] = "Item was added to the cart"
		else 
			redirect_to root_path
			flash.keep[:alert] = "Can't add the item to the cart"
		end
	end

	private

		def line_item_params
			params.require(:line_item).permit(:product_id)
		end

end
