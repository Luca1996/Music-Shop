class OthersController < ApplicationController
	before_action :authenticate_user!, except: [:index, :show]
	# to allow delete request
	skip_before_action :verify_authenticity_token, :only => [:destroy]

	def new
		@other = Other.new
		@other.build_product
	end

	def edit
		@other = Other.find(params[:id])
	end

	def update
		@other = Other.find(params[:id])
		compress_image
		if @other.update(other_update_params)			
			redirect_to other_path(@other)
			flash.keep[:notice] = "Instrument updated successfully"
		else
			redirect_to activities_index_path
			flash.keep[:notice] = "Can't update the instrument"
		end
	end

	def show 
		@other = Other.find(params[:id])
	end

	def index
		@others = Other.all
	end

	def create
		@other = Other.new(other_params)
		@other.product.user = current_user
		compress_image
		if @other.save!
			redirect_to other_path(@other)
		else
			render "new"
			flash.keep[:notice] = "Error in creating new generic instrument"
		end
	end

	def destroy
		@other = Other.find(params[:id])
		if @other.product.user == current_user || current_user.admin?
			@other.product.destroy
			@other.destroy
			redirect_to products_path
		else
			flash.keep[:notice] = "You can't delete this item"
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
            if !params[:piano][:product_attributes][:image].nil?
                b64 = Base64.encode64(params[:piano][:product_attributes][:image].read)
                @piano.product.image = b64
            end
        end


end
