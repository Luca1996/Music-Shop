FactoryBot.define do
    factory :lineitem do |f|
    f.cart "LineItem_cart"
    f.product "LineItem_product"
    f.quantity "LineItem_quantity"
    end
end