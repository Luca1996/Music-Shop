FactoryBot.define do
    factory :product do |f|
        f.user nil
        f.quantity 1
        f.price 1200
        f.title "product1"
        f.id 123
        f.image nil
    end
end
