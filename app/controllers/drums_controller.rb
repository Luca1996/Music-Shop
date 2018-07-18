class DrumsController < ApplicationController
    before_action :authenticate_user!, except: [:index, :show]
	# to allow delete request
	skip_before_action :verify_authenticity_token, :only => [:destroy]
	include InstrumOwned

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
		@drum = Drum.find_by_id(params[:id])
		if instrum_owned_by_user?(@drum)
			@wal_price = Product.find_in_Walmart(@drum.product.model)
			@instrum = @drum
		else
			redirect_to root_path
			flash.keep[:alert] = "You can't edit this instrument"
		end
	end

	def create
		@drum = Drum.new(drum_params)
		@drum.product.user = current_user
		compress_image
		if @drum.save
			redirect_to drum_path(@drum)
			flash.keep[:notice] = "Drum create successfully"			
		else
			render "new"
		end
	end

	def destroy
		@drum = Drum.find(params[:id])
		if instrum_owned_by_user?(@drum)
			@drum.product.destroy
			@drum.destroy
			redirect_to products_path
		else
			redirect_to activities_index_path()
			flash.keep[:alert] = "You can't destroy the drum"
		end
	end

	def update
		@drum = Drum.find(params[:id])
		if instrum_owned_by_user?(@drum)
			@drum.update(drum_update_params)
			compress_image
			if @drum.save
				redirect_to drum_path(@drum)
				flash.keep[:notice] = "drum updated successfully"
			else
				render 'edit'
			end
		else
			redirect_to activities_index_path()
			flash.keep[:alert] = "You can't update this item"
		end
	end


	private 
		def drum_params
			params.require(:drum).permit(:pedals,:color,:cymbals,:toms, product_attributes: [:title,:brand,:model,:price,:quantity,:weight,:height,:length,:depth,:description,:image])
		end

		def drum_update_params
			params.require(:drum).permit(:pedals,:color,:cymbals,:toms, product_attributes: [:id,:title,:brand,:model,:price,:quantity,:weight,:height,:length,:depth,:description])
		end

		def compress_image
			if !params[:drum][:product_attributes][:image].nil?
				b64 = Base64.encode64(params[:drum][:product_attributes][:image].read)
				@drum.product.image = b64
			end
		end
		
end
