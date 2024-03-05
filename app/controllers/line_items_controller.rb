# rubocop:disable Style/ConditionalAssignment
class LineItemsController < ApplicationController
  def buy_now
    check_and_add_to_cart
    redirect_to carts_path(@current_cart)
  end

  def add_to_cart
    check_and_add_to_cart
    item_quantity = params[:quantity].to_i
    if @line_item.quantity == 1
      @line_item.quantity += (item_quantity - 1)
    else
      @line_item.quantity += item_quantity
    end
    @line_item.save
    redirect_to product_path(@selected_product)
  end

  def destroy_from_cart
    @selected_product = Product.find(params[:product_id])
    @line_item = @current_cart.line_items.find_by(product_id: @selected_product)
    @line_item.destroy
    redirect_to carts_path(@current_cart)
  end

  def check_and_add_to_cart
    # Check if the product is already present
    @selected_product = Product.find(params[:product_id])
    if @current_cart.products.include?(@selected_product)
      @line_item = @current_cart.line_items.find_by(product_id: @selected_product)
    else
      @line_item = LineItem.new
      @line_item.cart = @current_cart
      @line_item.product = @selected_product
      @line_item.save
    end
  end
end
