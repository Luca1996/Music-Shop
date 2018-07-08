class ProductsController < ApplicationController
    before_action :authenticate_user!, except: [:index,:show,:grid,:search]
    # to allow delete request
    skip_before_action :verify_authenticity_token, :only => [:destroy]


    def index
        @products = Product.all
        if params[:brand] && params[:brand] != ""
            @products = Product.where('brand LIKE?', "%#{params[:brand]}%")
        end
        if params[:model] && params[:model] != ""
            @products = @products.select {|p| p.model == params[:model] }
        end
        if params[:min_price] && params[:min_price] != ""
            @products = @products.select {|p| p.price >= params[:min_price].to_f}
        end
        if params[:max_price] && params[:max_price] != ""
            @products = @products.select {|p| p.price <= params[:max_price].to_f}
        end
    end

    def show
        @product = Product.find_by_id(params[:id])
        @comment = Comment.new
        if @product == nil then
            redirect_to products_path, notice: "The product selected doesn't belong to the list"
        end     
    end
    
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

        private 
        
            def products_params
                params.require(:product).permit(title,:brand,:model,:price,:quantity,:weight,:description,:image,:term,:s_price)
            end

end
