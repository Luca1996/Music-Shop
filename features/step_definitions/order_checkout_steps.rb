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

And("i fill the order form") do
    fill_in "order_address",with: "via Roma"
    fill_in "order_t_num", with: "12345678"
    select "Cash on delivery", :from => "order_p_method"
end