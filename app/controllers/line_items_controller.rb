# rubocop:disable Style/ConditionalAssignment
# rubocop:disable Metrics/MethodLength
# rubocop:disable Metrics/AbcSize
# rubocop:disable Metrics/ClassLength
class LineItemsController < ApplicationController
  def add_to_cart_from_index
    check_and_add_to_cart
    item_quantity = params[:quantity].to_i
    @line_item.quantity += item_quantity
    @line_item.save
    respond_to do |format|
      format.turbo_stream {
        render turbo_stream:
        turbo_stream.update(
          "product_#{selected_product.id}_user_#{current_user.id}",
          partial: 'form_for_add_to_cart',
        )
      }
    end
  end

  def add_product_from_index
    check_and_add_to_cart
  end

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
    # redirect_to carts_path(@current_cart)
    respond_to do |format|
      format.turbo_stream {
        render turbo_stream:
        [
          turbo_stream.remove(
            "line_item_#{@line_item.id}"
          ),
          turbo_stream.update(
            "Cart_#{@current_cart.id}",
            partial: 'carts/sub_total',
            locals: { cart: @current_cart }
          ),
          turbo_stream.update(
            "cart_icon_#{@current_cart.id}",
            partial: 'layouts/cart_icon_size',
            locals: { cart: @current_cart }
          ),
          turbo_stream.update(
            "checkout_btn_#{current_user.id}",
            partial: 'carts/razorpay',
            locals: { cart: @current_cart }
          )
        ]
      }
    end
  end

  def add_quantity
    @selected_product = Product.find(params[:product_id])
    @line_item = @current_cart.line_items.find_by(product_id: @selected_product)
    @line_item.quantity += 1
    @line_item.save
    # redirect_to carts_path(@current_cart)
    turbo_frame_tag_respond_for_quantity
  end

  def subtract_quantity
    @selected_product = Product.find(params[:product_id])
    @line_item = @current_cart.line_items.find_by(product_id: @selected_product)
    @line_item.quantity -= 1
    @line_item.save
    @line_item.destroy if @line_item.quantity.zero?
    # redirect_to carts_path(@current_cart)
    turbo_frame_tag_respond_for_quantity
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

  def turbo_frame_tag_respond_for_quantity
    respond_to do |format|
      format.turbo_stream {
        render turbo_stream:
        [
          turbo_stream.update(
            "quantity_#{@line_item.id}",
            partial: 'carts/quantity',
            locals: { line_item: @line_item }
          ),
          turbo_stream.update(
            "Cart_#{@current_cart.id}",
            partial: 'carts/sub_total',
            locals: { cart: @current_cart }
          ),
          turbo_stream.update(
            "checkout_btn_#{current_user.id}",
            partial: 'carts/razorpay',
            locals: { cart: @current_cart }
          ),
        ]
      }
    end
  end
end
