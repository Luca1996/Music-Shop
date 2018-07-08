## We stub the call to the API to make the test independent
## Note: in general it is a bad idea to stub in integration test but
## in this case it is necessary and allowed
def Product.find_in_Walmart(model)
    return 1 if model == "present"
    return nil
end

Given /^that i am on Music-Shop homepage$/ do
    visit root_path
end

And /^i have an item with title "(.+)" which is "(.+)" in Walmart database for sale$/ do |t, cond|
    title = t
    price = 1200
    quantity = 1
    # We set the model as to be recognized as present or not in Walmart db
    model = "not present" if cond == "not present"
    model = "present" if cond == "present"
    image = "pianos.jpg"
    tipo = "A muro"
    n_keys = 66

    steps %Q{
        And i go to the new piano page
        And i fill "title" with "#{title}" in "piano_product_attributes" form
        And i fill "price" with "#{price}" in "piano_product_attributes" form
        And i fill "model" with "#{model}" in "piano_product_attributes" form
        And i fill "quantity" with "#{quantity}" in "piano_product_attributes" form
        And i attach the image "#{image}" in "piano_product_attributes" form
        And i select "#{tipo}" in "tipo" in "piano" form
        And i fill "n_keys" with "#{n_keys}" in "piano" form
        And i click on "Sell piano"
    }
end

And /^i select "(.*)" in "(.*)" in "(.*)" form$/ do |value, field, f_name|
    page.select value, from: f_name+"_"+field
end 

Then /^i should see "(.+)"(?:| list)?$/ do |elem|
    # checks if page has the text elem (ignoring HTML tags)
    expect(page.has_content?(elem)).to eq(true)
end

Then /^i should not see "(.+)"$/ do |elem|
    expect(page.has_content?(elem)).to eq(false)
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


Then /^i search the item with title "(.*)" and click on "Modify"$/ do |title|
    #puts Piano.where(n_keys: 66)[0].product.inspect
    click_on("modify-#{title}")    
end

Then /^i should be into the edit piano page$/ do
    current_path = URI.parse(current_url).path[/\/\w*\//]
    expect(current_path).to eq "/pianos/"
end

Then /^i search the item not in Walmart db with title "(.*)" and click on "Modify"$/ do |title|
    click_on("modify-#{title}")
end
