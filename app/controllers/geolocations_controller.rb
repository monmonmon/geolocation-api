class GeolocationsController < ApplicationController
  before_action :set_geolocation, only: %i[ index destroy ]

  def index
    render :show
  end

  def create
    @geolocation =
      if params[:ip].present?
        Geolocation.build_by_ipaddress(params[:ip])
      elsif params[:url].present?
        Geolocation.build_by_url(params[:url])
      end
    if @geolocation&.save
      render :show, status: :created, location: @geolocation
    else
      render json: @geolocation.errors, status: :bad_request
    end
  end

  def destroy
    @geolocation.destroy!
  end

  private
    def set_geolocation
      @geolocation =
        if (ip = params[:ip]).present?
          raise ActionController::BadRequest.new("invalid IP address: #{ip}") unless Resolv::IPv4::Regex.match ip
          Geolocation.find_by!(ipaddress: ip)
        elsif (url = params[:url]).present?
          raise ActionController::BadRequest.new("invalid URL: #{url}") unless URI.regexp.match url
          Geolocation.find_by_url!(url)
        else
          raise ActionController::BadRequest.new("either ip or url parameter is required")
        end
    end

    def geolocation_params
      params.expect(geolocation: [ :latitude, :longitude, :ipaddress, :url_fqdn ])
    end
end
