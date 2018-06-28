class OrdersController < ApplicationController
    before_action :authenticate_user!
    skip_before_action :verify_authenticity_token, :only => [:destroy]

    def index
        if current_user.try(:admin?)
            @orders = Order.all
        else
            @orders = current_user.orders
        end
    end

    def show
          @order = Order.find(params[:id])      
    end

    def new
        @order = Order.new
    end
    
    def edit
        @order = Order.find(params[:id])
    end
    
    def create
        @order = Order.new(order_params)
        @order.user = current_user
        if @order.save
            redirect_to order_path(@order)
            flash.keep[:notice] = "Created a new Order"
        else
            render 'new'
            flash.keep[:alert] = "Error in creating Order"
        end
    end
    
    
    private
        def order_params
            params.require(:order).permit(:address,:t_num,:p_method)
        end
end
