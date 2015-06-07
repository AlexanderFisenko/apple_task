require 'rails_helper'

RSpec.describe Device, :type => :model do
  describe '#fetch_warranty_expiration_date' do
    #не успел заюзать VCR, хотя он тут уместен.
    it 'sprapes warranty expiration date from the web' do
      @device = Device.new(imei: "013977000323877")

      expect(@device.fetch_warranty_expiration_date).to eq(DateTime.parse("August 10, 2016"))
    end

    it 'returns WARRANTY_UNKNOWN_EXPIRATION_DATE if there is no warranty expiration date on the web' do
      @device = Device.new(imei: "013896000639712")

      expect(@device.fetch_warranty_expiration_date).to eq(DateTime.parse(Device::WARRANTY_UNKNOWN_EXPIRATION_DATE))
    end

    it 'returns nil if imei is invalid or something went wrong' do
      @device = Device.new(imei: "013896000639710")

      expect(@device.fetch_warranty_expiration_date).to eq(nil)
    end
  end

  describe '#expired?' do
    it 'returns true if warranty_expiration_date is expired' do
      @device = Device.new(warranty_expiration_date: DateTime.parse("August 10, 2014"))

      expect(@device.expired?).to be_truthy
    end
    it 'returns false if warranty_expiration_date is not expired' do
      @device = Device.new(warranty_expiration_date: DateTime.parse("August 10, 2016"))

      expect(@device.expired?).to be_falsey
    end
  end

  describe "#warranty_expiration_date_known?" do
    it 'returns true if an instance has warranty_expiration_date and it is not equal WARRANTY_UNKNOWN_EXPIRATION_DATE' do
      @device = Device.new(warranty_expiration_date: DateTime.parse("August 10, 2016"))

      expect(@device.warranty_expiration_date_known?).to be_truthy
    end

    it 'returns false if an instance has no warranty_expiration_date or it is equal WARRANTY_UNKNOWN_EXPIRATION_DATE' do
      @device = Device.new(warranty_expiration_date: DateTime.parse(Device::WARRANTY_UNKNOWN_EXPIRATION_DATE))

      expect(@device.warranty_expiration_date_known?).to be_falsey
    end
  end
end

