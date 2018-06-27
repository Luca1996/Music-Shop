class ProductsController < ApplicationController
    before_action :authenticate_user!, except: [:index,:show,:grid,:search]
    # to allow delete request
    skip_before_action :verify_authenticity_token, :only => [:destroy]

# The methods commented are no loger needed, since we create, modify
# and destroy the products only through the specific instruments actions

=begin
    def new
        @product = Product.new
    end
   
    def edit
        @product = Product.find(params[:id])    
    end
=end    

    def index
        @products = Product.all
        if params[:brand] && params[:brand][0] != ""
            @products = Product.where('brand LIKE?', "%#{params[:brand][0]}%")
        end
        if params[:model] && params[:model][0] != ""
            @products = @products.select {|p| p.model == params[:model][0] }
        end
        if params[:min_price] && params[:min_price] != ""
            @products = @products.select {|p| p.price >= params[:min_price].to_f}
        end
        #raise @products.inspect
        if params[:max_price] && params[:max_price] != ""
            @products = @products.select {|p| p.price <= params[:max_price].to_f}
        end
    end

    def grid
    end

    def show
        @product = Product.find_by_id(params[:id])   
        if @product == nil then
            redirect_to products_path, notice: "The product selected doesn't belong to the list"
        end     
    end

=begin    
    def create
        @product = Product.new(product_params)
        @product.user = current_user
        compress_image
        if @product.save!
          redirect_to product_path(@product)
        else
            render 'new'
            flash.keep[:notice] = "Error in creating new product"
        end
    end
=end
    
    def destroy
        @product = Product.find(params[:id])  
        if @product.user == current_user || current_user.admin?
            @product.instrum.destroy
            @product.destroy
            redirect_to products_path
        else
            flash.keep[:notice] = "You can't delete this item"
        end
    end


    def search 
        match_string = params[:search]
        @products = Product.where('title LIKE?', "%#{match_string}%")
        render :index
    end

=begin
    def update
        @product = Product.find(params[:id])        
        if @product.user == current_user || current_user.admin?
            @product.update(product_params)
            compress_image
            @product.save
            redirect_to products_path()
        else 
            redirect_to products_path
            flash.keep[:notice] = "You can't modify the item"
        end
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
=end

end
