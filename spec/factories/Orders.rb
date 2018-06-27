FactoryBot.define do
    factory :order do |f|
        f.address "Order_address"
        f.t_num "000"
        f.p_method "Cash on delivery"
        f.user_id "1"
    end
    factory :invalid_order, parent: :order do |f|
        f.address nil
        
        f.user_id nil
    end
end