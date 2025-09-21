class GeolocationsController < ApplicationController
  before_action :set_geolocation, only: %i[ show update destroy ]

  # GET /geolocations
  def index
    @geolocations = Geolocation.all

    render json: @geolocations
  end

  # GET /geolocations/1
  def show
    render json: @geolocation
  end

  # POST /geolocations
  def create
    @geolocation = Geolocation.new(geolocation_params)

    if @geolocation.save
      render json: @geolocation, status: :created, location: @geolocation
    else
      render json: @geolocation.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /geolocations/1
  def update
    if @geolocation.update(geolocation_params)
      render json: @geolocation
    else
      render json: @geolocation.errors, status: :unprocessable_entity
    end
  end

  # DELETE /geolocations/1
  def destroy
    @geolocation.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_geolocation
      @geolocation = Geolocation.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def geolocation_params
      params.expect(geolocation: [ :latitude, :longitude, :ipaddress, :url_fqdn ])
    end
end
