FactoryBot.define do
    factory :user do |f|
        f.email "user@user.com"
        f.password "12345678"
        f.admin false
        f.encrypted_password "12345678"
        f.created_at DateTime.now
        f.updated_at DateTime.now
    end
    actory :admin, parent: :user do |f|
        f.email "admin@user.com"
        f.admin true
    end
    end
end