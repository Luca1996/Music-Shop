class LineItemsController < ApplicationController
	include CurrentCart		# to use :set_cart
	before_action :set_cart, only: [:create, :destroy, :destroy_all]
	skip_before_action :verify_authenticity_token, :only => [:create, :destroy, :destroy_all]

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
		# manage a wrong request to destroy a line_item
		if @line_item == nil || !is_right_cart?(@line_item)
			raise "qui"
			redirect_to cart_path(@cart), notice: "Can't find the item"
		end
		if @line_item.quantity > 1
			@line_item.quantity -=1
			@line_item.save
		else
			@line_item.destroy
		end
		redirect_to cart_path(@cart), notice: "The item was removed from the cart"
	end

	# DELETE /line_items/destroy_all/:id
	def destroy_all
		@line_item = LineItem.find_by_id(params[:id])
		# manage a wrong request to destroy a line_item
		if @line_item == nil || !is_right_cart?(@line_item)
			redirect_to cart_path(@cart), notice: "Can't find the item"
		end
		@line_item.destroy
		redirect_to cart_path(@cart), notice: "The item was removed from the cart"				
	end

	private

		def line_item_params
			params.require(:line_item).permit(:product_id)
		end

end
