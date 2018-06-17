class Product < ApplicationRecord
	# validations
	validates :title, presence: true
	validates :price, presence: true, format: { with: /\A[0-9]{1,6}(.[0-9]{1,2})?/, message: "Insert a valid price" }
	validates :quantity, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1, message: "Insert a valid quantity" }
	validates :weight, format: {with: /\A[0-9]{0,4}/, message: "Insert valid weigth" }
	validates :height, format: {with: /\A[0-9]{0,4}/, message: "Insert valid height" }
	validates :length, format: {with: /\A[0-9]{0,4}/, message: "Insert valid length" }
	validates :depth, format: {with: /\A[0-9]{0,4}/, message: "Insert valid depth" }
	validates :image, presence: true

	# associations
	belongs_to :user

end
