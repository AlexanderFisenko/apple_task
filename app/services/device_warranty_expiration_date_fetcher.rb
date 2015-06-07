class DeviceWarrantyExpirationDateFetcher
  def initialize(device)
    @device = device
  end

  def date
    return unless @device.imei

    begin
      browser = Watir::Browser.new
      browser.goto 'https://selfsolve.apple.com/agreementWarrantyDynamic.do'
      browser.text_field(name: 'sn').set @device.imei
      browser.button(type: 'button', id: 'warrantycheckbutton').click

      if browser.p(id: 'hardware-text').text.blank?
        return nil
      end

      date = browser.p(id: 'hardware-text').text.scan(/Estimated Expiration Date: (.+)/).first.try(&:first)
    
      if date
        return DateTime.parse(date).to_date
      else
        return DateTime.parse(Device::WARRANTY_UNKNOWN_EXPIRATION_DATE).to_date
      end
    rescue
      return nil
    ensure
      browser.close
    end
  end
end