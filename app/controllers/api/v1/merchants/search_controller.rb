class Api::V1::Merchants::SearchController < ApplicationController
    def index
      if params[:name].blank?
        render json: { errors: ['Name parameter is required'] }, status: :bad_request
      else
        merchants = Merchant.find_merchant_by_name(params[:name])
        render json: MerchantSerializer.new(merchants), status: :ok
      end
    end
end

  
  
  
  
  
  