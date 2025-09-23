class Geolocations::IpController < ApplicationController
  before_action :set_geolocation, only: %i[show destroy]

  def show
    render
  end

  def create
    @geolocation = Geolocation.build_by_ipaddress(params[:ip]) rescue nil
    if @geolocation&.save
      render :show, status: :created
    else
      render json: @geolocation.errors, status: :bad_request
    end
  end

  def destroy
    @geolocation.destroy!
  end

  private
    def set_geolocation
      raise ActionController::BadRequest.new("invalid IP address: #{params[:ip]}") unless Resolv::IPv4::Regex.match params[:ip]
      @geolocation = Geolocation.find_by!(ipaddress: params[:ip])
    end
end
