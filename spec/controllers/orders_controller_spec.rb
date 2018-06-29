require 'rails_helper'

describe OrdersController, :type => :controller do 
    describe "GET index" do
        context "user request" do
            before do
                @user = FactoryBot.create(:user)
                sign_in @user
            end
            it "verifies user role" do
                expect(@user.admin).to eq(false)
            end
            it "populates an array of orders" do
                order = FactoryBot.create(:order)
                get :index
                expect(assigns(:orders)).to eq([order])
                expect(order.user_id).to eq(@user.id)  
            end
            it "renders index view" do
                get :index
                expect(response).to render_template :index
            end
        end
        context "admin request" do
            before do
                @admin = FactoryBot.create(:admin)
                sign_in @admin
            end
            it "verifies admin role" do
                expect(@admin.admin).to eq(true)
            end
            it "populates an array of all orders" do
                order = FactoryBot.create(:order)
                get :index
                expect(assigns(:orders)).to eq([order])
            end
            it "renders index view" do
                get :index
                expect(response).to render_template :index
            end
        end
        context "not logged user request" do
            it "redirect user to login page" do
                get :index
                expect(response).to redirect_to(new_user_session_path)
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
                expect(assigns(:order)).to eq(@order)
            end
            it "renders show page" do
                get :show, params: { id: @order.id }
                expect(response).to render_template :show
            end
        end
        context "not logged user" do
            before do
                @user = FactoryBot.create(:user)
                @order = FactoryBot.create(:order)
            end
            it "redirect to login page" do
                get :show, params: { id: @order.id }
                expect(response).to redirect_to(new_user_session_path)
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
                expect(response).to render_template :new
            end
        end
        context "not logged user" do
            it "redirect to login page" do
                get :new
                expect(response).to redirect_to(new_user_session_path)
            end
        end
    end
    describe "GET edit" do
        context "logged user" do
            before do
                @user = FactoryBot.create(:user)
                sign_in @user
                @order = FactoryBot.create(:order)
            end
            it "assigns the requested order to @order" do
                get :edit, params: { id: @order.id }
                expect(assigns(:order)).to eq(@order)
            end
            it "renders edit page" do
                get :edit, params: { id: @order.id }
                expect(response).to render_template :edit
            end
        end
        context "not logged user" do
            before do
                @user = FactoryBot.create(:user)
                @order = FactoryBot.create(:order)
            end
            it "redirect to login page" do
                get :edit, params: { id: @order.id }
                expect(response).to redirect_to(new_user_session_path)
            end
        end
    end
    describe "POST create" do
        before :each do
            @user = FactoryBot.create(:user)
            sign_in @user
        end
        context "with valid attributes" do
            params = FactoryBot.attributes_for(:order)
            it "creates a new order" do
                expect {
                    post :create, params: {order: params }
                }.to change(Order,:count).by(1)  
            end
            it "redirects to order page" do
                post :create, params: { order: params }
                expect(response).to redirect_to Order.last
            end
        end
        context "with invalid attributes" do
            params = FactoryBot.attributes_for(:invalid_order)
            it "does not create a new order" do
                expect {
                    post :create, params: {order: params}
                }.to_not change(Order,:count)
            end
            it "renders the new page" do
                post :create, params: {order: params}
                expect(response).to render_template :new
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
            params = FactoryBot.attributes_for(:order)
            it "located the requested order" do
                put :update, params: { id: @order.id, order: params }
                expect(assigns(:order)).to eq(@order)
            end
            it "verifies user that creates the order" do
                put :update, params:  { id: @order.id ,order: params }
                expect(@order.user_id).to eq(@user.id)
            end
            it "updates an order" do
                params = FactoryBot.attributes_for(:order, address: "Another_address")
                put :update, params: { id: @order.id , order: params }
                @order.reload
                expect(@order.address).to eq("Another_address") 
            end
            it "redirects to order page" do
                put :update, params: { id: @order.id,  order: params }
                expect(response).to redirect_to @order
            end
        end
        context "with invalid attributes" do
            params = FactoryBot.attributes_for(:order)
            it "located the requested order" do
                put :update, params: { id: @order.id , order: params}
                expect(assigns(:order)).to eq(@order)
            end
            it "verifies user that creates the order" do
                put :update, params: { id: @order.id ,order: params}
                expect(@order.user_id).to eq(@user.id)
            end
            it "does not update the order" do
                put :update, params: { id: @order.id , order: params, address: nil } 
                @order.reload
                expect(@order.address).to_not eq(nil) 
            end
            it "renders the order page" do
                put :update, params: { id: @order.id , order: params }
                expect(response).to redirect_to(order_path(@order))
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
                expect(@user.admin).to eq(true)
            end
            it "deletes the order" do
                expect{
                    delete :destroy, params: { id: @order.id }
                }.to  change(Order,:count).by(-1)
            end
            it "redirects to orders index" do
                delete :destroy, params: { id: @order.id }
                expect(response).to redirect_to(orders_path)
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
                expect(@order.user_id).to eq(@user.id)
            end
            it "deletes the order" do
                expect{
                    delete :destroy, params:  { id: @order.id }
                }.to  change(Order,:count).by(-1)
            end
            it "redirects to orders index" do
                delete :destroy, params: { id: @order.id }
                expect(response).to redirect_to(orders_path)
            end
        end
        context "not logged user" do
            before do
                @user = FactoryBot.create(:user)
                @order = FactoryBot.create(:order)
            end
            it "redirect to orders index" do
                delete :destroy, params: { id: @order.id }
                expect(response).to redirect_to(new_user_session_path)
            end
        end
    end
end