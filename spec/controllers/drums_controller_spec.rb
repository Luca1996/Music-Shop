require 'rails_helper'

describe DrumsController do
    describe 'get index' do
        context "user request the index" do
            it "makes the array of drums available to the view" do
                #Arrange
                drums = [double(:drum),double(:drum)]
                allow(Drum).to receive(:all) {drums}
                #Act
                get :index
                #Assert
                expect(assigns(:drums)).to eq(drums)
            end

            it "should select the index template for rendering" do
                #Act
                get :index
                #Assert
                expect(response).to render_template :index
            end
        end
    end

    describe 'get show' do
        context "user request a drum in database" do
            before do
                @drum = double(:drum, id: 144, product: nil)
            end
            it "makes the drum selected available" do
                #Arrange
                allow(Drum).to receive(:find) { @drum }
                #Act
                get :show, params: {id: @drum.id }
                #Assert
                expect(assigns(:drum)).to eq(@drum)
            end

            it "should select the show template for rendering" do
                #Arrange
                allow(Drum).to receive(:find) { @drum}
                #Act
                get :show, params: {id: @drum.id}
                #Assert
                expect(response).to render_template :show
            end
        end
        
        context "user request a drum NOT in database" do
            it "should throw RecordNotFound exception" do
                #Act - Assert
                expect{ get :show, params: {id: "unvalid-item"}}.to raise_error(ActiveRecord::RecordNotFound)
            end
        end
    
    end

    describe 'get new' do
        context 'user logged in' do
            before do
                @user = FactoryBot.create(:user)
                sign_in @user
            end
            it "should create an object to initialize the template fields" do
                #Act
                get :new
                #Assert
                expect(assigns(:drum)).not_to eq(nil)
                expect(assigns(:drum).product).not_to eq(nil)
            end
            
            it "should select the new template for rendering" do
                #Act
                get :new
                #Assert
                expect(response).to render_template :new
            end
        end

        context 'user not logged in' do
            it "should redirect_to login page" do
                #Act
                get :new
                #Assert
                expect(response).to redirect_to(new_user_session_path)
            end

            it "should alert the user with a message" do
                #Arrange
                #Act
                get :new
                #Assert
                expect(flash[:alert]).to eq("You need to sign in or sign up before continuing.")
            end
        end
    
    end



    describe 'edit' do 
        context "unregistered user" do

            it "should signal the error in the alert field" do
                #Act
                get :edit, params: { id: 12 }
                #Assert
                expect(flash[:alert]).to eq("You need to sign in or sign up before continuing.")            
            end

            it "should redirect to sign_in page " do
                #Act
                get :edit, params: { id: 12 }
                #Assert
                expect(response).to redirect_to new_user_session_path
            end
        end

        context "with registered user, who doen't own the required item" do
            before do 
                @user = FactoryBot.create(:user)
                sign_in @user
                @product = double(:product, model: "CX122", brand: "CASIO", user: nil)
                @drum = double(:drum, id: 3, product: @product)
                allow(Drum).to receive(:find_by_id) { @drum }
            end

            it "should signal the error in the alert field" do
                #Act
                get :edit, params: { id: 12 }
                #Assert
                expect(flash[:alert]).to eq("You can't edit this instrument")
            end

            it "should redirect to root_path" do
                #Act
                get :edit, params: { id: 12 }
                #Assert
                expect(response).to redirect_to root_path
            end
        end

        context "with registered user, who owns the required item" do
            before do
                @user = FactoryBot.create(:user)
                sign_in @user
                @product = double(:product, model: "CX122", brand: "CASIO", user: @user )
                @drum = double(:drum, id: 3, product: @product)
                allow(Drum).to receive(:find_by_id) {@drum}
            end

            it "should retrieve the drum by id in the database" do
                #Arrange
                allow(Product).to receive(:find_in_Walmart)
                #Act
                get :edit, params: { id: @drum.id }
                #Assert
                expect(Drum).to have_received(:find_by_id).once
                expect(assigns(:drum)).to eq(@drum)
            end

            it "should call the model that perform the Walmart search" do
                #Arrange
                fake_wal_price = 244
                allow(Product).to receive(:find_in_Walmart)
                #Act
                get :edit, params: { id: @drum.id }
                #Assert
                expect(Product).to have_received(:find_in_Walmart).with(@drum.product.model).once
            end

            it "should select the edit template for rendering" do 
                #Act
                get :edit, params: { id: @drum.id }
                #Assert
                expect(response).to render_template :edit
            end

            it "should make the Walmart price available to that template" do
                #Arrange
                fake_wal_price = 244
                allow(Product).to receive(:find_in_Walmart).and_return(fake_wal_price)
                #Act
                get :edit, params: { id: @drum.id }
                #Assert
                expect(assigns(:wal_price)).to eq(fake_wal_price)
            end
       
        end

    end
end