require 'rails_helper'

describe "Merchants API" do
  before do
    @merchant_1 = Merchant.create!(name: "Billy")
    @merchant_2 = Merchant.create!(name: "Jilly")
    @merchant_3 = Merchant.create!(name: "Tilly")

    @item_1 = Item.create!(name: "Wheat", description: "makes bread", unit_price: 100, merchant_id: @merchant_1.id)
    @item_2 = Item.create!(name: "Gold", description: "Holds its value!", unit_price: 6500, merchant_id: @merchant_1.id)
    @item_3 = Item.create!(name: "vape", description: "not suitable for children", unit_price: 10000, merchant_id: @merchant_1.id)
  end

  it "sends a list of merchants" do
    get '/api/v1/merchants'

    expect(response).to be_successful
    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(merchants[:data].count).to eq(3)

    merchants[:data].each do |merchant|
      expect(merchant[:attributes]).to have_key(:name)
      expect(merchant[:attributes][:name]).to be_a(String)
    end
  end

  it 'sends one merchant by its id' do
    get "/api/v1/merchants/#{@merchant_1.id}"

    expect(response).to be_successful
    merchant = JSON.parse(response.body, symbolize_names: true)

    expect(merchant[:data][:attributes]).to have_key(:name)
    expect(merchant[:data][:attributes][:name]).to be_a(String)
    expect(merchant[:data][:attributes][:name]).to eq("Billy")
  end

  it 'sends the items associated with the merchant' do
    get "/api/v1/merchants/#{@merchant_1.id}/items"

    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)

    items[:data].each do |item|
      expect(item[:attributes]).to have_key(:name)
      expect(item[:attributes][:name]).to be_a(String)

      expect(item[:attributes]).to have_key(:description)
      expect(item[:attributes][:description]).to be_a(String)

      expect(item[:attributes]).to have_key(:unit_price)
      expect(item[:attributes][:unit_price]).to be_a(Float)

      expect(item[:attributes]).to have_key(:merchant_id)
      expect(item[:attributes][:merchant_id]).to be_an(Integer)
    end
  end
end