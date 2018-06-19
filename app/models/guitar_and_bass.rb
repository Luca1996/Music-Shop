class GuitarAndBass < ApplicationRecord
    validates :hand, format: { with: /left?right/ }
    validates :chords, presence :true
    has_one :product, as: :instrum 	
	accepts_nested_attributes_for :product
end
