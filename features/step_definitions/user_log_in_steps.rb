And /^I am logged in .*$/ do
    email = "prova@prova.it"
    pass = "passprova"
    @user = User.new(:email => email, :password => pass)
    @user.save!

    steps %Q{
        And i go to the new user session page
        And i fill "email" with "#{email}" in "user" form
        And i fill "password" with "#{pass}" in "user" form
        And i press "Log in"
    }
end

And /^i go to (.*)$/ do |page| 
    visit path_to(page)
end

And /^i fill "(.+)" with "(.+)" in "(.+)" form$/ do |camp, value, f_name|
    fill_in f_name+'_'+camp, with: value
end

And /^i attach the image "(.+)" in "(.+)" form$/ do |img, form|
    page.attach_file(form+'_image', Rails.root + 'app/assets/images/'+img)
end

And /^i press "(.*)"$/ do |butn|
    click_button(butn)
end