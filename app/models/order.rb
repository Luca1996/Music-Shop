class Order < ApplicationRecord
    belongs_to :user
	enum p_method: {
		"PayPal"	         => 0,
		"Cash on delivery"	 => 1
    }
end
