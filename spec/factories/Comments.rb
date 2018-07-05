FactoryBot.define do
    factory :comment do |c|
        c.title "Title"
        c.text "Text"
        c.user_id 120
        c.product_id 100
    end
    factory :invalid_comment,parent: :comment do |c|
        c.title nil
        c.text nil
    end
end