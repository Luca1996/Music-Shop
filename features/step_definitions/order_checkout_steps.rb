require "rack_session_access/capybara"
Given("The user is on the cart page") do
    cart_id = 1
    @cart = Cart.new(:id => cart_id)
    @cart.save
    page.set_rack_session cart_id: 1
    visit cart_path(page.get_rack_session_key('cart_id'))
end

Given("there is at least a LineItem")do
    product = Product.new(:id => "1",:title => "Guitar",:price => "800",:quantity => "1",:image => "guitars.jpg")
    product.save
    lineitem = LineItem.new(:product => product,:quantity => "1")
    lineitem.save
    @cart.line_items = lineitem
    expect(lineitem.product_id).to be(1) 
end

When("The user press {string}") do |string|
    find('a', text: string).click
end

When("The user fill the order form") do
    fill_in address,with: "via Roma"
    fill_in t_num, with: "12345678"
    select "Cash on delivery", :from => "p_method"
end

Then("The user should be on the Homepage") do
    visit root_page
end

Then("The user should see {string}") do |string|
    expect(page).to have_content(string)
end  