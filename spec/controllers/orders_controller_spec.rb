require 'rails_helper'

describe OrdersController, :type => :controller do 
    describe "GET index" do
        context "user request" do
            before do
                @user = FactoryBot.create(:user)
                sign_in @user
            end
            it "verifies user role" do
                @user.admin.should eq(false)
            end
            it "populates an array of orders" do
                order = FactoryBot.create(:order)
                get :index
                expect(assigns(:orders).should eq([order]))
            end
            it "renders index view" do
                get :index
                response.should render_template :index
            end
        end
        context "admin request" do
            before do
                @admin = FactoryBot.create(:admin)
                sign_in @admin
            end
            it "verifies admin role" do
                @admin.admin.should eq(true)
            end
            it "populates an array of all orders" do
                order = FactoryBot.create(:order)
                get :index
                expect(assigns(:orders).should eq([order]))
            end
            it "renders index view" do
                get :index
                response.should render_template :index
            end
        end
        context "not logged user request" do
            it "redirect user to login page" do
                get :index
                response.should redirect_to(new_user_session_path)
            end
        end
        
    end
    describe "GET show" do
        context "logged user" do
            before do
                @user = FactoryBot.create(:user)
                sign_in @user
                @order = FactoryBot.create(:order)
            end
            it "assigns the requested order to @order" do
                
                get :show, params: { id: @order.id }
                assigns(:order).should eq(@order)
            end
            it "renders show page" do
                get :show, params: { id: @order.id }
                response.should render_template :show
            end
        end
        context "not logged user" do
            it "redirect to login page" do
                get :show
                response.should redirect_to(new_user_session_path)
            end
        end
    end
    describe "GET new" do
        context "logged user" do
            before do
                @user = FactoryBot.create(:user)
                sign_in @user
            end
            it "renders new page" do
                get :new
                response.should render_template :new
            end
        end
        context "not logged user" do
            it "redirect to login page" do
                get :new
                response.should redirect_to(new_user_session_path)
            end
        end
    end
    describe "POST create" do
        before :each do
            @user = FactoryBot.create(:user)
            sign_in @user
        end
        context "with valid attributes" do
            it "creates a new order" do
                expect {
                    post :create, params: { order: @order_attributes }
                }.to change(Order,:count).by(1)  
            end
            it "redirects to order page" do
                post :create, params: { order: @order_attributes }
                response.should redirect_to Order.last
            end
        end
        context "with invalid attributes" do
            it "does not create a new order" do
                expect {
                    post :create, params: {order: @invalid_order_attridubes}
                }.to_not change(Order,:count)
            end
            it "renders the new page" do
                post :create, params: {order: @invalid_order_attridubes}
                response.should render_template :new
            end    
        end
    end
    describe "PUT update" do
        before :each do
            @user = FactoryBot.create(:user)
            sign_in @user
            @order = FactoryBot.create(:order)
        end
        context "with valid attributes" do
            it "located the requested order" do
                put :update, params: { id: @order.id }, params: { order: @order_attributes }
                assigns(:order).should eq(@order)
            end
            it "verifies user that creates the order" do
                put :update, params:  { id: @order.id ,order: @order_attributes }
                @order.user_id.should eq(@user.id)
            end
            it "updates an order" do
                put :update, params: { id: @order.id }, params: { order: @order_attributes, address: "Invalid Address" }
                @order.reload
                @order.address.should eq("Another_address") 
            end
            it "redirects to order page" do
                put :update, params: { id: @order.id }, params: { order: @order_attributes }
                response.should redirect_to @order
            end
        end
        context "with invalid attributes" do
            it "located the requested order" do
                put :update, params: { id: @order.id }, params: {order: @invalid_order_attridubes}
                assigns(:order).should eq(@order)
            end
            it "verifies user that creates the order" do
                put :update, params: { id: @order.id }, params: {order: @invalid_order_attridubes}
                @order.user_id.should eq(@user.id)
            end
            it "does not update the order" do
                put :update, params: { id: @order.id }, params: { order: @order_attributes, address: "Invalid Address" } 
                @order.reload
                @order.address.should_not eq("Invalid_address") 
            end
            it "renders the edit page" do
                put :update, params: { id: @order.id }, params: { order: @order_attributes }
                response.should render_template :edit
            end    
        end
    end
    describe "DELETE destroy" do
        context "admin" do
            before do
                @user = FactoryBot.create(:admin)
                sign_in @user
                @order = FactoryBot.create(:order)
            end
            it "verifies admin role" do
                delete :destroy, params: { id: @order.id }
                @user.admin.should eq("true")
            end
            it "deletes the order" do
                expect{
                    delete :destroy, params: { id: @order.id }
                }.to  change(Order,:count).by(-1)
            end
            it "redirects to orders index" do
                delete :destroy, params: { id: @order.id }
                response.should redirect_to(orders_path)
            end
        end
        context "user" do
            before do
                @user = FactoryBot.create(:user)
                sign_in @user
                @order = FactoryBot.create(:order)
            end
            it "verifies user that creates the order" do
                delete :destroy, params: { id: @order.id }
                @order.user_id.should eq(@user.id)
            end
            it "deletes the order" do
                expect{
                    delete :destroy, params:  { id: @order.id }
                }.to  change(Order,:count).by(-1)
            end
            it "redirects to orders index" do
                delete :destroy, params: { id: @order.id }
                response.should redirect_to(orders_path)
            end
        end
        context "not logged user" do
            before do
                @order = FactoryBot.create(:order)
            end
            it "redirect to orders index" do
                delete :destroy, params: { id: @order.id }
                response.should redirect_to(orders_path)
            end
        end
    end
end