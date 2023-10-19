require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe 'relationships' do
    it { should have_many :items }
  end

  describe '::find_merchant_by_name' do
    it 'returns the merchant based off the search result' do
      @merchant_1 = Merchant.create!(name: "Billy")
      @merchant_2 = Merchant.create!(name: "Jilly")
      @merchant_3 = Merchant.create!(name: "Tilly")


      expect(Merchant.find_merchant_by_name("Bil")).to eq(@merchant_1)
    end
  end
end
