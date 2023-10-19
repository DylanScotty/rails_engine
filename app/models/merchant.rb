class Merchant < ApplicationRecord
    has_many :items

    def self.find_merchant_by_name(params)
        where("name ILIKE ?", "%#{params}%")
        .first
    end
end
