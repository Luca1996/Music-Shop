class Order < ApplicationRecord
	belongs_to :user
	validates :address, presence: true, length: { minimum:5 }
	validates :user_id, presence: true
	
	
	
	enum p_method: {
		"PayPal"	         => 0,
		"Cash on delivery"	 => 1
    }
end
