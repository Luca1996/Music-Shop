class LineItem < ApplicationRecord
  belongs_to :cart
  belongs_to :product




  def price
  	product.price*quantity
  end

end
