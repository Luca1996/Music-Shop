class PianosController < ApplicationController
	before_action :authenticate_user!, except: [:index, :show]
	# to allow delete request
	skip_before_action :verify_authenticity_token, :only => [:destroy]

	def index
		@pianos = Piano.all
	end

	def show 
		@piano = Piano.find_by_id(params[:id])
		if @piano == nil then
			 redirect_to products_path, notice: "The piano selected doesn't bellong to the list"
		end
	end

	def new
		@piano = Piano.new
		@piano.build_product	# create a Product object whose fields will be fillen by the form
	end

	def edit
		@piano = Piano.find_by_id(params[:id])
		if instrum_owned_by_user?(@piano)
			@wal_price = Product.find_in_Walmart(@piano.product.model)
			@instrum = @piano
		else
			redirect_to root_path
			flash.keep[:alert] = "You can't edit this instrument"
		end
	end


	def create
		@piano = Piano.new(piano_params)
		@piano.product.user = current_user
		compress_image
		if @piano.save
			redirect_to piano_path(@piano)
			flash.keep[:notice] = "Piano added successfully"
		else
			render "new"
			flash.keep[:alert] = "Error in creating new piano"
		end
	end
	

	def destroy
		@piano = Piano.find(params[:id])
		if @piano.product.user == current_user || current_user.admin?
			@piano.product.destroy
			@piano.destroy
			redirect_to products_path
			flash.keep[:notice] = "Piano removed from the list"
		else
			flash.keep[:alert] = "You can't delete this piano"
		end
	end

	def update
		@piano = Piano.find(params[:id])
		if @piano.product.user == current_user || current_user.admin?
			@piano.update(piano_update_params)
			compress_image
			@piano.save
			redirect_to piano_path(@piano)
			flash.keep[:notice] = "Piano update successfully"
		else
			redirect_to activities_index_path()
			flash.keep[:alert] = "You can't update this"
		end
		
	end

	private 
		def piano_params
			params.require(:piano).permit(:tipo, :color, :material, :n_keys, product_attributes: [:title,:brand,:model,:price,:quantity,:weight,:height,:length,:depth,:description,:image])
		end
		
		def piano_update_params
			params.require(:piano).permit(:tipo, :color, :material, :n_keys, product_attributes: [:id,:title,:brand,:model,:price,:quantity,:weight,:height,:length,:depth,:description])
		end

	    def compress_image
            if !params[:piano][:product_attributes][:image].nil?
                b64 = Base64.encode64(params[:piano][:product_attributes][:image].read)
                @piano.product.image = b64
            end
		end
		def instrum_owned_by_user?(instrum)
			if instrum.product.user == current_user || current_user.admin?
				return true
			end
			false
		end


end
