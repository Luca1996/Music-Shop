FactoryBot.define do
    factory :product do |f|
        f.user nil
        f.quantity 1
        f.price 1200
        f.title "product1"
        f.id 123
        f.image nil
        f.weight 5
    end
    factory :c_prod,parent: :product do |p|
        p.user_id 121
        p.quantity 1
        p.price 600
        p.title 'Product'
        p.id 100
        p.instrum_id 123
        p.instrum_type "Drum" 
        p.image 'guitars.jpg'
    end
end
