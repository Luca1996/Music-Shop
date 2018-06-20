class Guitar < ApplicationRecord
    validates :hand, format: { with: /\A(left)?(right)?/ }
    validates :chords, presence: true
    has_one :product, as: :instrum 	
	accepts_nested_attributes_for :product
end
