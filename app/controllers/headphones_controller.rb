class HeadphonesController < ApplicationController
    before_action :authenticate_user!, except: [:index, :show]
	# to allow delete request
	skip_before_action :verify_authenticity_token, :only => [:destroy]

	def index
		@headphones = Headphone.all
	end

	def show 
		@headphone = Headphone.find(params[:id])
	end

	def new
		@headphone = Headphone.new
		@headphone.build_product
	end

	def edit
		@headphone = Headphone.find(params[:id])
	end


	def create
		@headphone = Headphone.new(headphone_params)
		@headphone.product.user = current_user
		compress_image
		if @headphone.save!
			redirect_to headphone_path(@headphone)
			flash.keep[:notice] = "Headphone created successfully"
		else
			render "new"
			flash.keep[:alert] = "Error in creating new headphone"
		end
	end

	def update
		@headphone = Headphone.find(params[:id])
		if @headphone.product.user == current_user || current_user.admin?
			@headphone.update(headphone_update_params)
			compress_image
			if @headphone.save
				redirect_to headphone_path(@headphone)
				flash.keep[:notice] = "Headphone update successfully"
			else
				render 'edit'
				flash.keep[:alert] = "Headphone not update"
			end
		else
			redirect_to activities_index_path()
			flash.keep[:alert] = "You can't update this headphone"
		end	
	end

	def destroy
		@headphone = Headphone.find(params[:id])
		if @headphone.product.user == current_user || current_user.admin?
			@headphone.product.destroy
			@headphone.destroy
			redirect_to products_path
		else
			flash.keep[:alert] = "You can't delete this headphone"
		end
	end
	
	private 
		def headphone_params
			params.require(:headphone).permit(:wireless,:bluetooth,:cacle_length,:impedence,:h_type, product_attributes: [:title,:brand,:model,:price,:quantity,:weight,:description,:image])
		end
		
		def headphone_update_params
			params.require(:headphone).permit(:wireless,:bluetooth,:cacle_length,:impedence,:h_type, product_attributes: [:id,:title,:brand,:model,:price,:quantity,:weight,:description])
		end

	    def compress_image
            if !params[:headphone][:product_attributes][:image].nil?
                b64 = Base64.encode64(params[:headphone][:product_attributes][:image].read)
                @headphone.product.image = b64
            end
        end

end
