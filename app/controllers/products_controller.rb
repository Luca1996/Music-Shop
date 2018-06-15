class ProductsController < ApplicationController
    before_action :authenticate_user!, except: [:index,:show]
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
        # to add all relations
        if @product.save!
          redirect_to root_path
        else
            render 'new'
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
        redirect_to products_path()
    end
    
    
    
    private 
        # we don't let the user set himself as admin obviously
        def product_params
            params.require(:product).permit(:title,:brand,:model,:price,:quantity,:weight,:description)           
        end
        
end
