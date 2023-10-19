require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'relationships' do
    it { should belong_to :merchant }
  end
  
  before do
    @merchant_1 = Merchant.create!(name: "Billy")
  
    @item_1 = Item.create!(name: "Wheat", description: "It makes bread", unit_price: 1.50, merchant_id: @merchant_1.id)
    @item_2 = Item.create!(name: "Gold", description: "Its worth it", unit_price: 65.00, merchant_id: @merchant_1.id)
    @item_3 = Item.create!(name: "Computer Mouse", description: "you can click with it", unit_price: 100.00, merchant_id: @merchant_1.id)
    @item_4 = Item.create!(name: "Computer Keyboard", description: "you can type with it", unit_price: 60.50, merchant_id: @merchant_1.id)
  end

  describe '::find_all_items_by_name' do
    it 'returns the items based off the search result by name' do
      expect(Item.find_all_items_by_name("Computer")).to eq([@item_3, @item_4])
    end
  end
  
  describe '::find_all_items_by_price' do
    it 'returns the items based off the search result by price' do
      expect(Item.find_all_items_by_price("61")).to eq([@item_2, @item_3])
    end
  end
end