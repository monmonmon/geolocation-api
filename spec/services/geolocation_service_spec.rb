require 'rails_helper'

RSpec.describe GeolocationService do
  before :each do
    define_stab_for_api_access()
  end

  before :each do
    @geolocation = Geolocation.find_or_create_by!({
      latitude: 12.345678,
      longitude: 98.765432,
      ipaddress: "1.1.1.1",
      url_fqdn: "example.com",
    })
  end

  describe "ip_to_geolocation" do
    it "successfully get the latitude and the longitude of the ip address when the passed IP address exists" do
      latitude, longitude = GeolocationService.ip_to_geolocation("23.192.228.80") # IP addrees of example.com
      expect(latitude.class).to eq Float
      expect(longitude.class).to eq Float
    end

    it "raises an error when the passed ip address is in a wrong format" do
      expect {
        GeolocationService.ip_to_geolocation("x")
      }.to raise_error(RuntimeError)
    end
  end

  describe "extract_host_from_url" do
    it "successfully extract the host part from the passed URL" do
      host = GeolocationService.extract_host_from_url("https://example.com")
      expect(host).to eq "example.com"
    end

    it "fails when the passed URL doesn't have a protocol" do
      expect {
        GeolocationService.extract_host_from_url("example.com")
      }.to raise_error(RuntimeError)
    end

    it "raises an error when the passed URL is in a wrong format" do
      expect {
        GeolocationService.extract_host_from_url("xxx")
      }.to raise_error(RuntimeError)
    end
  end

  describe "resolve_hostname" do
    it "successfully resolve the host when it has IP addresses" do
      ip = GeolocationService.resolve_hostname("example.com")
      expect(ip).to be_truthy
    end

    it "fails to resolve the host when it doesn't have IP addresses" do
      ip = GeolocationService.resolve_hostname("no.such.server")
      expect(ip).to be nil
    end
  end
end
