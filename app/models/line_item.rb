class LineItem < ApplicationRecord
  belongs_to :cart  #, optional: true
  belongs_to :product
  belongs_to :order, optional: true



  def price
  	product.price*quantity
  end

end
