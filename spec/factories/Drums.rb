FactoryBot.define do
    factory :drum do |f|
        f.pedals 2
        f.color "black"
        f.cymbals 4
        f.toms 2
        f.id 123
    end
end
