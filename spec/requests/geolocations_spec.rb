require "rails_helper"

RSpec.describe "/geolocations", type: :request do
  let(:valid_headers) {
    {
      "Content-Type": "application/json"
    }
  }

  before :each do
    @geolocation = Geolocation.find_or_create_by!({
      latitude: 37.330528259277344,
      longitude: -121.83822631835938,
      ipaddress: "1.1.1.1",
      url_fqdn: "example.com",
    })
  end

  describe "GET /index" do
    context "with ip parameter" do
      it "renders a successful response when correct & registered ip address is passed" do
        get geolocations_url(ip: "1.1.1.1"), headers: valid_headers, as: :json
        expect(response).to be_successful
        res = JSON.parse(response.body)
        expect(res["ipaddress"]).to eq "1.1.1.1"
      end

      it "fails with 404 Not Found when the specified ip address is not registered" do
        get geolocations_url(ip: "1.2.3.100"), headers: valid_headers, as: :json
        expect(response).to have_http_status(:not_found)
      end

      it "fails with 400 Bad Request when the specified ip address is in the wroing format" do
        get geolocations_url(ip: "1.2.3.256"), headers: valid_headers, as: :json
        expect(response).to have_http_status(:bad_request)
      end
    end

    context "with url parameter" do
      it "renders a successful response when correct & registered url is passed" do
        get geolocations_url(url: "https://example.com/a/b/c?d=1"), headers: valid_headers, as: :json
        expect(response).to be_successful
        res = JSON.parse(response.body)
        expect(res["url_fqdn"]).to eq "example.com"
      end

      it "fails with 404 Not Found when the specified url is not registered" do
        get geolocations_url(url: "https://hello.com"), headers: valid_headers, as: :json
        expect(response).to have_http_status(:not_found)
      end

      it "fails with 400 Bad Request when the specified url is in the wroing format" do
        get geolocations_url(url: "test"), headers: valid_headers, as: :json
        expect(response).to have_http_status(:bad_request)
      end
    end

    context "without any parameters" do
      it "fails with 400 Bad Request" do
        get geolocations_url, headers: valid_headers, as: :json
        expect(response).to have_http_status(:bad_request)
      end
    end
  end

  describe "POST /create" do
    context "with ip parameter" do
      it "creates a new Geolocation record" do
        expect {
          post geolocations_url, params: { ip: "1.1.1.2" }, headers: valid_headers, as: :json
        }.to change(Geolocation, :count).by(1)
        g = Geolocation.last
        expect(g.ipaddress).to eq "1.1.1.2"
      end

      it "fails with 400 Bad Request when the specified ip address is already registered" do
        expect {
          post geolocations_url, params: { ip: "1.1.1.1" }, headers: valid_headers, as: :json
        }.to change(Geolocation, :count).by(0)
        expect(response).to have_http_status :bad_request
      end

      it "fails with 400 Bad Request when the specified ip address is in the wroing format" do
        expect {
          post geolocations_url, params: { ip: "1.1.1.256" }, headers: valid_headers, as: :json
        }.to change(Geolocation, :count).by(0)
        expect(response).to have_http_status :bad_request
      end
    end

    context "with url parameter" do
      it "creates a new Geolocation record" do
        expect {
          post geolocations_url, params: { url: "https://test.com" }, headers: valid_headers, as: :json
        }.to change(Geolocation, :count).by(1)
        g = Geolocation.last
        expect(g.url_fqdn).to eq "test.com"
      end

      it "updates the url_fqdn column of an existing record if the ip address of the specified url is already registered" do
        skip
      end

      it "fails with 400 Bad Request when the ip address of the specified url is already registered" do
        expect {
          post geolocations_url, params: { url: "test.com" }, headers: valid_headers, as: :json
        }.to change(Geolocation, :count).by(0)
        expect(response).to have_http_status :bad_request
      end

      it "fails with 400 Bad Request when the specified url is in the wroing format" do
        expect {
          post geolocations_url, params: { url: "test" }, headers: valid_headers, as: :json
        }.to change(Geolocation, :count).by(0)
        expect(response).to have_http_status :bad_request
      end
    end

    context "without any parameters" do
      it "fails with 400 Bad Request" do
        expect {
          post geolocations_url, headers: valid_headers, as: :json
        }.to change(Geolocation, :count).by(0)
        expect(response).to have_http_status :bad_request
      end
    end
  end

  # describe "DELETE /destroy" do
  #   context "with ip parameter" do
  #     it "deletes the requested Geolocation record" do
  #       expect {
  #         delete geolocation_url, params: { ip: "1.1.1.1" }, headers: valid_headers, as: :json
  #       }.to change(Geolocation, :count).by(-1)
  #       expect(response).to have_http_status(:ok)
  #     end
  #   end
  #
  #   context "with url parameter" do
  #   end
  #
  #   context "without any parameters" do
  #   end
  #
  #   # it "destroys the requested geolocation" do
  #   #   geolocation = Geolocation.create! valid_attributes
  #   #   expect {
  #   #     delete geolocation_url(geolocation), headers: valid_headers, as: :json
  #   #   }.to change(Geolocation, :count).by(-1)
  #   # end
  # end
end
