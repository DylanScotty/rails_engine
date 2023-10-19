require 'rails_helper'

describe "Items API" do
  before do
    @merchant_1 = Merchant.create!(name: "Billy")
    @merchant_2 = Merchant.create!(name: "Jilly")

    @item_1 = Item.create!(name: "Wheat", description: "It makes bread", unit_price: 1.50, merchant_id: @merchant_1.id)
    @item_2 = Item.create!(name: "Gold", description: "Its worth it", unit_price: 65.00, merchant_id: @merchant_1.id)
    @item_3 = Item.create!(name: "Computer Mouse", description: "you can click with it", unit_price: 100.00, merchant_id: @merchant_1.id)
    @item_4 = Item.create!(name: "Computer Keyboard", description: "you can type with it", unit_price: 60.50, merchant_id: @merchant_1.id)
  end
  describe 'get requests' do
    it "sends a list of items" do
      get '/api/v1/items'

      expect(response).to be_successful
      items = JSON.parse(response.body, symbolize_names: true)

      expect(items[:data].count).to eq(4)

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

    it 'sends one item by its id' do
      get "/api/v1/items/#{@item_1.id}"

      expect(response).to be_successful
      item = JSON.parse(response.body, symbolize_names: true)
      
      expect(item[:data][:attributes]).to have_key(:name)
      expect(item[:data][:attributes][:name]).to be_a(String)
      expect(item[:data][:attributes][:name]).to eq("Wheat")

      expect(item[:data][:attributes]).to have_key(:description)
      expect(item[:data][:attributes][:description]).to be_a(String)
      expect(item[:data][:attributes][:description]).to eq("It makes bread")

      expect(item[:data][:attributes]).to have_key(:unit_price)
      expect(item[:data][:attributes][:unit_price]).to be_a(Float)
      expect(item[:data][:attributes][:unit_price]).to eq(1.50)

      expect(item[:data][:attributes]).to have_key(:merchant_id)
      expect(item[:data][:attributes][:merchant_id]).to be_an(Integer)
      expect(item[:data][:attributes][:merchant_id]).to eq(@merchant_1.id)

    end

    context 'happy_path' do
      it 'returns the mechant associated with the item' do
        get "/api/v1/items/#{@item_1.id}/merchant"

        expect(response).to be_successful

        merchant = JSON.parse(response.body, symbolize_names: true)

        expect(merchant[:data]).to have_key(:id)
        expect(merchant[:data][:id]).to be_a(String)
        expect(merchant[:data][:id]).to eq("#{@merchant_1.id}")

        expect(merchant[:data]).to have_key(:type)
        expect(merchant[:data][:type]).to be_a(String)
        expect(merchant[:data][:type]).to eq("merchant")
        
        expect(merchant[:data][:attributes]).to have_key(:name)
        expect(merchant[:data][:attributes][:name]).to be_a(String)
        expect(merchant[:data][:attributes][:name]).to eq("#{@merchant_1.name}")
      end

      it 'can search for a specfic item' do
        get "/api/v1/items/find_all?name=Computer"
    
        expect(response).to be_ok
    
        parsed = JSON.parse(response.body, symbolize_names: true)

        search_array = parsed.first.second
        
        search_array.each do |item|
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

    it 'can search for a specfic item' do
      get "/api/v1/items/find_all?min_price=61"
  
      expect(response).to be_ok
  
      parsed = JSON.parse(response.body, symbolize_names: true)

      search_array = parsed.first.second
      
      search_array.each do |item|
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

    context 'sad_path' do
      it 'sends an ok response if the name param is nil' do
        get "/api/v1/items/find_all?name=Computer"
    
        expect(response).to be_ok
      end

      it 'sends an ok response if the min_price param is below 0' do
        get "/api/v1/items/find_all?min_price=-5"
    
        expect(response).to be_bad_request
      end

      it 'sends an ok response if the param is max price' do
        get "/api/v1/items/find_all?max_price=100"
    
        expect(response).to be_bad_request
      end
    end
  end
  describe 'post requests' do 
    context 'happy path' do
      it 'creates a new item' do
        post '/api/v1/items', params: {
            item: {
              name: "Wheat",
              description: "It makes bread",
              unit_price: 1.50,
              merchant_id: @merchant_1.id
            }
          }
        expect(response).to be_created
        item = JSON.parse(response.body, symbolize_names: true)
        
        expect(item[:data][:attributes]).to have_key(:name)
        expect(item[:data][:attributes][:name]).to be_a(String)
        expect(item[:data][:attributes][:name]).to eq("Wheat")

        expect(item[:data][:attributes]).to have_key(:description)
        expect(item[:data][:attributes][:description]).to be_a(String)
        expect(item[:data][:attributes][:description]).to eq("It makes bread")

        expect(item[:data][:attributes]).to have_key(:unit_price)
        expect(item[:data][:attributes][:unit_price]).to be_a(Float)
        expect(item[:data][:attributes][:unit_price]).to eq(1.50)

        expect(item[:data][:attributes]).to have_key(:merchant_id)
        expect(item[:data][:attributes][:merchant_id]).to be_an(Integer)
        expect(item[:data][:attributes][:merchant_id]).to eq(@merchant_1.id)
      end
    end

    context 'sad path' do
      it 'does not create an item with invalid param inputs' do
        post '/api/v1/items', params: {
          item: {
            name: '',
            description: '',
            unit_price: '',
            merchant_id: ''
          }
        }
        expect(response).to be_unprocessable
      end
    end
  end

  describe 'Delete requests' do
    it 'deletes an existing item' do
      delete "/api/v1/items/#{@item_2.id}"

      expect(response).to be_no_content
    end
  end

  describe 'update requests' do
    context 'happy path' do
      it 'updates an existing item' do
        patch "/api/v1/items/#{@item_2.id}", params: {
          item: {
            name: "Taco",
            description: "Only eaten on Tuesday",
            unit_price: 1.23,
            merchant_id: "#{@merchant_2.id}"
          }
        }
        expect(response).to be_successful

        item = JSON.parse(response.body, symbolize_names: true)
        
        expect(item[:data][:attributes]).to have_key(:name)
        expect(item[:data][:attributes][:name]).to be_a(String)
        expect(item[:data][:attributes][:name]).to eq("Taco")

        expect(item[:data][:attributes]).to have_key(:description)
        expect(item[:data][:attributes][:description]).to be_a(String)
        expect(item[:data][:attributes][:description]).to eq("Only eaten on Tuesday")

        expect(item[:data][:attributes]).to have_key(:unit_price)
        expect(item[:data][:attributes][:unit_price]).to be_a(Float)
        expect(item[:data][:attributes][:unit_price]).to eq(1.23)

        expect(item[:data][:attributes]).to have_key(:merchant_id)
        expect(item[:data][:attributes][:merchant_id]).to be_an(Integer)
        expect(item[:data][:attributes][:merchant_id]).to eq(@merchant_2.id)
      end
    end

    context 'sad path' do
      it 'does not update the existing item with invalid param inputs' do
        patch "/api/v1/items/#{@item_2.id}", params: {
          item: {
            name: '',
            description: '',
            unit_price: '',
            merchant_id: ''
          }
        }
        expect(response).to be_bad_request
      end
    end
  end
end