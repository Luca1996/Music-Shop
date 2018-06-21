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
		require 'net/http'
        require 'json'
        
        url = 'http://api.walmartlabs.com/v1/search?query='+ @piano.product.title + '&format=json&apiKey=qf2a4tqhq4qdncvqrrkpvzt8'
        uri = URI(url)
        response = Net::HTTP.get(uri)
        @res = JSON.parse(response)
		@piano = Piano.find(params[:id])
	end

	def update
		@piano = Piano.find(params[:id])
		compress_image
		if @piano.update(piano_update_params)			
			redirect_to piano_path(@piano)
			flash.keep[:notice] = "Piano updated successfully"
		else
			redirect_to activities_index_path
			flash.keep[:alert] = "Can't update the piano"
		end
	end

	def show 
		@piano = Piano.find_by_id(params[:id])
		if @piano == nil then
			 redirect_to products_path, notice: "The piano selected doesn't bellong to the list"
		end
	end

	def create
		@piano = Piano.new(piano_params)
		@piano.product.user = current_user
		compress_image
		if @piano.save!
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
			flash.keep[:alert] = "You can't delete this item"
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
			flash.keep[:notice] = "You can't update this"
		end
		
	end
	

	private 
		def piano_params
			params.require(:piano).permit(:tipo, :color, :material, :n_keys, product_attributes: [:title,:brand,:model,:price,:quantity,:weight,:description,:image])
		end
		
		def piano_update_params
			params.require(:piano).permit(:tipo, :color, :material, :n_keys, product_attributes: [:id,:title,:brand,:model,:price,:quantity,:weight,:description])
		end

		def piano_update_params
			params.require(:piano).permit(:tipo, :color, :material, :n_keys, product_attributes: [:id,:title,:brand,:model,:price,:quantity,:weight,:description])
		end

	    def compress_image
            if !params[:piano][:product_attributes][:image].nil?
                b64 = Base64.encode64(params[:piano][:product_attributes][:image].read)
                @piano.product.image = b64
            end
        end


end
