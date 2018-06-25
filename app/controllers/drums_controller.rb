class DrumsController < ApplicationController
    before_action :authenticate_user!, except: [:index, :show]
	# to allow delete request
	skip_before_action :verify_authenticity_token, :only => [:destroy]
	
	def index
		@drums = Drum.all
	end
	
	def show 
		@drum = Drum.find(params[:id])
	end

	def new
		@drum = Drum.new
		@drum.build_product
	end

	def edit
		@drum = Drum.find(params[:id])
		
        url = 'http://api.walmartlabs.com/v1/search?query='+ @drum.product.title + '&format=json&apiKey=qf2a4tqhq4qdncvqrrkpvzt8'
        uri = URI(url)
        response = Net::HTTP.get(uri)
        @res = JSON.parse(response)
		
	end

	def create
		@drum = Drum.new(drum_params)
		@drum.product.user = current_user
		compress_image
		if @drum.save!
			redirect_to drum_path(@drum)
			flash.keep[:notice] = "You successfully create a new Drum"
		else
			render "new"
			flash.keep[:alert] = "Error in creating new drum"
		end
	end

	def update
		@drum = Drum.find(params[:id])
		if @drum.product.user == current_user || current_user.admin?
			@drum.update(drum_update_params)
			compress_image
			@drum.save
			redirect_to drum_path(@drum)
			flash.keep[:notice] = "Drum update successfully"
		else
			redirect_to activities_index_path()
			flash.keep[:alert] = "You can't update the drum"
		end
	end

	def destroy
		@drum = Drum.find(params[:id])
		if @drum.product.user == current_user || current_user.admin?
			@drum.product.destroy
			@drum.destroy
			redirect_to products_path
			flash.keep[:notice] = "Drum deleted successfully"
		else
			flash.keep[:alert] = "You can't delete this item"
		end
	end


	private 
		def drum_params
			params.require(:drum).permit(:pedals,:color,:cymbals,:toms, product_attributes: [:title,:brand,:model,:price,:quantity,:weight,:description,:image])
		end

		def drum_update_params
			params.require(:drum).permit(:pedals,:color,:cymbals,:toms, product_attributes: [:id,:title,:brand,:model,:price,:quantity,:weight,:description])
		end
		
	    def compress_image
            if !params[:drum][:product_attributes][:image].nil?
                b64 = Base64.encode64(params[:drum][:product_attributes][:image].read)
                @drum.product.image = b64
            end
        end
end
