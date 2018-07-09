class Piano < ApplicationRecord
	# validations 
	validates :tipo, presence: true, format: { with: /\A(A coda)|(A muro)\Z/, message: "A coda o a muro" }
	validates :n_keys, presence: true;

	# associations
	has_one :product, as: :instrum 		# at every piano is associated a product
	accepts_nested_attributes_for :product
end
