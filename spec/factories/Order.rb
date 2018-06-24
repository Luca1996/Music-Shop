FactoryBot.define do
    factory :order do |f|
        f.address "Order_address"
        f.t_num "Order_t_number"
        f.p_method "Order_p_method"
    end
    factory :invalid_order, parent: :order do |f|
        f.address nil
    end
end