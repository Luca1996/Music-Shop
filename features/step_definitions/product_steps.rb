Given /^that i am on Music-Shop homepage$/ do
    visit root_path
end

And /^i have an item with title "(.+)" not in Walmart database for sale$/ do |t|
    title = t
    price = 1200
    quantity = 1
    image = "pianos.jpg"
    tipo = "A muro"
    n_keys = 66
    
    steps %Q{
        And i go to the new piano page
        And i fill "title" with "#{title}" in "piano_product_attributes" form
        And i fill "price" with "#{price}" in "piano_product_attributes" form
        And i fill "quantity" with "#{quantity}" in "piano_product_attributes" form
        And i attach the image "#{image}" in "piano_product_attributes" form
        And i fill "tipo" with "#{tipo}" in "piano" form
        And i fill "n_keys" with "#{n_keys}" in "piano" form
        And i click on "Sell piano"
    }
end

Then /^i should see "(.+)"(?:| list)?$/ do |elem|
    # checks if page has the text elem (ignoring HTML tags)
    expect(page.has_content?(elem)).to eq(true)
end

And /^i click on Details of the product with id="(.*)"$/ do |id|
    click_on("link-#{id}")
end


When /^i click on "(.+)"$/ do |elem|
    click_on(elem)
end

Then /^i should be on (.+)$/ do |page|
    current_path = URI.parse(current_url).path
    expect(path_to(page)).to eq(current_path)
end

And /^i should see "(.+)" in corrispondence of the item with title '(.+)'$/ do |msg, title|
    p = page.find('#'+title).has_content?(msg)
    expect(p).to eq(true)
end

