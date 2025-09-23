require "rails_helper"

RSpec.describe "/geolocations/url", type: :request do
  before :each do
    @geolocation = Geolocation.find_or_create_by!({
      latitude: 12.345678,
      longitude: 98.765432,
      ipaddress: "1.1.1.1",
      url_fqdn: "example.com",
    })
  end

  describe "GET /index" do
    it "renders a successful response when correct & registered url is passed" do
      get geolocations_url_url(url: "https://example.com/a/b/c#d?e=f"), as: :json
      expect(response).to be_successful
      res = JSON.parse(response.body)
      expect(res["url_fqdn"]).to eq "example.com"
    end

    it "fails with 404 Not Found when the specified url is not registered" do
      get geolocations_url_url(url: "https://not-registered.com"), as: :json
      expect(response).to have_http_status(:not_found)
    end

    it "fails with 400 Bad Request when the specified url is in the wrong format" do
      get geolocations_url_url(url: "not-a-url"), as: :json
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
        post geolocations_url_index_url, params: { url: "https://test.com" }, as: :json
      }.to change(Geolocation, :count).by(1)
      g = Geolocation.last
      expect(g.url_fqdn).to eq "test.com"
    end

    it "fails with 400 Bad Request when the ip address of the specified url is already registered" do
      expect {
        post geolocations_url_index_url, params: { url: "test.com" }, as: :json
      }.to change(Geolocation, :count).by(0)
      expect(response).to have_http_status :bad_request
    end

    it "fails with 400 Bad Request when the specified url is in the wrong format" do
      expect {
        post geolocations_url_index_url, params: { url: "test" }, as: :json
      }.to change(Geolocation, :count).by(0)
      expect(response).to have_http_status :bad_request
    end
  end

  describe "DELETE /destroy" do
    it "deletes the requested Geolocation record" do
      expect {
        delete geolocations_url_url(url: "https://example.com/a/b/c#d?e=f"), as: :json
      }.to change(Geolocation, :count).by(-1)
      expect(response).to have_http_status(:no_content)
    end

    it "fails to delete when the specified url is not registered" do
      expect {
        delete geolocations_url_url(url: "https://not-registered.com"), as: :json
      }.to change(Geolocation, :count).by(0)
      expect(response).to have_http_status(:not_found)
    end

    it "fails to delete when the specified url is in the wrong format" do
      expect {
        delete geolocations_url_url(url: "not-a-url"), as: :json
      }.to change(Geolocation, :count).by(0)
      expect(response).to have_http_status(:bad_request)
    end
  end
end
