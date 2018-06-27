require 'rails_helper'

describe OrdersController, :type => :controller do 
    describe "GET index" do
        context "user request" do
            before do
                @user = FactoryBot.create(:user)
                sign_in @user
            end
            it "verifies user role" do
                @user.admin.should eq("false")
            end
            it "populates an array of orders" do
                order = FactoryBot.create(:order)
                get :index
                assigns(:orders).should eq(order)
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
                @admin.admin.should eq("true")
            end
            it "populates an array of all orders" do
                order = FactoryBot.create(:order)
                get :index
                assigns(:orders).should eq(order)
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
            end
            it "assigns the requested order to @order" do
                order = FactoryBot.create(:order)
                get :show, id: order
                assigns(:order).should eq(order)
            end
            it "renders show page" do
                get :show, id: FactoryBot.create(order)
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
                    post :create, order: FactoryBot.attributes_for(:order)
                }.to change(Order,:count).by(1)  
            end
            it "redirects to order page" do
                post :create, order: FactoryBot.attributes_for(:order)
                response.should redirect_to Order.last
            end
        end
        context "with invalid attributes" do
            it "does not create a new order" do
                expect {
                    post :create, order: FactoryBot.attributes_for(:invalid_order)
                }.to_not change(Order,:count)
            end
            it "renders the new page" do
                post :create, order: FactoryBot.attributes_for(:invalid_order)
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
                put :update, id: @order, order: FactoryBot.attributes_for(:order)
                assigns(:order).should eq(@order)
            end
            it "verifies user that creates the order" do
                put :update, id: @order, order: FactoryBot.attributes_for(:order)
                @order.user_id.should eq(@user.id)
            end
            it "updates an order" do
                put :update, id: @order, order: FactoryBot.attributes_for(:order, address: "Another_address")
                @order.reload
                @order.address.should eq("Another_address") 
            end
            it "redirects to order page" do
                put :create, id: @order, order: FactoryBot.attributes_for(:order)
                response.should redirect_to @order
            end
        end
        context "with invalid attributes" do
            it "located the requested order" do
                put :update, id: @order, order: FactoryBot.attributes_for(:invalid_order)
                assigns(:order).should eq(@order)
            end
            it "verifies user that creates the order" do
                put :update, id: @order, order: FactoryBot.attributes_for(:invalid_order)
                @order.user_id.should eq(@user.id)
            end
            it "does not update the order" do
                put :update, id: @order, order: FactoryBot.attributes_for(:order, address: "Invalid_address")
                @order.reload
                @order.address.should_not eq("Invalid_address") 
            end
            it "renders the edit page" do
                put :update, id: @order, order: FactoryBot.attributes_for(:order)
                response.should render_template :edit
            end    
        end
    end
    describe "DELETE destroy" do
        before :each do
            @order = FactoryBot.create(:order)
        end
        context "admin" do
            before do
            @user = FactoryBot.create(:admin)
            sign_in @user
            end
            it "verifies admin role" do
                delete :destroy, id: @order
                @user.admin.should eq("true")
            end
            it "deletes the order" do
                expect{
                    delete :destroy, id: @order
                }.to  change(Order,:count).by(-1)
            end
            it "redirects to orders index" do
                delete :destroy, id: @order
                response.should redirect_to(orders_path)
            end
        end
        context "user" do
            before do
                @user = FactoryBot.create(:user)
                sign_in @user
            end
            it "verifies user that creates the order" do
                delete :destroy, id: @order
                @order.user_id.should eq(@user.id)
            end
            it "deletes the order" do
                expect{
                    delete :destroy, id: @order
                }.to  change(Order,:count).by(-1)
            end
            it "redirects to orders index" do
                delete :destroy, id: @order
                response.should redirect_to(orders_path)
            end
        end
        context "not logged user" do
            it "redirect to orders index" do
                delete :destroy, id: @orderd
                response.should redirect_to(orders_path)
            end
        end
    end
end