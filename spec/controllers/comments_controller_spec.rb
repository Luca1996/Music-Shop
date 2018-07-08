require 'rails_helper'

describe CommentsController, :type => :controller do
    describe "GET edit" do
        context "logged user" do
            before do
                @user = FactoryBot.create(:user)
                @c_user = FactoryBot.create(:c_user)
                sign_in @c_user
                @drum = FactoryBot.create(:drum)
                @product = FactoryBot.create(:c_prod)
                @comment = FactoryBot.create(:comment)
            end
            it "assigns the requested comment to @comment" do
                get :edit, params: { product_id: @product.id, id: @comment.id}
                expect(assigns(:comment)).to eq(@comment)
            end
            it "renders edit page" do
                get :edit, params: { product_id: @product.id, id: @comment.id}
                expect(response).to  render_template :edit
            end
        end
        context "not logged user" do
            before do
                @user = FactoryBot.create(:user)
                @c_user = FactoryBot.create(:c_user)
                @drum = FactoryBot.create(:drum)
                @product = FactoryBot.create(:c_prod)
                @comment = FactoryBot.create(:comment)
            end
            it "redirect to login page" do
                get :edit, params: { product_id: @product.id, id: @comment.id}
                expect(response).to  redirect_to(new_user_session_path)
            end
        end
    end
    describe "POST create" do
        before do
            @user = FactoryBot.create(:user)
            @c_user = FactoryBot.create(:c_user)
            @drum = FactoryBot.create(:drum)
            @product = FactoryBot.create(:c_prod)
        end
        context "with valid attributes" do
            before do
                sign_in @c_user
            end
            params = FactoryBot.attributes_for(:comment)
            it "verifies that user who comment is not the owner of the product" do
                post :create, params: { product_id: @product.id, comment: params }
                expect(@c_user).to_not eq(@product.user)
            end
            it "creates a new comment" do
                expect{
                    post :create, params: { product_id: @product.id, comment: params }
                }.to change(Comment,:count).by(1)
            end
            it "redirects to product page" do
                post :create, params: { product_id: @product.id, comment: params }
                expect(response).to redirect_to product_path(@product)
            end
        end
        context "with invalid attributes" do
            before do
                sign_in @c_user
            end
            params = FactoryBot.attributes_for(:invalid_comment)
            it "does not create comment" do
                expect{
                    post :create, params: { product_id: @product.id, comment: params }
                }.to_not change(Comment,:count)
            end
            it "redirects to product page" do
                post :create, params: { product_id: @product.id, comment: params }
                expect(response).to redirect_to product_path(@product)
            end
        end
        context "not logged user" do
            params = FactoryBot.attributes_for(:comment)
            it "redirect to login page" do
                post :create, params: { product_id: @product.id, comment: params }
                expect(response).to  redirect_to(new_user_session_path)
            end
        end    
    end
    describe "PUT update" do
        before :each do
            @user = FactoryBot.create(:user)
            @c_user = FactoryBot.create(:c_user)
            @drum = FactoryBot.create(:drum)
            @product = FactoryBot.create(:c_prod)
            @comment = FactoryBot.create(:comment)
        end
        context "with valid attributes" do
            before do
                sign_in @c_user 
            end
            params = FactoryBot.attributes_for(:comment)
            it "locates the requested comment" do
                put :update, params: { product_id: @product.id, id: @comment.id, comment: params}
                expect(assigns(:comment)).to eq(@comment)
            end
            it "verifies user that created the order" do
                put :update, params: { product_id: @product.id, id: @comment.id, comment: params}
                expect(@comment.user_id).to eq(@c_user.id)
            end
            it "updates the comment" do
                params = FactoryBot.attributes_for(:comment, text: "New_text")
                put :update, params: { product_id: @product.id, id: @comment.id, comment: params}
                @comment.reload
                expect(@comment.text).to eq("New_text")
            end
            it "redirects to product page" do
                put :update, params: { product_id: @product.id, id: @comment.id, comment: params}
                expect(response).to  redirect_to @product
            end
        end
        context "with invalid attributes" do
            before do
                sign_in @c_user 
            end
            params = FactoryBot.attributes_for(:comment)
            it "locates the requested comment" do
                put :update, params: { product_id: @product.id, id: @comment.id, comment: params}
                expect(assigns(:comment)).to eq(@comment)
            end
            it "verifies user that created the comment" do
                put :update, params: { product_id: @product.id, id: @comment.id, comment: params}
                expect(@comment.user_id).to eq(@c_user.id)
            end
            it "does not update the comment" do
                put :update, params: { product_id: @product.id, id: @comment.id, comment: params,title: nil}
                @comment.reload
                expect(@comment.title).to_not eq(nil)
            end
            it "renders edit page" do
                params = FactoryBot.attributes_for(:comment,title: nil)
                put :update, params: { product_id: @product.id, id: @comment.id, comment: params}
                @comment.reload
                expect(response).to render_template :edit
            end
        end
        context "not valid user" do
            before do
                sign_in @user
            end
            params = FactoryBot.attributes_for(:comment)
            it "locates the requested comment" do
                put :update, params: { product_id: @product.id, id: @comment.id, comment: params}
                expect(assigns(:comment)).to eq(@comment)
            end
            it "verifies user" do
                put :update, params: { product_id: @product.id, id: @comment.id, comment: params}
                expect(@comment.user).to_not eq(@user)
            end
            it "redirect to product page" do
                put :update, params: { product_id: @product.id, id: @comment.id, comment: params}
                expect(response).to redirect_to @product
            end            
        end
        context "not logged user" do
            params = FactoryBot.attributes_for(:comment)
            it "redirects to login page" do
                put :update, params: { product_id: @product.id, id: @comment.id, comment: params}
                expect(response).to redirect_to new_user_session_path  
            end
            
        end
        
    end
    describe "DELETE destroy" do
        before :each do
            @admin = FactoryBot.create(:admin)
            @user = FactoryBot.create(:user)
            @c_user = FactoryBot.create(:c_user)
            @drum = FactoryBot.create(:drum)
            @product = FactoryBot.create(:c_prod)
            @comment = FactoryBot.create(:comment)
        end
        context "admin" do
            before do
                sign_in @admin
            end
            params = FactoryBot.attributes_for(:comment)            
            it "verifies admin role" do
               delete :destroy, params: { product_id: @product.id, id: @comment.id, comment: params}
               expect(@admin.admin).to eq(true)  
            end
            it "deletes the comment" do
                expect{
                    delete :destroy, params: { product_id: @product.id, id: @comment.id, comment: params}
                }.to change(Comment,:count).by(-1)
            end
            it "redirects to product page" do
                delete :destroy, params: { product_id: @product.id, id: @comment.id, comment: params}
                expect(response).to redirect_to @product
            end
        end
        context "correct user" do
            before do
                sign_in @c_user
            end
            params = FactoryBot.attributes_for(:comment)
            it "verifies user" do
                delete :destroy, params: { product_id: @product.id, id: @comment.id, comment: params}
                expect(@comment.user_id).to eq(@c_user.id)
            end
            it "deletes the comment" do
                expect{
                    delete :destroy, params: { product_id: @product.id, id: @comment.id, comment: params}
                }.to change(Comment,:count).by(-1)
            end
            it "redirects to product page" do
                delete :destroy, params: { product_id: @product.id, id: @comment.id, comment: params}
                expect(response).to redirect_to @product
            end
        end
        context "invalid user" do
            before do
                sign_in @user
            end
            params = FactoryBot.attributes_for(:comment)
            it "verifies user" do
                delete :destroy, params: { product_id: @product.id, id: @comment.id, comment: params}
                expect(@comment.user_id).to_not eq(@user.id)
            end
            it "does not delete comment" do
                expect{
                    delete :destroy, params: { product_id: @product.id, id: @comment.id, comment: params}
                }.to_not change(Comment,:count)
            end
        end
        context "not logged user" do
            params = FactoryBot.attributes_for(:comment)
            it "redirects to login page" do
                delete :destroy, params: { product_id: @product.id, id: @comment.id, comment: params}
                expect(response).to redirect_to new_user_session_path
            end 
        end 
    end
end
