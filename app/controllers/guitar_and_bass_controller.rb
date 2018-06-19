class GuitarAndBassController < ApplicationController
    before_action :authenticate_user!, except: [:index, :show]
	# to allow delete request
	skip_before_action :verify_authenticity_token, :only => [:destroy]

	def new
		@piano = Piano.new
		@piano.build_product
	end

	def index
		@guitars = GuitarAndBass.all
	end

	def edit
		@guitar = GuitarAndBass.find(params[:id])
	end

	def show 
		@guitar = GuitarAndBass.find(params[:id])
	end

	def create
		@guitar = GuitarAndBass.new(guitar_and_bass_params)
		@guitar.product.user = current_user
		compress_image
		if @guitar.save!
			redirect_to guitar_path(@guitar)
		else
			render "new"
			flash.keep[:notice] = "Error in creating new piano"
		end
	end

	def destroy
		@guitar = GuitarAndBass.find(params[:id])
		if @guitar.product.user == current_user || current_user.admin?
			@guitar.product.destroy
			@guitar.destroy
			redirect_to products_path
		else
			flash.keep[:notice] = "You can't delete this item"
		end
	end

	private 
		def guitar_and_bass_params
			params.require(:guitar_and_bass).permit(:tipo, :color, :material, :n_keys, product_attributes: [:title,:brand,:model,:price,:quantity,:weight,:description,:image])
		end

	    def compress_image
            if !params[:guitar_and_bass][:product_attributes][:image].nil?
                b64 = Base64.encode64(params[:guitar_and_bass][:product_attributes][:image].read)
                @guitar.product.image = b64
            end
        end
end
