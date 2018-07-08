FactoryBot.define do
    factory :order do |f|
        f.address "Order_address"
        f.t_num "06123456"
        f.p_method "Cash on delivery"
        f.user_id "121"
        # f.lineitem "Order_lineitem""
    end
    factory :invalid_order, parent: :order do |f|
        f.address nil
        f.user_id nil
        f.p_method nil
        # f.lineitem nil
    end
end