class AdminPanelController < ApplicationController
    before_action :authenticate_user!
    
    def show
        if current_user.try(:admin?)
            @orders = Order.all()
            @users = User.all()
        else
            redirect_to root_path
            flash.keep[:alert] = "You cannot see this page"
        end
    end
    
    def ban
        if params[:email] && current_user.try(:admin?)
            @user = User.where('email LIKE?', params[:email] ))
            if @user.destroy(@user.ids)
                redirect_to root_path
                flash.keep[:notice] = "User banned"
            else
                render 'show'
                flash.keep[:alert] = "Problems in banning user"
            end
            
        end
    end
    
end
