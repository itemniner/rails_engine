class Api::V1::ItemsController < ApplicationController
  def index
    items = Item.all
    render json: ItemSerializer.new(items)
  end

  def show
    item = Item.find(params[:id])
    render json: ItemSerializer.new(item)
  end

  def create
    merchant = Merchant.find(item_params[:merchant_id])
    render json: ItemSerializer.new(merchant.items.create(item_params))
  end

  def update
    item = Item.update(params[:id], item_params)
    render json: ItemSerializer.new(item)

  end

  def destroy
    render json: Item.delete(params[:id])
  end
  private

  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end
end
