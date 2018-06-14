class ProductsController < ApplicationController
    before_action :authenticate_user!, except: [:index,:show]
    def new
        @product = Product.new
    end
    
    def edit
        # @product = Product.find(params[:id])    
    end
    
    def index
        @products = Product.all
    end

    def show
        # @product = Product.find(params[:id])        
    end
    
    def create
        @product = Product.new(product_params)
        # to add all relations
        if @product.save!
          redirect_to root_path
        else
            render 'new'
        end
    end
    
    def destroy
        # @product = Product.find(params[:id])  
        # @product.destroy
        # redirect_to products_path
    end


    def update
        # @product = Product.find(params[:id])        
        # @produce.update(product_params)
        # redirect_to product_path(product)
    end
    
    
    
    private 
        def product_params
            params.require(:title).permit(:brand,:model)            
        end
        
end
