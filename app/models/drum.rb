class Drum < ApplicationRecord
    validates :pedals, format: { with: /\A[1-2]\Z/, message: "1 or 2 pedals" }
    validates :cymbals, format: { with: /\A[1-9]\Z/, message: "1 to 9 cymbals" }
    validates :toms, format: {with: /\A[1-9]\Z/, message: "1 to 9 toms" }
    
    has_one :product, as: :instrum 	
	accepts_nested_attributes_for :product
end
