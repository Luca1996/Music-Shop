require "rack_session_access/capybara"

Given /^i have added an item in the cart$/ do
    
    ## Setup a product to buy from another user and set cart
    user = User.new(:email => "seller@seller.com", :password => "sellerseller")
    user.save!
    piano = Piano.new(:id => "33",:tipo => "A muro", :n_keys => "66")
    piano.save!
    product = Product.new(:id => "1",:title => "Piano title",:price => "800",:quantity => "1",:image => "pianos.jpg",:instrum => piano)
    product.user = user
    product.save!
    @product = product
    @cart = Cart.create(:id => 1)
    @cart_id = 1
    page.set_rack_session cart_id: 1
    #####

    steps %Q{
        And i go to the products page
        And i click on Details of the product with id="#{product.id}"
        Then i should see "Buy"
        And i click on "Buy"
    } 
end

Then /^i should be into the current cart page$/ do
    current_path = URI.parse(current_url).path
    expect(current_path).to eq cart_path(@cart_id)
end 

And /^i should see the item in the cart$/ do 
    expect(page).to have_content(@product.title)
end

Then /^i should be onto the order page$/ do
    current_path = URI.parse(current_url).path[/.*\//]
    expect(current_path).to eq "/orders/"
end

And /^i fill the order form with valid values$/ do
    steps %Q{
        And i fill the order form with address "Via roma", num "3425647844" and p_method "Cash on delivery"
    }
end

And /^i fill the order form with an invalid tel_number$/ do
    ## Note: tel_num must be [8-12] digits
    steps %Q{
        And i fill the order form with address "Via roma", num "4354" and p_method "Cash on delivery"
    }
end

And /^i fill the order form without field address$/ do
    steps %Q{
        And i fill the order form with address "", num "3456473899" and p_method "Cash on delivery"
    }
end

And /^i fill the order form with address "(.*)", num "(.*)" and p_method "(.*)"$/ do |addr, num, met|
    fill_in "order_address",with: "#{addr}"
    fill_in "order_t_num", with: "#{num}"
    select "#{met}", :from => "order_p_method"
end

And /^i press on "Submit Order" and raise an error$/ do
   expect {click_on("Submit Order")} .to raise_error(RuntimeError)
end