class OrdersController < ApplicationController
    ##
    include CurrentCart
    before_action :set_cart, only: [:new, :create, :show]
    before_action :ensure_cart_isnt_empty, only: [:new, :create]
    ##

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
        if Order.exists?(params[:id])
            @order = Order.find(params[:id])
        else
            render file: "#{Rails.root}/public/404.html" , status: 404
        end
    end
    
    def create
        @order = Order.new(order_params)
        @order.user = current_user
        @order.add_items_from_cart(@cart)
        ## LAUNCH PAYOUT
        if @order.p_method == 0
            start_payout
        end
        ##
        if @order.save
            redirect_to order_path(@order)
            flash.keep[:notice] = "Created a new Order"
        else
            render 'new'
            flash.keep[:alert] = "Error in creating Order"
        end
    end
    
    def update
        @order = Order.find(params[:id])
        if @order.user == current_user && @order.updated_at + 3.day > Date.current 
            @order.update(order_params)
            if @order.save
                redirect_to order_path(@order)
                flash.keep[:notice] = "Order updated"
            else
                render 'edit'
                flash.keep[:alert] = "Problems in update"
            end
        else
            redirect_to edit_order_path(@order)
            flash.keep[:alert] = "You can't update the order"
        end
    end

    def destroy
        @order = Order.find(params[:id])
        if @order.user == current_user || current_user.try(:admin?)
            @order.destroy
            redirect_to orders_path
            flash.keep[:notice] = "Orders cancelled"
        else
            redirect_to orders_path
            flash.keep[:alert] = "You can't cancel the order"
        end
    end
    
    
    
    private
        def order_params
            params.require(:order).permit(:address,:t_num,:p_method)
        end

        def ensure_cart_isnt_empty
            if @cart.line_items.empty?
                redirect_to root_path, alert: "Cart is empty, can't proceed to checkout"
            end
        end
        

        
        ## Call PayPalServices to start the payout
        def start_payout
            payout = PayPalService.new({order: @order})
            
            begin
                @payout_batch =payout.create_payout   
            rescue ResourceNotFound => exception
                raise payout.inspect
            end
        end

        
end
