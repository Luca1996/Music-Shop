class Piano < ApplicationRecord
	# validations 
	validates :tipo, presence: true;
	validates :n_keys, presence: true;

	# associations
	has_one :product, as: :instrum 		# at every piano is associated a product
	accepts_nested_attributes_for :product
end
