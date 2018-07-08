require 'rails_helper'

describe Product do
    describe "self.find_in_Walmart" do
        context "given a null API key" do
            it "should raise a InvalidKeyError" do
                #Arrange
                allow(Product).to receive(:walmart_key) { "" }
                #Act - Assert
                expect{ Product.find_in_Walmart("brand", "model")}.to raise_error(Product::InvalidKeyError)
            end
        end

        context "given a not valid API key" do
            it "should raise a InvalidKeyError" do
                #Arrange
                allow(Product).to receive(:walmart_key) {"invalid-key"}
                #Act - Assert
                expect{ Product.find_in_Walmart("brand", "model")}.to raise_error(Product::InvalidKeyError) 
            end
        end
        
        context "given a valid API key" do 
            it "should call NET::HTTP.get to obtain the price" do
                #Arrange
                allow(Net::HTTP).to receive(:get) { "server-response" }
                allow(JSON).to receive(:parse) {{"message"=>"msg"}}
                #Act
                Product.find_in_Walmart("brand", "model")
                #Assert
                expect(Net::HTTP).to have_received(:get).once
            end
            
            it "should parse the server response given in JSON format" do
                #Arrange
                allow(Net::HTTP).to receive(:get) { "server-response" } 
                allow(JSON).to receive(:parse) {{"message"=>"msg"}}
                #Act
                Product.find_in_Walmart("brand", "model")
                #Assert
                expect(JSON).to have_received(:parse).once
            end

        end 

    end

end