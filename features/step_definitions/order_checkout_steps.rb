Given("I am on the cart page") do
    visit cart_path
end

Given("there is at least a LineItem")do
    lineitem = LineItem.create(:quantity => "1")
    expect(lineitem).not_to be_nil 
end

When("I press {string}") do |string|
    click_button(string)
end

When("I fill the order form") do
    fill_in address,with: "via Roma"
    fill_in t_num, with: "06000"
    choose("Cash on delivery")
end

Then("I should be on the Homepage") do
    visit root_page
end

Then("I should see {string}") do |string|
    expect(page).to have_content(string)
end  