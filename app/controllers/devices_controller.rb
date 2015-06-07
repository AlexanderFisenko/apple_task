class DevicesController < ApplicationController

  def show
    devices = [
      Device.create(imei: "013977000323877", warranty_expiration_date: "2015-08-18")
      Device.create(imei: "013896000639712", warranty_expiration_date: nil)
    ]

    @device = devices.sample
  end

end
