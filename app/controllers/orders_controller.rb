class OrdersController < ApplicationController
    ##
    include CurrentCart
    before_action :set_cart, only: [:new, :create, :show]
    before_action :ensure_cart_isnt_empty, only: [:new, :create]
    ##

    before_action :authenticate_user!
    skip_before_action :verify_authenticity_token, :only => [:destroy]

    
    # def index
        # if current_user.try(:admin?)
            # @orders = Order.all
        # else
            # @orders = current_user.orders
        # end
    # end

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
        @order.line_items.each do |lineitem|
            lineitem.ensure_buyer_isnt_the_owner(current_user)
        end 

        temp = @order.save

        ## LAUNCH PAYOUT
        if @order.p_method == "PayPal"
            start_payment
            #start_payout
            return
        end
        ##

        if temp
            redirect_to order_path(@order)
            flash.keep[:notice] = "Created a new Order"
        else
            raise @order.inspect
            render 'new'
        end
    end
    
    ## callbacks for payment

    def payment_success
        payment_id = params.fetch(:paymentId, nil)
        @order = Order.find_by_id(params[:orderid])
        if payment_id.present?
            begin
                @payment = PayPalService.execute_payment(payment_id, params[:PayerID])
            rescue RuntimeError => exception
                raise @payment.inspect
            end
            start_payout
        end
    end

    def payment_cancel
        @order = Order.find_by_id(params[:id])
        @order.line_items.each do |li|
            li.delete_all_same_items
        end
        @order.destroy
        redirect_to root_path
    end

    ####



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
            @order.line_items.each do |lineitem|
                lineitem.delete_all_same_items
            end
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
            payout = PayPalService.new({order: @order}).create_payout
            #raise payout.inspect
            begin
                @payout_batch =payout.create 
            rescue RuntimeError => exception
                raise payout.inspect
            end
        end

        ## Call PayPalServices to start the payment
        def start_payment
            payment = PayPalService.new({order: @order}).create_payment
            #begin
                @payment = payment.create
                #raise payment.links.inspect
                @redirect_url = payment.links.find{|v| v.method == "REDIRECT"}.href
                redirect_to @redirect_url
            #rescue RuntimeError => exception
            #    raise payment.inspect
            #end
        end
        
end
