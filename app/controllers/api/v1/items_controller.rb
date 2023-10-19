class Api::V1::ItemsController < ApplicationController
    def index
        render json: ItemSerializer.new(Item.all)
    end 

    def show
        render json: ItemSerializer.new(Item.find(params[:id]))
    end

    def create
        item = Item.new(item_params)
        if item.save
          render json: ItemSerializer.new(item), status: :created
        else
          render json: item.errors, status: :unprocessable_entity
        end
    end

    def update
        item = Item.find(params[:id])
        item.update(item_params)
        if item.save
          render json: ItemSerializer.new(item), status: :created
        else
          render json: item.errors, status: :bad_request
        end
    end

    def destroy
        item = Item.find(params[:id])
        item.destroy
        render status: :no_content
    end

    private
      def item_params
        params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
      end
end