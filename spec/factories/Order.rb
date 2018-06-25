FactoryBot.define do
    factory :order do |f|
        f.address "Order_address"
        f.t_num "000"
        f.p_method "Order_p_method"
        f.line_item "Order_line_item"
        f.user_id "1"
    end
    factory :invalid_order, parent: :order do |f|
        f.address nil
        f.line_item nil
        f.user_id nil
    end
end