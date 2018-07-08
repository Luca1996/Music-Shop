class LineItem < ApplicationRecord
  belongs_to :cart  #, optional: true
  belongs_to :product
  belongs_to :order, optional: true

  def delete_items
    self.product.quantity += 1
		self.product.save
  end
  
  def delete_all_same_items
    self.product.quantity += self.quantity
    self.product.save
  end

  def create_items
    self.product.quantity -= 1
    self.product.save
  end

  def price
  	product.price*quantity
  end

end
