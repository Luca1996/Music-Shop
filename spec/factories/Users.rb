FactoryBot.define do
    factory :user do |f|
        f.email "user@user.com"
        f.password "12345678"
        f.admin false
        f.encrypted_password "12345678"
        f.id "121"
    end
    factory :admin, parent: :user do |f|
        f.email "admin@user.com"
        f.admin true
        f.id "122"
    end
    factory :c_user, parent: :user do |u|
        u.email 'c_user@user.com'
        u.password '12345678'
        u.admin false
        u.id 120
    end
end