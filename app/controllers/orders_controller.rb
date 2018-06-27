class OrdersController < ApplicationController
    before_action :authenticate_user!
    skip_before_action :verify_authenticity_token, :only => [:destroy]

    def index
        @orders = Order.all
    end
    
end
