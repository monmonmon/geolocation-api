require 'rails_helper'

RSpec.describe Geolocation, type: :model do
  before :each do
    allow(GeolocationService).to receive(:ip_to_geolocation)
      .and_return([12.345678, 98.765432])
  end

  before :each do
    @geolocation = Geolocation.find_or_create_by!({
      latitude: 12.345678,
      longitude: 98.765432,
      ipaddress: "1.1.1.1",
      url_fqdn: "example.com",
    })
  end

  describe "find_by_url!" do
    it "successfully finds a record with the FQDN of the URL" do
      g = Geolocation.find_by_url!("https://example.com")
      expect(g).to be_truthy
      expect(g.ipaddress).to eq @geolocation.ipaddress
    end

    it "successfully finds a record with the FQDN of the URL (with paths and query strings)" do
      g = Geolocation.find_by_url!("https://example.com/a/b/c#d?e=f")
      expect(g).to be_truthy
      expect(g.ipaddress).to eq @geolocation.ipaddress
    end

    it "fails to find a record with a URL missing a protocol" do
      g = Geolocation.find_by_url!("example.com")
      expect(g).to be_nil
    end

    it "fails to find a record when the passed URL is missing a protocol" do
      g = Geolocation.find_by_url!("example.com")
      expect(g).to be_nil
    end

    it "fails to find a record when the FQDN of the URL is not registered" do
      g = Geolocation.find_by_url!("not-registered.com")
      expect(g).to be_nil
    end
  end

  describe "build_by_ipaddress" do
    it "successfully builds an instance when the passed IP address is in the correct format" do
      g = Geolocation.build_by_ipaddress("1.1.1.2")
      expect(g).to be_truthy
      expect(g.valid?).to be true
      expect(g.ipaddress).to eq "1.1.1.2"
    end

    it "raises an error when the passed IP address is in a wrong format" do
      expect {
        g = Geolocation.build_by_ipaddress("1.1.1.999")
      }.to raise_error
    end
  end

  describe "build_by_url" do
    it "successfully builds an instance when the passed URL is in the correct format" do
      g = Geolocation.build_by_url("https://test.com/a/b/c#d?e=f")
      expect(g).to be_truthy
      expect(g.valid?).to be true
      expect(g.url_fqdn).to eq "test.com"
    end

    it "raises an error when the passed IP address is in a wrong format" do
      expect {
        g = Geolocation.build_by_url("xxx")
      }.to raise_error
    end
  end
end
