class Comment < ApplicationRecord
    belongs_to :user
    belongs_to :product
    validates :title, presence: true
    validates_length_of :text, presence: true,:minimum => 1, :maximum => 500
    validates :user_id , uniqueness:{ scope:  :product_id , message: "You can only do a review"}
end
