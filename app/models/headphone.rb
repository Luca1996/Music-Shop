class Headphone < ApplicationRecord
    has_one :product, as: :instrum 		# at every piano is associated a product
	accepts_nested_attributes_for :product
end
