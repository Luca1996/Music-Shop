class PianosController < ApplicationController
	before_action :authenticate_user!, except: [:index, :show]
	# to allow delete request
	skip_before_action :verify_authenticity_token, :only => [:destroy]

	def new
		@piano = Piano.new
		@piano.build_product
	end

	def index
		@pianos = Piano.all
	end

	def edit
		@piano = Piano.find(params[:id])
	end

	def show 
		@piano = Piano.find(params[:id])
	end

	def create
		@piano = Piano.new(piano_params)
		@piano.product.user = current_user
		compress_image
		if @piano.save!
			redirect_to piano_path(@piano)
		else
			render "new"
			flash.keep[:notice] = "Error in creating new piano"
		end
	end

	def destroy
		@piano = Piano.find(params[:id])
		if @piano.product.user == current_user || current_user.admin?
			@piano.product.destroy
			@piano.destroy
			redirect_to products_path
		else
			flash.keep[:notice] = "You can't delete this item"
		end
	end
	# to do the update
	def update
		@piano = Piano.find(params[:id])
		if @piano.product.user == current_user || current_user.admin?
			@piano.product.update(product_params)
			@piano.update(piano_params)
			compress_image
			@piano.save
			redirect_to pianos_path()
		else
			redirect_to pianos_path()
			flash.keep[:notice] = "You can't update this"
		end
		
	end
	

	private 
		def piano_params
			params.require(:piano).permit(:tipo, :color, :material, :n_keys, product_attributes: [:title,:brand,:model,:price,:quantity,:weight,:description,:image])
		end
		
		def product_params
			params.require(:piano).permit(:product_attributes)
		end

	    def compress_image
            if !params[:piano][:product_attributes][:image].nil?
                b64 = Base64.encode64(params[:piano][:product_attributes][:image].read)
                @piano.product.image = b64
            end
        end


end
