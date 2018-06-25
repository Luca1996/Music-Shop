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
	has_many :line_items
	belongs_to :user
	belongs_to :instrum, polymorphic: true


	private 
		# we need to check that when deleting a produc, it isn't referenced by a line_item
		# this is a hook method, automatically launched by rails when deletind a product
		def ensure_not_referenced_by_any_line_item
			unless line_items.empty?
				errors.add(:base, 'Line items reference this product')
				throw :abort
			end
		end
end
