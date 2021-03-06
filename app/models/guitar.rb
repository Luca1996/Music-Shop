class Guitar < ApplicationRecord
    validates :hand, format: { with: /\A(Left)\Z|\A(Right)\Z/ }
    validates :chords, :numericality => {:greater_than => 0}
    has_one :product, as: :instrum 	
	accepts_nested_attributes_for :product
end
