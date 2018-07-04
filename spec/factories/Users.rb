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
        f.id "121"
    end
end