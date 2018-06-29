require 'rails_helper'

describe DrumController do
    describe 'edit' do 
        context "unregistered user" do
        end


        context "registered user, who owns the required item" do
            it "should retrieve the drum by id in the database"
            it "should call the model that perform the Walmart search"
            it "should select the edit template for rendering"
            it "should make the Walmart price available to that template"
        end

    end
end