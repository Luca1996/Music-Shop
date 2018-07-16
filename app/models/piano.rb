class Piano < ApplicationRecord
	# validations 
	validates :tipo, presence: true, format: { with: /\A(A coda)|(A muro)|(Digitale)\Z/, message: "A coda, A muro o Digitale" }
	
	validates :n_keys, :numericality => {:greater_than => 0}

	# associations
	has_one :product, as: :instrum 		# at every piano is associated a product
	accepts_nested_attributes_for :product
end
