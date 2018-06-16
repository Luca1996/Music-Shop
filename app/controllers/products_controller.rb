class ProductsController < ApplicationController
    before_action :authenticate_user!, except: [:index,:show]
    # to allow delete request
    skip_before_action :verify_authenticity_token, :only => [:destroy]

    def new
        @product = Product.new
    end
    
    def edit
        @product = Product.find(params[:id])    
    end
    
    def index
        @products = Product.all
    end

    def show
        @product = Product.find(params[:id])        
    end
    
    def create
        @product = Product.new(product_params)
        compress_image
        @product.user = current_user
        # to add all relations
        if @product.save!
          redirect_to product_path(@product)
        else
            render 'new'
            flash.keep[:notice] = "Error in creating new product"
        end
    end
    
    def destroy
        @product = Product.find(params[:id])  
        @product.destroy
        redirect_to products_path
    end


    def update
        @product = Product.find(params[:id])        
        @product.update(product_params)
        compress_image
        @product.save
        redirect_to products_path()
    end
    
    
    
    private 
        def product_params
            params.require(:product).permit(:title,:brand,:model,:price,:quantity,:weight,:description,:image)           
        end

        def compress_image
            if !params[:product][:image].nil?
                b64 = Base64.encode64(params[:product][:image].read)
                @product.image = b64
            end
        end
end
