class LineItem < ApplicationRecord
  belongs_to :cart
  belongs_to :order, optional: true
  belongs_to :product

  def total_of_single_product
    self.product.price * self.quantity
  end
end
