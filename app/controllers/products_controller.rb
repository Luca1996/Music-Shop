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
        #@product.imagess.purge if @product.imagess.attached?
        #@product.imagess.attach(params[:product][:imagess])
        
        # to add all relations
        if @product.save!
          redirect_to root_path
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
        redirect_to products_path()
    end
    
    
    
    private 
        def product_params
            params.require(:product).permit(:title,:brand,:model,:price,:quantity,:weight,:height,:length,:depth,:description,imagess: [])           
        end
        
end
