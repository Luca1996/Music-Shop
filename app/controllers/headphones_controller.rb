class HeadphonesController < ApplicationController
    before_action :authenticate_user!, except: [:index, :show]
	# to allow delete request
	skip_before_action :verify_authenticity_token, :only => [:destroy]

	def new
		@headphone = Headphone.new
		@headphone.build_product
	end

	def index
		@headphones = Headphone.all
	end

	def edit
		@headphone = Headphone.find(params[:id])
	end

	def show 
		@headphone = Headphone.find(params[:id])
	end

	def create
		@headphone = Headphone.new(headphone_params)
		@headphone.product.user = current_user
		compress_image
		if @headphone.save!
			redirect_to headphone_path(@headphone)
		else
			render "new"
			flash.keep[:notice] = "Error in creating new headphone"
		end
	end

	def destroy
		@headphone = Headphone.find(params[:id])
		if @headphone.product.user == current_user || current_user.admin?
			@headphone.product.destroy
			@headphone.destroy
			redirect_to products_path
		else
			flash.keep[:notice] = "You can't delete this item"
		end
	end

	def update
		@headphone = Headphone.find(params[:id])
		if @headphone.product.user == current_user || current_user.admin?
			@headphone.update(headphone_update_params)
			compress_image
			@headphone.save
			redirect_to headphone_path(@headphone)
			flash.keep[:notice] = "headphone update successfully"
		else
			redirect_to activities_index_path()
			flash.keep[:notice] = "You can't update this"
		end
		
	end
	
	private 
		def headphone_params
			params.require(:headphone).permit(:wireless,:bluetooth,:cacle_length,:impedence,:type, product_attributes: [:title,:brand,:model,:price,:quantity,:weight,:description,:image])
		end
		
		def headphone_update_params
			params.require(:headphone).permit(:wireless,:bluetooth,:cacle_length,:impedence,:type, product_attributes: [:id,:title,:brand,:model,:price,:quantity,:weight,:description])
		end

	    def compress_image
            if !params[:headphone][:product_attributes][:image].nil?
                b64 = Base64.encode64(params[:headphone][:product_attributes][:image].read)
                @headphone.product.image = b64
            end
        end

end
