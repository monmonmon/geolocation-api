require "rails_helper"

RSpec.describe "/geolocations/ip", type: :request do
  before :each do
    @geolocation = Geolocation.find_or_create_by!({
      latitude: 12.345678,
      longitude: 98.765432,
      ipaddress: "1.1.1.1",
      url_fqdn: "example.com",
    })
  end

  describe "GET /index" do
    it "renders a successful response when correct & registered ip address is passed" do
      get geolocations_ip_url(ip: "1.1.1.1"), as: :json
      expect(response).to be_successful
      res = JSON.parse(response.body)
      expect(res["ipaddress"]).to eq "1.1.1.1"
    end

    it "fails with 404 Not Found when the specified ip address is not registered" do
      get geolocations_ip_url(ip: "1.1.1.100"), as: :json
      expect(response).to have_http_status(:not_found)
    end

    it "fails with 400 Bad Request when the specified ip address is in the wrong format (1.1.1.999)" do
      get geolocations_ip_url(ip: "1.1.1.999"), as: :json
      expect(response).to have_http_status(:bad_request)
    end

    it "fails with 400 Bad Request when the specified ip address is in the wrong format (xxx)" do
      get geolocations_ip_url(ip: "xxx"), as: :json
      expect(response).to have_http_status(:bad_request)
    end
  end

  describe "POST /create" do
    before :each do
      # define a stub to bypass api access and circumvent the rate limit
      allow(GeolocationService).to receive(:ip_to_geolocation)
        .and_return([12.345678, 98.765432])
    end

    it "creates a new Geolocation record" do
      expect {
        post geolocations_ip_index_url, params: { ip: "1.1.1.2" }, as: :json
      }.to change(Geolocation, :count).by(1)
      g = Geolocation.last
      expect(g.ipaddress).to eq "1.1.1.2"
    end

    it "fails with 400 Bad Request when the specified ip address is already registered" do
      expect {
        post geolocations_ip_index_url, params: { ip: "1.1.1.1" }, as: :json
      }.to change(Geolocation, :count).by(0)
      expect(response).to have_http_status :bad_request
    end

    it "fails with 400 Bad Request when the specified ip address is in the wrong format (1.1.1.999)" do
      expect {
        post geolocations_ip_index_url, params: { ip: "1.1.1.999" }, as: :json
      }.to change(Geolocation, :count).by(0)
      expect(response).to have_http_status :bad_request
    end

    it "fails with 400 Bad Request when the specified ip address is in the wrong format (xxx)" do
      expect {
        post geolocations_ip_index_url, params: { ip: "xxx" }, as: :json
      }.to change(Geolocation, :count).by(0)
      expect(response).to have_http_status :bad_request
    end
  end

  describe "DELETE /destroy" do
    it "deletes the requested Geolocation record" do
      expect {
        delete geolocations_ip_url(ip: "1.1.1.1"), as: :json
      }.to change(Geolocation, :count).by(-1)
      expect(response).to have_http_status(:no_content)
    end

    it "fails to delete when the specified ip address is not registered" do
      expect {
        delete geolocations_ip_url(ip: "9.9.9.9"), as: :json
      }.to change(Geolocation, :count).by(0)
      expect(response).to have_http_status(:not_found)
    end

    it "fails to delete when the specified ip address is in the wroing format" do
      expect {
        delete geolocations_ip_url(ip: "1.1.1.999"), as: :json
      }.to change(Geolocation, :count).by(0)
      expect(response).to have_http_status(:bad_request)
    end
  end
end
