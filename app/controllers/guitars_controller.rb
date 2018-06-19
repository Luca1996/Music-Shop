class GuitarsController < ApplicationController
    before_action :authenticate_user!, except: [:index, :show]
	# to allow delete request
	skip_before_action :verify_authenticity_token, :only => [:destroy]

	def new
		@guitar = Guitar.new
		@guitar.build_product
	end

	def index
		@guitars = Guitar.all
	end

	def edit
		@guitar = Guitar.find(params[:id])
	end

	def show 
		@guitar = Guitar.find(params[:id])
	end

	def create
		@guitar = Guitar.new(guitar_params)
		@guitar.product.user = current_user
		compress_image
		if @guitar.save!
			redirect_to guitar_path(@guitar)
		else
			render "new"
			flash.keep[:notice] = "Error in creating new guitar"
		end
	end

	def destroy
		@guitar = Guitar.find(params[:id])
		if @guitar.product.user == current_user || current_user.admin?
			@guitar.product.destroy
			@guitar.destroy
			redirect_to products_path
		else
			flash.keep[:notice] = "You can't delete this item"
		end
	end

	def update
		@guitar = Guitar.find(params[:id])
		if @guitar.product.user == current_user || current_user.admin?
			@guitar.update(guitar_update_params)
			compress_image
			@guitar.save
			redirect_to guitar_path(@guitar)
			flash.keep[:notice] = "guitar update successfully"
		else
			redirect_to activities_index_path()
			flash.keep[:notice] = "You can't update this"
		end
	end

	private 
		def guitar_params
			params.require(:guitar).permit(:hand, :color, :material, :chords,:digital, product_attributes: [:title,:brand,:model,:price,:quantity,:weight,:description,:image])
		end

		def guitar_update_params
			params.require(:guitar).permit(:hand, :color, :material, :chords,:digital, product_attributes: [:id,:title,:brand,:model,:price,:quantity,:weight,:description])
		end


	    def compress_image
            if !params[:guitar][:product_attributes][:image].nil?
                b64 = Base64.encode64(params[:guitar][:product_attributes][:image].read)
                @guitar.product.image = b64
            end
        end
end
