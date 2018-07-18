class OthersController < ApplicationController
	before_action :authenticate_user!, except: [:index, :show]
	# to allow delete request
	skip_before_action :verify_authenticity_token, :only => [:destroy]
	include InstrumOwned

	def index
		@others = Other.all
	end
	
	def show 
		@other = Other.find_by_id(params[:id])
		if @other == nil then
			redirect_to products_path, notice: "The instrument selected doesn't belong to the list"
		end
	end

	def new
		@other = Other.new
		@other.build_product
	end

	def edit
		@other = Other.find(params[:id])
		if instrum_owned_by_user?(@other)
			@wal_price = Product.find_in_Walmart(@other.product.model)
			@instrum = @other
		else
			redirect_to root_path
			flash.keep[:alert] = "You can't edit this instrument"
		end
	end

	def create
		@other = Other.new(other_params)
		@other.product.user = current_user
		compress_image
		if @other.save
			redirect_to other_path(@other)
			flash.keep[:notice] = "Instrument added successfully"
		else
			render "new"
		end
	end
	
	def update
		@other = Other.find(params[:id])
		if @other.product.user == current_user || current_user.admin?
			@other.update(other_update_params)
			compress_image
			if @other.save
				redirect_to other_path(@other)
				flash.keep[:notice] = "Other update successfully"
			else
				render 'edit'
			end
		else
			redirect_to activities_index_path()
			flash.keep[:alert] = "You can't update this item"
		end	
	end

	def destroy
		@other = Other.find(params[:id])
		if @other.product.user == current_user || current_user.admin?
			@other.product.destroy
			@other.destroy
			redirect_to products_path
			flash.keep[:notice] = "Item removed from the list"
		else
			redirect_to activities_index_path()
			flash.keep[:alert] = "You can't delete this item"
		end
	end

	private 
		def other_params
			params.require(:other).permit(:tipo, product_attributes: [:title,:brand,:model,:price,:quantity,:weight,:description,:image])
		end

		def other_update_params
			params.require(:other).permit(:tipo, product_attributes: [:id,:title,:brand,:model,:price,:quantity,:weight,:description])
		end

		def compress_image
			if !params[:other][:product_attributes][:image].nil?
				b64 = Base64.encode64(params[:other][:product_attributes][:image].read)
				@other.product.image = b64
			end
		end

end
