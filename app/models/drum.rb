class Drum < ApplicationRecord
    validates :pedals, format: { with: /\A(1)?(2)?/ }
    validates :cymbals, format: { with: /\A[0-9]?/ }
    validates :toms, format: {with: /\A[0-9]?/}
    
    has_one :product, as: :instrum 	
	accepts_nested_attributes_for :product
end
