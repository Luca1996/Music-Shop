class Other < ApplicationRecord
	# validations
	validates :tipo, presence: true

	# associations
	has_one :product, as: :instrum		# at every other instrument is associated a product
	accepts_nested_attributes_for :product
end
