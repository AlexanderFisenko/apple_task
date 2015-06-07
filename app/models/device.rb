class Device < ActiveRecord::Base

  attr_accessor :imei
  attr_accessor :warranty_expiration_date

  after_update :update_warranty_expiration_date, if: Proc.new { |device| device.imei }

  concerning :Warranty do
    WARRANTY_UNKNOWN_EXPIRATION_DATE = '01-01-1970'

    def fetch_warranty_expiration_date
      DeviceWarrantyExpirationDateFetcher.new(self).date
    end

    def expired?
      warranty_expiration_date && warranty_expiration_date < Date.today
    end

    def warranty_expiration_date_known?
      warranty_expiration_date.present? && warranty_expiration_date != WARRANTY_UNKNOWN_EXPIRATION_DATE
    end

    def update_warranty_expiration_date
      update(warranty_expiration_date: fetch_warranty_expiration_date)
    end
  end
end
