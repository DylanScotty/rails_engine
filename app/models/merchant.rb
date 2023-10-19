class Merchant < ApplicationRecord
    has_many :items

    def self.find_merchant_by_name(params)
        where("name ILIKE ?", "%#{params}%")
        .first
    end

    def self.find_merchants_by_name(params)
        where("name ILIKE ?", "%#{params}%")
    end
end
